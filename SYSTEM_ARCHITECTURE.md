# QR SCANNER SYSTEM ARCHITECTURE

## System Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SUMMITLOGIC QR SCANNER SYSTEM                        │
└─────────────────────────────────────────────────────────────────────────────┘

                              FRONTEND LAYER
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  ┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐    │
│  │  QR Scanner      │    │  Camera/         │    │  Barcode         │    │
│  │  Component       │ ─→ │  Scanner Input   │ ─→ │  Parser          │    │
│  │  (html5-qrcode)  │    │                  │    │                  │    │
│  └──────────────────┘    └──────────────────┘    └──────────────────┘    │
│                                                                             │
│           QR URL Data (e.g., data:application/json,...)                  │
│                            │                                              │
│                            ▼                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │ UI Logic & Event Handlers                                          │ │
│  │ - Display bottle info                                              │ │
│  │ - Show success/error feedback                                      │ │
│  │ - Log scan events                                                  │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                   POST /api/scanner/validate
                   { qr_url, flight_id, event_type }
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        API GATEWAY / MIDDLEWARE                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ Authentication: Verify JWT Token                                    │ │
│  │ ✓ Valid? Continue to endpoint                                       │ │
│  │ ✗ Invalid? Return 401/403 Error                                     │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ CORS Middleware: Allow cross-origin requests                        │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          BACKEND LAYER (Express)                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐        │
│  │ Scanner Routes   │  │ Inventory Routes │  │ Other Routes     │        │
│  │ (/scanner)       │  │ (/inventory)     │  │ (/auth, etc.)    │        │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘        │
│           │                                                                │
│           ├─→ POST /validate              (Single QR)                     │
│           ├─→ POST /validate/batch        (Multiple QRs)                  │
│           └─→ GET /qr-codes               (Reference)                     │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │                    SCANNER CONTROLLER                               │ │
│  ├─────────────────────────────────────────────────────────────────────┤ │
│  │                                                                      │ │
│  │  ┌──────────────────────────────────────────────────────────┐     │ │
│  │  │ validateQRCode()                                         │     │ │
│  │  │ - Receives: { qr_url, flight_id, event_type }          │     │ │
│  │  │ - Queries database for matching bottle                 │     │ │
│  │  │ - If found: verified = true, return bottle_data        │     │ │
│  │  │ - If not found: verified = false                        │     │ │
│  │  │ - Auto-create bottle_event if event_type provided      │     │ │
│  │  └──────────────────────────────────────────────────────────┘     │ │
│  │                                                                      │ │
│  │  ┌──────────────────────────────────────────────────────────┐     │ │
│  │  │ validateQRCodeBatch()                                    │     │ │
│  │  │ - Receives: { qr_urls: [], flight_id }                 │     │ │
│  │  │ - Queries all QRs efficiently                           │     │ │
│  │  │ - Returns array of results                              │     │ │
│  │  │ - Includes summary: {total, verified, not_verified}    │     │ │
│  │  └──────────────────────────────────────────────────────────┘     │ │
│  │                                                                      │ │
│  │  ┌──────────────────────────────────────────────────────────┐     │ │
│  │  │ getKnownQRCodes()                                        │     │ │
│  │  │ - Query params: airline_id?, status?, beverage_id?     │     │ │
│  │  │ - Returns all QR codes matching filters                │     │ │
│  │  │ - Used for: staff reference, inventory checks          │     │ │
│  │  └──────────────────────────────────────────────────────────┘     │ │
│  │                                                                      │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                     Database Query: WHERE qr_url = ?
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          DATABASE LAYER (MySQL)                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │ TABLE: bottle_instances                                            │  │
│  ├────────────────────────────────────────────────────────────────────┤  │
│  │ id│beverage_id│airline_id│qr_code│qr_url│batch_code│...         │  │
│  ├──┼───────────┼──────────┼───────┼──────┼──────────┼─────────────┤  │
│  │ 1│     11    │    1     │  NULL │ data:...│BATCH-AMX-001      │  │
│  │ 2│      9    │    1     │  NULL │ data:...│BATCH-AMX-002      │  │
│  │ 3│     12    │    1     │  NULL │ data:...│BATCH-AMX-003      │  │
│  │ ..                                                               │  │
│  │45│     10    │   11     │  NULL │ data:...│BATCH-ANA-045      │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │ TABLE: bottle_events (Auto-created)                               │  │
│  ├────────────────────────────────────────────────────────────────────┤  │
│  │ id│bottle_id│flight_id│user_id│event_type│amount_ml│created_at  │  │
│  ├──┼─────────┼────────┼───────┼──────────┼────────┼──────────────┤  │
│  │ 1│    1    │   1    │  NULL │  Scan    │  NULL  │ 2025-10-26   │  │
│  │ 2│    1    │   1    │  NULL │  Place   │  NULL  │ 2025-10-26   │  │
│  │ ..                                                               │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │ TABLE: items                                                       │  │
│  ├────────────────────────────────────────────────────────────────────┤  │
│  │ id│ name     │ brand  │ category │ size_desc │ alcohol_pct        │  │
│  ├──┼──────────┼───────┼─────────┼─────────┼───────────────────────┤  │
│  │ 9│Red Wine │Santa R│ Beverage│  187ml │ 12.5%                 │  │
│  │10│White Win│Rieslin│ Beverage│  187ml │ 11.0%                 │  │
│  │11│ Beer    │Corona │ Beverage│  355ml │  4.6%                 │  │
│  │12│Whiskey  │Jack D │ Beverage│   50ml │ 40.0%                 │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │ TABLE: airlines                                                    │  │
│  ├────────────────────────────────────────────────────────────────────┤  │
│  │ id│ name         │ iata │ icao │                                  │  │
│  ├──┼──────────────┼─────┼─────┼────────────────────────────────────┤  │
│  │ 1│Aeromexico    │ AM  │ AMX │                                    │  │
│  │ 2│Volaris      │ Y4  │ VOI │                                    │  │
│  │ ...                                                               │  │
│  │11│ANA (All Nip)│ NH  │ ANA │                                    │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                       Query Result: Found/Not Found
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    RESPONSE HANDLING & LOGGING                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  IF BOTTLE FOUND:                   IF NOT FOUND:                         │
│  ┌──────────────────────┐          ┌──────────────────────┐              │
│  │ ✅ verified: true    │          │ ❌ verified: false   │              │
│  ├──────────────────────┤          ├──────────────────────┤              │
│  │ Return bottle_data:  │          │ Return error msg     │              │
│  │ - bottle_id          │          │ "Not recognized"     │              │
│  │ - item_name          │          └──────────────────────┘              │
│  │ - airline_name       │                                                │
│  │ - current_pct        │          Optional: Create Event                │
│  │ - status             │          ┌──────────────────────┐              │
│  │ - batch_code         │          │ INSERT bottle_events │              │
│  └──────────────────────┘          │ IF event_type given  │              │
│                                     └──────────────────────┘              │
│  Optional: Create Event                                                  │
│  ┌──────────────────────┐                                               │
│  │ INSERT bottle_events │                                               │
│  │ - bottle_id          │                                               │
│  │ - flight_id          │                                               │
│  │ - event_type: Scan   │                                               │
│  │ - created_at: NOW()  │                                               │
│  └──────────────────────┘                                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                     HTTP Response: 200 OK + JSON
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                     FRONTEND RECEIVES RESPONSE                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │ if (result.verified) {                                              │ │
│  │   // ✅ QR recognized - Bottle is in system                        │ │
│  │   showSuccess(result.data.item_name);                              │ │
│  │   playSuccessSound();                                              │ │
│  │   updateUI(result.data);                                           │ │
│  │   return true;  // ← KEY LINE                                      │ │
│  │ } else {                                                            │ │
│  │   // ❌ Unknown QR - Bottle NOT in system                          │ │
│  │   showError("QR not recognized");                                  │ │
│  │   playErrorSound();                                                │ │
│  │   return false;  // ← KEY LINE                                     │ │
│  │ }                                                                   │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  UI Updates:                                                              │
│  ✅ Success: Display bottle info, play sound, update counter             │
│  ❌ Failure: Show alert, update error count, suggest retry              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Data Flow Sequence

```
TIME │ COMPONENT      │ ACTION
─────┼────────────────┼──────────────────────────────────────────────
  0  │ Frontend       │ User positions camera on QR code
     │                │
  1  │ Scanner        │ Captures QR data → extracts URL
     │                │ data:application/json,%7B...
     │                │
  2  │ Network        │ POST /api/scanner/validate
     │                │ Header: Authorization: Bearer <JWT>
     │                │ Body: { qr_url, flight_id, event_type }
     │                │
  3  │ API Gateway    │ Validate JWT token
     │                │ ✓ Authenticated → Continue
     │                │ ✗ Failed → Return 401/403
     │                │
  4  │ Controller     │ Receive request
     │                │ validateQRCode(qr_url)
     │                │
  5  │ Database Query │ SELECT FROM bottle_instances
     │                │ WHERE qr_url = ?
     │                │
  6  │ Database       │ Execute query
     │                │ ✓ Row found → return bottle data
     │                │ ✗ No row → return empty result
     │                │
  7  │ Controller     │ Process result
     │                │ ✓ Bottle found: verified = true
     │                │ ✗ Bottle not found: verified = false
     │                │
  8  │ Event Logger   │ INSERT bottle_event (optional)
     │ (Optional)     │ Links: bottle_id, flight_id, event_type
     │                │
  9  │ Response       │ Build JSON response
     │                │ { success, verified, data }
     │                │
 10  │ Network        │ Send HTTP 200 OK + JSON
     │                │
 11  │ Frontend       │ Receive response
     │                │ Parse JSON
     │                │ Check result.verified (true/false)
     │                │
 12  │ UI Logic       │ ✓ verified: true → Show success
     │                │ ✗ verified: false → Show error
     │                │
 13  │ UX             │ Play sound, update display
     │                │ Update scan counter
     │                │ Log to audit trail
     │                │
 14  │ User           │ See result: ✅ Recognized / ❌ Unknown
```

---

## Component Interactions

```
┌─────────────────┐
│   FRONTEND      │
│   QR SCANNER    │
└────────┬────────┘
         │
         │ Scan event + QR data
         ▼
┌─────────────────────────────┐
│   REACT COMPONENT           │
│   - Handles camera          │
│   - Parses QR URL           │
│   - Calls API               │
└────────┬────────────────────┘
         │
         │ HTTP POST
         ▼
┌─────────────────────────────┐
│   EXPRESS.JS API            │
│   /api/scanner/validate     │
└────────┬────────────────────┘
         │
         │ Query
         ▼
┌─────────────────────────────┐
│   MYSQL DATABASE            │
│   bottle_instances table    │
└────────┬────────────────────┘
         │
         │ Query result: Found/NotFound
         ▼
┌─────────────────────────────┐
│   SCANNER CONTROLLER        │
│   - Build response          │
│   - verified: true/false    │
│   - Create events (optional)│
└────────┬────────────────────┘
         │
         │ HTTP 200 + JSON
         ▼
┌─────────────────────────────┐
│   FRONTEND UI               │
│   - Show verified result    │
│   - Display bottle info     │
│   - Play success/error      │
└─────────────────────────────┘
```

---

## Authentication Flow

```
┌──────────────────────────────────────────────────────┐
│ 1. Frontend has JWT token (from login)               │
│    token = "eyJhbGciOiJIUzI1NiIs..."               │
└──────────────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────────────┐
│ 2. Include in request header                         │
│    Authorization: Bearer eyJhbGciOiJIUzI1NiIs...    │
└──────────────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────────────┐
│ 3. API receives request                              │
│    authenticateToken middleware                      │
└──────────────────────────────────────────────────────┘
                      │
              ┌───────┴───────┐
              ▼               ▼
        ✅ Token Valid    ❌ Token Invalid
              │               │
              ▼               ▼
        Continue to       Return 401/403
        endpoint          Unauthorized
              │               │
              ├───────┬───────┤
              ▼
        ┌─────────────────┐
        │ Process request │
        │ in controller   │
        └─────────────────┘
```

---

## Error Handling Flow

```
API Request
    │
    ├─ No QR URL provided?
    │  └─→ 400 Bad Request: "QR URL required"
    │
    ├─ Invalid JWT?
    │  └─→ 401 Unauthorized: "Access token required"
    │
    ├─ Expired JWT?
    │  └─→ 403 Forbidden: "Invalid or expired token"
    │
    ├─ Database error?
    │  └─→ 500 Server Error: "Error validating QR code"
    │
    ├─ QR not found in DB?
    │  └─→ 200 OK: { verified: false, message: "Not recognized" }
    │
    └─ Success (Bottle found)?
       └─→ 200 OK: { verified: true, data: {...} }
```

---

**This architecture ensures:**
- ✅ Secure authentication on all requests
- ✅ Efficient database queries
- ✅ Clear boolean response (verified: true/false)
- ✅ Automatic audit trail (bottle_events)
- ✅ Scalable for high-throughput scanning
- ✅ Error handling at each layer
