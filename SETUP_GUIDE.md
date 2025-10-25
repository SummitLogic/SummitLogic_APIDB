# SummitLogic API - Setup and Installation Guide

## 🎯 Overview

Your TypeScript REST API is now ready! This guide will walk you through the complete setup process.

## ✅ What's Been Created

### Project Structure
```
SummitLogic_APIDB/
├── src/
│   ├── config/
│   │   ├── database.ts          # MySQL connection pool
│   │   └── environment.ts       # Environment variables
│   ├── controllers/
│   │   ├── authController.ts    # Register & Login logic
│   │   └── healthController.ts  # API health check
│   ├── middleware/
│   │   └── auth.ts              # JWT authentication middleware
│   ├── routes/
│   │   ├── auth.ts              # Auth endpoints
│   │   └── health.ts            # Health endpoint
│   ├── types/
│   │   └── user.ts              # TypeScript interfaces
│   └── index.ts                 # Main server entry point
├── database/
│   └── schema.sql               # MySQL database schema
├── public/
│   └── index.html               # Beautiful web dashboard
├── .env.template                # Environment variables template
├── package.json
├── tsconfig.json
└── README.md
```

## 🚀 Getting Started

### Step 1: Setup Environment Variables

```bash
# Copy the template to .env
cp .env.template .env
```

Edit `.env` and add your MySQL database credentials:

```env
PORT=3000
NODE_ENV=development

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_actual_password
DB_NAME=summitlogic_db
DB_PORT=3306

JWT_SECRET=your_very_secure_secret_key_here_make_it_long
JWT_EXPIRY=24h

API_BASE_URL=http://localhost:3000
```

⚠️ **IMPORTANT**: Never commit the `.env` file to version control!

### Step 2: Setup MySQL Database

1. Create database and tables:
```bash
mysql -u root -p < database/schema.sql
```

Or manually in MySQL:
```sql
CREATE DATABASE IF NOT EXISTS summitlogic_db;
USE summitlogic_db;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  firstName VARCHAR(100),
  lastName VARCHAR(100),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_email (email)
);
```

### Step 3: Install Dependencies

```bash
npm install
```

### Step 4: Start the API

#### Development Mode (with hot reload):
```bash
npm run dev
```

#### Production Mode:
```bash
npm run build
npm start
```

The API will start on `http://localhost:3000`

## 🌐 Accessing the API

### Web Dashboard
Open your browser and navigate to: **http://localhost:3000**

You'll see a beautiful dashboard with:
- API endpoints documentation
- Real-time health check
- Test buttons for register and login
- Response viewer

### API Health Check
```bash
curl http://localhost:3000/api/health
```

Response:
```json
{
  "success": true,
  "message": "API is running",
  "timestamp": "2024-10-25T21:30:00.000Z",
  "database": "connected",
  "version": "1.0.0",
  "api": "SummitLogic_APIDB"
}
```

## 📡 API Endpoints

### Authentication

#### Register User
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecurePassword123!",
    "firstName": "John",
    "lastName": "Doe"
  }'
```

Response:
```json
{
  "success": true,
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "1",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe"
  }
}
```

#### Login User
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecurePassword123!"
  }'
```

Response:
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "1",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe"
  }
}
```

### Health Check
```bash
curl http://localhost:3000/api/health
```

## 🔐 Security Features

✅ **Password Hashing**: Bcryptjs with 10 salt rounds  
✅ **JWT Tokens**: Secure token-based authentication  
✅ **Helmet.js**: HTTP security headers  
✅ **CORS**: Cross-origin protection  
✅ **Input Validation**: Request validation  
✅ **Middleware**: Authentication middleware for protected routes  

## 🛡️ Using JWT Tokens

Once logged in, use the token to access protected routes:

```bash
curl http://localhost:3000/api/protected-route \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

The middleware will validate the token before allowing access.

## 🔧 Database Folder

The `database/` folder is where all your SQL scripts should live:
- `schema.sql` - Database and table creation
- `migrations/` - Future database migrations
- `seeds/` - Seed data for development

## 📝 Adding New Endpoints

### 1. Create a Controller

`src/controllers/userController.ts`:
```typescript
import type { Response } from 'express';
import type { AuthRequest } from '../middleware/auth';
import pool from '../config/database';

export const getProfile = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const userId = req.user?.id;
    const connection = await pool.getConnection();
    
    const [users] = await connection.query(
      'SELECT id, email, firstName, lastName FROM users WHERE id = ?',
      [userId]
    );
    
    connection.release();
    res.json({ success: true, user: (users as any[])[0] });
  } catch (error) {
    res.status(500).json({ success: false, error: 'Failed to fetch profile' });
  }
};
```

### 2. Create Routes

`src/routes/users.ts`:
```typescript
import { Router } from 'express';
import { getProfile } from '../controllers/userController';
import { authenticateToken } from '../middleware/auth';

const router = Router();

router.get('/profile', authenticateToken, getProfile);

export default router;
```

### 3. Register Routes in Main File

`src/index.ts`:
```typescript
import userRoutes from './routes/users';

app.use('/api/users', userRoutes);
```

## 🧪 Testing with Postman/Insomnia

1. **Register a user** at `POST /api/auth/register`
2. **Copy the JWT token** from response
3. **Set Authorization header**: `Bearer <YOUR_TOKEN>`
4. **Test protected endpoints** with the token

## 📚 Recommended Next Steps

1. ✅ **Test the API**: Use the dashboard at http://localhost:3000
2. ✅ **Add more endpoints**: Follow the pattern in the Adding New Endpoints section
3. ✅ **Implement error handling**: Enhance error responses
4. ✅ **Add validation**: Use a library like `joi` or `yup`
5. ✅ **Add logging**: Implement structured logging
6. ✅ **Write tests**: Add unit and integration tests
7. ✅ **Deploy**: Use Docker or cloud hosting

## 🐛 Troubleshooting

### Database Connection Failed
- Ensure MySQL is running
- Check credentials in `.env`
- Verify database exists: `SHOW DATABASES;`

### Port Already in Use
- Change `PORT` in `.env`
- Or kill the process using port 3000

### JWT Token Errors
- Ensure `JWT_SECRET` is set in `.env`
- Check token hasn't expired (24h default)
- Include `Bearer` prefix in Authorization header

### Dependencies Issues
```bash
rm -rf node_modules package-lock.json
npm install
```

## 📖 Additional Resources

- [Express.js Documentation](https://expressjs.com/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [JWT.io](https://jwt.io/)
- [Bcryptjs](https://github.com/dcodeIO/bcrypt.js)

## 🎉 You're All Set!

Your SummitLogic API is ready to use. Start by:

1. Setting up your `.env` file
2. Creating the database with `database/schema.sql`
3. Running `npm run dev`
4. Visiting http://localhost:3000

Happy coding! 🚀

---

**Built with ❤️ using TypeScript, Express.js, and MySQL**
