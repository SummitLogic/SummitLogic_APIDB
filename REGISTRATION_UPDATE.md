# Registration Update - Summary of Changes

## 📝 Updated Parameters

The registration endpoint now accepts and requires the following parameters:

```json
{
  "firstName": "string",
  "lastName": "string",
  "email": "string",
  "username": "string",
  "role": "Flight Crew" | "Ground Crew",
  "password": "string"
}
```

---

## 🔄 Changes Made

### 1. **User Types** (`src/types/user.ts`)
- ✅ Added `UserRole` type (Flight Crew | Ground Crew)
- ✅ Updated `User` interface with `username` and `role`
- ✅ Updated `RegisterRequest` interface with all new fields

### 2. **Auth Controller** (`src/controllers/authController.ts`)
- ✅ Updated register function to accept all 6 parameters
- ✅ Added validation for all required fields
- ✅ Added role validation (must be "Flight Crew" or "Ground Crew")
- ✅ Check for duplicate email
- ✅ Check for duplicate username
- ✅ Insert all fields into database
- ✅ Include username and role in JWT token
- ✅ Return complete user info in response

### 3. **Database Schema** (`database/schema.sql`)
- ✅ Added `firstName` field (required)
- ✅ Added `lastName` field (required)
- ✅ Added `username` field (unique, required)
- ✅ Added `role` field (ENUM: 'Flight Crew' or 'Ground Crew')
- ✅ Reordered columns logically
- ✅ Added indexes on email, username, and role
- ✅ Updated sample data

---

## 📡 API Endpoint

**POST** `/api/auth/register`

### Request Body
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "username": "johndoe",
  "role": "Flight Crew",
  "password": "SecurePass123!"
}
```

### Success Response (201)
```json
{
  "success": true,
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "1",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "username": "johndoe",
    "role": "Flight Crew"
  }
}
```

### Error Responses

**400 - Missing Fields**
```json
{
  "success": false,
  "message": "All fields are required: firstName, lastName, email, username, role, password"
}
```

**400 - Invalid Role**
```json
{
  "success": false,
  "message": "Role must be either \"Flight Crew\" or \"Ground Crew\""
}
```

**409 - Email Already Exists**
```json
{
  "success": false,
  "message": "Email already registered"
}
```

**409 - Username Already Exists**
```json
{
  "success": false,
  "message": "Username already taken"
}
```

---

## ⚠️ Important: Update Your Database

You need to recreate your database with the new schema:

```bash
# Drop old database (if you have test data you don't need)
mysql -u root -p -e "DROP DATABASE summitlogic_db;"

# Create new database with updated schema
mysql -u root -p < database/schema.sql
```

Or just update the users table:

```sql
ALTER TABLE users ADD COLUMN username VARCHAR(100) UNIQUE NOT NULL AFTER password;
ALTER TABLE users ADD COLUMN role ENUM('Flight Crew', 'Ground Crew') NOT NULL AFTER username;
```

---

## 🧪 Testing

Use the dashboard at `http://localhost:3000` or test with cURL:

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "username": "johndoe",
    "role": "Flight Crew",
    "password": "SecurePass123!"
  }'
```

---

## ✅ Status

- ✅ TypeScript compilation: **SUCCESSFUL**
- ✅ All types updated
- ✅ Controller logic updated
- ✅ Database schema updated
- ✅ Validation added
- ✅ Ready for testing

Next step: Rebuild database and test registration! 🚀
