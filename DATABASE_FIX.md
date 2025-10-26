# Database Schema Mismatch Fix

## Problem
The registration endpoint was failing with:
```
Register error: Error: Unknown column 'firstName' in 'field list'
```

## Root Cause
The API controller code was using **camelCase column names** while the actual database schema uses **snake_case column names**.

### Column Name Mismatch

| Database Actual | Code Was Using | Fixed |
|---|---|---|
| `first_name` | `firstName` | ✅ `first_name` |
| `last_name` | `lastName` | ✅ `last_name` |
| `password_hash` | `password` | ✅ `password_hash` |
| `role` | `role` | ✅ (already correct) |
| `username` | `username` | ✅ (already correct) |
| `email` | `email` | ✅ (already correct) |

## Files Fixed

### 1. `src/controllers/authController.ts`

**Register Function - INSERT Statement:**
```typescript
// BEFORE (❌ Wrong column names)
'INSERT INTO users (firstName, lastName, email, username, role, password) VALUES (?, ?, ?, ?, ?, ?)'

// AFTER (✅ Correct column names)
'INSERT INTO users (first_name, last_name, email, username, role, password_hash) VALUES (?, ?, ?, ?, ?, ?)'
```

**Login Function - Password Field:**
```typescript
// BEFORE (❌ Wrong column name)
const isPasswordValid = await bcrypt.compare(password, user.password);

// AFTER (✅ Correct column name)
const isPasswordValid = await bcrypt.compare(password, user.password_hash);
```

**Login Function - Response Mapping:**
```typescript
// BEFORE (❌ Wrong column names)
user: {
  firstName: user.firstName,
  lastName: user.lastName,
}

// AFTER (✅ Correct column names and added missing fields)
user: {
  firstName: user.first_name,
  lastName: user.last_name,
  username: user.username,
  role: user.role,
}
```

## Valid Role Values
The database schema defines roles as an ENUM with these valid values:
- `'FlightCrew'` (NOT "Flight Crew" - no spaces, camelCase in DB)
- `'GroundCrew'` (NOT "Ground Crew" - no spaces, camelCase in DB)
- `'Supervisor'`

⚠️ **Note:** The frontend is sending `"Flight Crew"` and `"Ground Crew"` but the database expects `"FlightCrew"` and `"GroundCrew"`. You may need to update either:
1. The database to accept the values with spaces, OR
2. The frontend to send camelCase values

## Testing
After deploying this fix, test registration with:
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "username": "johndoe",
    "role": "FlightCrew",
    "password": "SecurePassword123"
  }'
```

## Build Status
✅ TypeScript compilation successful - no errors
