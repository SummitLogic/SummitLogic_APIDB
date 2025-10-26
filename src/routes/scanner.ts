// ============================================================================
// QR Scanner Routes
// File: src/routes/scanner.ts
// ============================================================================
// Routes for QR code validation and bottle instance verification

import { Router } from 'express';
import { authenticateToken } from '../middleware/auth';
import {
  validateQRCode,
  validateQRCodeBatch,
  getKnownQRCodes,
  getKnownQRCodesFromDB,
} from '../controllers/scannerController';

const router = Router();

// Apply authentication middleware to all routes
router.use(authenticateToken);

// ============================================================================
// QR CODE VALIDATION ROUTES
// ============================================================================

/**
 * POST /api/scanner/validate
 * Validate a single QR code and get bottle details
 * Body: { qr_url: string, flight_id?: number, event_type?: string, amount_ml?: number }
 */
router.post('/validate', validateQRCode);

/**
 * POST /api/scanner/validate/batch
 * Validate multiple QR codes in one request
 * Body: { qr_urls: string[], flight_id?: number }
 */
router.post('/validate/batch', validateQRCodeBatch);

/**
 * GET /api/scanner/qr-codes
 * Get all known QR codes in the system (for reference/validation)
 * Query: airline_id?, status?, beverage_id?
 */
router.get('/qr-codes', getKnownQRCodes);

/**
 * GET /api/scanner/known-qrs
 * Get all QR codes from the known_qr_codes table (validates against this table)
 */
router.get('/known-qrs', getKnownQRCodesFromDB);

export default router;
