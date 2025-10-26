// ============================================================================
// Scanner Types and Interfaces
// File: src/types/scanner.ts
// ============================================================================

/**
 * Request/Response types for QR Scanner endpoints
 */

// ============================================================================
// SCANNER REQUEST TYPES
// ============================================================================

export interface ValidateQRRequest {
  qr_url: string;           // The QR URL scanned from QR code
  flight_id?: number;       // Optional: current flight context
  event_type?: string;      // Optional: 'Scan', 'Place', 'PartialUse', 'Discard', 'Return'
  amount_ml?: number;       // Optional: amount used (for PartialUse events)
}

export interface ValidateQRBatchRequest {
  qr_urls: string[];        // Array of QR URLs to validate
  flight_id?: number;       // Optional: flight context for batch
}

export interface GetQRCodesQuery {
  airline_id?: number;      // Filter by airline ID
  status?: string;          // Filter by bottle status
  beverage_id?: number;     // Filter by beverage/item ID
}

// ============================================================================
// SCANNER RESPONSE TYPES
// ============================================================================

export interface BottleData {
  bottle_id: number;        // Unique bottle instance ID
  item_name: string;        // Name of beverage (Beer, Wine, etc.)
  airline_name: string;     // Airline that owns the bottle
  current_pct: number;      // Current fill percentage
  status: string;           // Bottle status (InFlight, Returned, etc.)
  batch_code: string;       // Batch code for tracking
}

export interface ValidateQRResponse {
  success: boolean;
  verified: boolean;        // TRUE = known QR, FALSE = unknown QR
  message: string;
  data?: BottleData;       // Present only if verified = true
  error?: string;          // Error message if not verified
}

export interface ValidateBatchResult {
  qr_url: string;
  verified: boolean;
  bottle_id?: number;
  item_name?: string;
  airline_name?: string;
  current_pct?: number;
  status?: string;
  batch_code?: string;
  error?: string;
}

export interface ValidateQRBatchResponse {
  success: boolean;
  message: string;
  results: ValidateBatchResult[];
  summary: {
    total: number;
    verified: number;
    not_verified: number;
  };
}

export interface QRCodeReference {
  bottle_id: number;
  qr_url: string;
  qr_code?: string;
  batch_code: string;
  status: string;
  current_pct: number;
  item_name: string;
  item_id: number;
  airline_name: string;
  airline_id: number;
}

export interface GetQRCodesResponse {
  success: boolean;
  data: QRCodeReference[];
  count: number;
}

// ============================================================================
// ERROR RESPONSE TYPES
// ============================================================================

export interface ErrorResponse {
  success: false;
  message: string;
  error?: string;
}

// ============================================================================
// EVENT TYPES
// ============================================================================

export type BottleEventType = 'Scan' | 'Place' | 'PartialUse' | 'Discard' | 'Return' | 'Combine';

export interface BottleEvent {
  id: number;
  bottle_id: number;
  flight_id: number;
  user_id: number | null;
  event_type: BottleEventType;
  amount_ml: number | null;
  pct_after: number;
  created_at: string;
}

// ============================================================================
// BOTTLE STATUS TYPES
// ============================================================================

export type BottleStatus = 'InFlight' | 'Returned' | 'Kept' | 'Combined' | 'Discarded';

export interface BottleInstance {
  id: number;
  beverage_item_id: number;
  airline_id: number;
  qr_code: string | null;
  qr_url: string | null;
  batch_code: string | null;
  initial_volume_ml: number;
  current_pct: number;
  status: BottleStatus;
  last_flight_id: number | null;
  created_at: string;
  updated_at: string;
}

// ============================================================================
// BEVERAGE TYPES
// ============================================================================

export interface Beverage {
  id: number;
  name: string;
  brand: string;
  category: 'Beverage';
  unit_desc: string;
  size_desc: string;
  notes: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  inventory_status?: string;
  rating?: number;
  url?: string;
}

export interface BeverageDetails {
  item_id: number;
  type: string;
  flavour: string;
  volume_ml: number;
  alcohol_pct: number | null;
  default_pack_qty: number;
}

// ============================================================================
// AIRLINE TYPES
// ============================================================================

export interface Airline {
  id: number;
  name: string;
  iata_code: string;
  icao_code: string;
}

// ============================================================================
// FLIGHT TYPES
// ============================================================================

export interface Flight {
  id: number;
  airline_id: number;
  flight_number: string;
  direction: string;
  aircraft_type: string;
  departure_airport: string;
  arrival_airport: string;
  scheduled_departure: string;
  scheduled_arrival: string;
  capacity_seats: number;
  load_factor_pct: number;
  service_date: string;
}

// ============================================================================
// UTILITY TYPES
// ============================================================================

/**
 * Query parameters for GET /api/scanner/qr-codes
 */
export interface QRCodesQueryParams {
  airline_id?: string | number;
  status?: string;
  beverage_id?: string | number;
}

/**
 * Response wrapper for paginated results (future enhancement)
 */
export interface PaginatedResponse<T> {
  success: boolean;
  data: T[];
  count: number;
  page?: number;
  total_pages?: number;
}
