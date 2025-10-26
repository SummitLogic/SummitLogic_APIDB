// ============================================================================
// QR Scanner Endpoint - Bottle Instance Verification
// File: src/controllers/scannerController.ts
// ============================================================================
// This endpoint handles QR code scanning from the frontend, validates the QR
// against the database of known bottles, and updates bottle instance status.

import type { Response } from 'express';
import type { AuthRequest } from '../middleware/auth';
import pool from '../config/database';

// ============================================================================
// INTERFACE FOR SCANNER REQUEST/RESPONSE
// ============================================================================

interface ScannerRequest {
  qr_url: string;           // The QR URL scanned from the QR code
  flight_id: number;        // Optional: the current flight context
  event_type?: string;      // Optional: event type (e.g., 'Scan', 'Place', 'Use')
  amount_ml?: number;       // Optional: amount used (for consumption events)
}

interface ScannerResponse {
  success: boolean;
  verified: boolean;        // true if QR matches a known bottle
  message: string;
  data?: {
    bottle_id: number;
    item_name: string;
    airline_name: string;
    current_pct: number;
    status: string;
    batch_code: string;
  };
  error?: string;
}

// ============================================================================
// VALIDATE QR CODE AND RETURN BOTTLE DETAILS
// ============================================================================
/**
 * POST /api/inventory/scan
 * 
 * Validates a scanned QR URL against the database and returns bottle details
 * if found. Can optionally create a bottle_event entry for tracking.
 * 
 * Request body:
 * {
 *   "qr_url": "data:application/json,...",
 *   "flight_id": 1,
 *   "event_type": "Scan",
 *   "amount_ml": null
 * }
 * 
 * Response:
 * {
 *   "success": true,
 *   "verified": true,
 *   "message": "QR code validated successfully",
 *   "data": {
 *     "bottle_id": 5,
 *     "item_name": "Beer",
 *     "airline_name": "Aeromexico",
 *     "current_pct": 100.00,
 *     "status": "InFlight",
 *     "batch_code": "BATCH-AMX-2501-001"
 *   }
 * }
 */
export const validateQRCode = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { qr_url, flight_id, event_type = 'Scan', amount_ml } = req.body as ScannerRequest;

    // Validate input
    if (!qr_url || qr_url.trim() === '') {
      res.status(400).json({
        success: false,
        verified: false,
        message: 'QR URL is required',
        error: 'Missing required field: qr_url',
      } as ScannerResponse);
      return;
    }

    const connection = await pool.getConnection();
    try {
      // First, validate QR URL against known_qr_codes table
      const [knownQRs] = await connection.query(
        `SELECT qr_url FROM known_qr_codes WHERE qr_url = ? LIMIT 1`,
        [qr_url]
      );

      const knownQRList = knownQRs as any[];

      if (knownQRList.length === 0) {
        // QR not in known_qr_codes table
        res.status(200).json({
          success: true,
          verified: false,
          message: 'QR code not recognized in system',
          error: 'QR URL not in known QR codes database',
        } as ScannerResponse);
        return;
      }

      // QR is known, now get bottle details
      const [bottles] = await connection.query(
        `
        SELECT 
          bi.id,
          bi.beverage_item_id,
          bi.airline_id,
          bi.current_pct,
          bi.status,
          bi.batch_code,
          i.name as item_name,
          a.name as airline_name
        FROM bottle_instances bi
        JOIN items i ON bi.beverage_item_id = i.id
        JOIN airlines a ON bi.airline_id = a.id
        WHERE bi.qr_url = ?
        LIMIT 1
        `,
        [qr_url]
      );

      const bottleList = bottles as any[];

      if (bottleList.length === 0) {
        // QR not recognized
        res.status(200).json({
          success: true,
          verified: false,
          message: 'QR code not recognized in system',
          error: 'No matching bottle found for this QR code',
        } as ScannerResponse);
        return;
      }

      // QR verified - bottle found
      const bottle = bottleList[0];

      // If event_type and flight_id provided, create a bottle_event entry
      if (event_type && flight_id) {
        try {
          // Determine pct_after based on event type
          let pctAfter = bottle.current_pct;
          if (event_type === 'PartialUse' && amount_ml) {
            pctAfter = Math.max(0, bottle.current_pct - (amount_ml / 100) * 100);
          }

          // Insert bottle event
          await connection.query(
            `
            INSERT INTO bottle_events (bottle_id, flight_id, user_id, event_type, amount_ml, pct_after, created_at)
            VALUES (?, ?, ?, ?, ?, ?, NOW())
            `,
            [bottle.id, flight_id, null, event_type, amount_ml || null, pctAfter]
          );
        } catch (eventError) {
          console.warn('Could not create bottle event:', eventError);
          // Non-critical error - still return success for bottle validation
        }
      }

      res.json({
        success: true,
        verified: true,
        message: 'QR code validated successfully',
        data: {
          bottle_id: bottle.id,
          item_name: bottle.item_name,
          airline_name: bottle.airline_name,
          current_pct: bottle.current_pct,
          status: bottle.status,
          batch_code: bottle.batch_code,
        },
      } as ScannerResponse);
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('QR validation error:', error);
    res.status(500).json({
      success: false,
      verified: false,
      message: 'Error validating QR code',
      error: error instanceof Error ? error.message : 'Unknown error',
    } as ScannerResponse);
  }
};

// ============================================================================
// BATCH VALIDATE QR CODES
// ============================================================================
/**
 * POST /api/inventory/scan/batch
 * 
 * Validates multiple QR codes in a single request (useful for high-throughput scanning)
 * 
 * Request body:
 * {
 *   "qr_urls": ["data:application/json,...", "data:application/json,..."],
 *   "flight_id": 1
 * }
 * 
 * Response:
 * {
 *   "success": true,
 *   "results": [
 *     { "qr_url": "...", "verified": true, "bottle_id": 5, ... },
 *     { "qr_url": "...", "verified": false, "error": "Not found" }
 *   ]
 * }
 */
export const validateQRCodeBatch = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { qr_urls, flight_id } = req.body as {
      qr_urls: string[];
      flight_id?: number;
    };

    if (!Array.isArray(qr_urls) || qr_urls.length === 0) {
      res.status(400).json({
        success: false,
        message: 'qr_urls must be a non-empty array',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      // Build placeholders for IN query
      const placeholders = qr_urls.map(() => '?').join(',');

      // First, validate QR URLs against known_qr_codes table
      const [knownQRs] = await connection.query(
        `
        SELECT qr_url FROM known_qr_codes 
        WHERE qr_url IN (${placeholders})
        `,
        qr_urls
      );

      const knownQRList = knownQRs as any[];
      const knownQRMap = new Map(knownQRList.map(kqr => [kqr.qr_url, true]));

      // Get bottle details for known QR codes
      const [bottles] = await connection.query(
        `
        SELECT 
          bi.id,
          bi.qr_url,
          bi.beverage_item_id,
          bi.airline_id,
          bi.current_pct,
          bi.status,
          bi.batch_code,
          i.name as item_name,
          a.name as airline_name
        FROM bottle_instances bi
        JOIN items i ON bi.beverage_item_id = i.id
        JOIN airlines a ON bi.airline_id = a.id
        WHERE bi.qr_url IN (${placeholders})
        `,
        qr_urls
      );

      const bottleList = bottles as any[];
      const results: any[] = [];

      // Create a map for fast lookup
      const bottleMap = new Map(bottleList.map(b => [b.qr_url, b]));

      // Process each QR URL
      for (const qr_url of qr_urls) {
        // Check if QR is in known_qr_codes
        if (!knownQRMap.has(qr_url)) {
          results.push({
            qr_url,
            verified: false,
            error: 'QR code not in known QR codes database',
          });
          continue;
        }

        const bottle = bottleMap.get(qr_url);

        if (bottle) {
          results.push({
            qr_url,
            verified: true,
            bottle_id: bottle.id,
            item_name: bottle.item_name,
            airline_name: bottle.airline_name,
            current_pct: bottle.current_pct,
            status: bottle.status,
            batch_code: bottle.batch_code,
          });
        } else {
          results.push({
            qr_url,
            verified: false,
            error: 'Not found in system',
          });
        }
      }

      const verified_count = results.filter(r => r.verified).length;
      const not_verified_count = results.filter(r => !r.verified).length;

      res.json({
        success: true,
        message: `Batch validation complete: ${verified_count} verified, ${not_verified_count} not recognized`,
        results,
        summary: {
          total: qr_urls.length,
          verified: verified_count,
          not_verified: not_verified_count,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Batch QR validation error:', error);
    res.status(500).json({
      success: false,
      message: 'Error validating QR codes',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

// ============================================================================
// GET KNOWN QR CODES FROM DATABASE
// ============================================================================
/**
 * GET /api/scanner/known-qrs
 * 
 * Returns all known QR codes from the known_qr_codes table
 * Used by scanner endpoint to validate incoming QR codes
 * 
 * Response:
 * {
 *   "success": true,
 *   "data": [
 *     { "id": 1, "beverage_name": "Red Wine", "qr_url": "https://..." },
 *     ...
 *   ]
 * }
 */
export const getKnownQRCodesFromDB = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const connection = await pool.getConnection();
    try {
      const [codes] = await connection.query(
        `
        SELECT 
          id,
          beverage_name,
          qr_url,
          created_at,
          updated_at
        FROM known_qr_codes
        ORDER BY beverage_name
        `
      );

      res.json({
        success: true,
        data: codes,
        count: (codes as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get known QR codes error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching known QR codes',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

// ============================================================================
// GET KNOWN QR CODES (for frontend reference)
// ============================================================================
/**
 * GET /api/inventory/scan/qr-codes
 * 
 * Returns a list of all known QR codes in the system for reference/validation
 * Optionally filter by airline, status, or beverage type
 * 
 * Query parameters:
 * - airline_id: number (optional)
 * - status: string (optional) - e.g., 'InFlight', 'Returned', 'Kept'
 * - beverage_id: number (optional)
 * 
 * Response:
 * {
 *   "success": true,
 *   "data": [
 *     { "bottle_id": 5, "qr_url": "data:...", "item_name": "Beer", ... },
 *     ...
 *   ]
 * }
 */
export const getKnownQRCodes = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { airline_id, status, beverage_id } = req.query;

    let query = `
      SELECT 
        bi.id as bottle_id,
        bi.qr_url,
        bi.qr_code,
        bi.batch_code,
        bi.status,
        bi.current_pct,
        i.name as item_name,
        i.id as item_id,
        a.name as airline_name,
        a.id as airline_id
      FROM bottle_instances bi
      JOIN items i ON bi.beverage_item_id = i.id
      JOIN airlines a ON bi.airline_id = a.id
      WHERE bi.qr_url IS NOT NULL
    `;

    const params: any[] = [];

    if (airline_id) {
      query += ' AND bi.airline_id = ?';
      params.push(airline_id);
    }

    if (status) {
      query += ' AND bi.status = ?';
      params.push(status);
    }

    if (beverage_id) {
      query += ' AND bi.beverage_item_id = ?';
      params.push(beverage_id);
    }

    query += ' ORDER BY a.name, i.name';

    const connection = await pool.getConnection();
    try {
      const [codes] = await connection.query(query, params);
      res.json({
        success: true,
        data: codes,
        count: (codes as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get QR codes error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching QR codes',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};
