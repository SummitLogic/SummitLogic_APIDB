# Role Format Conversion Fix

## Problem
The frontend was sending role values like `"Flight Crew"` and `"Ground Crew"` (with spaces), but the database ENUM only accepts `'FlightCrew'` and `'GroundCrew'` (camelCase, no spaces).

This caused the error:
```
Data truncated for column 'role' at row 1
sqlMessage: "Data truncated for column 'role' at row 1"
```

## Solution
Added automatic role format conversion between frontend and database formats.

### What Was Fixed

#### 1. **authController.ts** - Added conversion functions
```typescript
// Convert frontend role format to database format
const convertRoleToDatabase = (frontendRole: string): string => {
  const roleMap: Record<string, string> = {
    'Flight Crew': 'FlightCrew',
    'FlightCrew': 'FlightCrew',
    'Ground Crew': 'GroundCrew',
    'GroundCrew': 'GroundCrew',
  };
  return roleMap[frontendRole] || frontendRole;
};

// Convert database role format to frontend format
const convertRoleToFrontend = (dbRole: string): string => {
  const roleMap: Record<string, string> = {
    'FlightCrew': 'Flight Crew',
    'GroundCrew': 'Ground Crew',
    'Supervisor': 'Supervisor',
  };
  return roleMap[dbRole] || dbRole;
};
```

#### 2. **Register Endpoint**
- Accepts both `"Flight Crew"` (frontend) and `"FlightCrew"` (database) formats
- Converts to database format before INSERT
- Returns converted role back to `"Flight Crew"` format in response

#### 3. **Login Endpoint**
- Reads role from database in `'FlightCrew'` format
- Converts back to `"Flight Crew"` format for the response

#### 4. **Type Definitions** - Updated `user.ts`
- `UserRole` now accepts all valid values: `'Flight Crew' | 'Ground Crew' | 'FlightCrew' | 'GroundCrew' | 'Supervisor'`
- `RegisterRequest` accepts both formats via `role: UserRole | string`

## How It Works

### Registration Flow
```
Frontend sends: { role: "Flight Crew" }
  ↓
convertRoleToDatabase("Flight Crew") → "FlightCrew"
  ↓
Database INSERT: role = "FlightCrew" ✅
  ↓
convertRoleToFrontend("FlightCrew") → "Flight Crew"
  ↓
Response to frontend: { role: "Flight Crew" }
```

### Login Flow
```
Frontend sends: { email, password }
  ↓
Database returns: { role: "FlightCrew" }
  ↓
convertRoleToFrontend("FlightCrew") → "Flight Crew"
  ↓
Response to frontend: { role: "Flight Crew" }
```

## Frontend Compatibility
✅ **Frontend can send either format:**
- `"Flight Crew"` (with space) ✅ Works
- `"FlightCrew"` (camelCase) ✅ Works
- `"Ground Crew"` (with space) ✅ Works
- `"GroundCrew"` (camelCase) ✅ Works

## Testing

### Test with spaces (recommended):
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "username": "johndoe",
  "role": "Flight Crew",
  "password": "SecurePassword123"
}
```

### Response:
```json
{
  "success": true,
  "message": "User registered successfully",
  "token": "eyJ...",
  "user": {
    "id": "123",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "username": "johndoe",
    "role": "Flight Crew"
  }
}
```

## Build Status
✅ TypeScript compilation successful - no errors
