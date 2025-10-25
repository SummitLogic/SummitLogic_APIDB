# ✅ SummitLogic API - Setup Checklist

Use this checklist to ensure everything is properly set up.

## 📋 Pre-Installation Checklist

- [ ] You have Node.js 18.0.0+ installed (`node --version`)
- [ ] You have npm installed (`npm --version`)
- [ ] You have MySQL 5.7+ installed and running
- [ ] You have MySQL command-line tools installed
- [ ] You have a text editor (VS Code recommended)

## 🔧 Installation Checklist

### Step 1: Environment Setup
- [ ] Copy `.env.template` to `.env`
  ```bash
  cp .env.template .env
  ```
- [ ] Edit `.env` with your MySQL credentials
  - [ ] Set `DB_HOST` (usually `localhost`)
  - [ ] Set `DB_USER` (usually `root`)
  - [ ] Set `DB_PASSWORD` (your MySQL password)
  - [ ] Set `DB_NAME` to `summitlogic_db`
  - [ ] Set `JWT_SECRET` to a strong random string
- [ ] Verify `.env` file is NOT committed to git

### Step 2: Database Setup
- [ ] Ensure MySQL server is running
- [ ] Run database schema:
  ```bash
  mysql -u root -p < database/schema.sql
  ```
- [ ] Verify database created:
  ```bash
  mysql -u root -p
  SHOW DATABASES;  -- Should see summitlogic_db
  USE summitlogic_db;
  SHOW TABLES;     -- Should see users and projects
  ```

### Step 3: Installation
- [ ] Install dependencies:
  ```bash
  npm install
  ```
- [ ] Verify no installation errors
- [ ] Check `node_modules` folder exists

### Step 4: Build Verification
- [ ] Compile TypeScript:
  ```bash
  npm run build
  ```
- [ ] Verify `dist` folder is created
- [ ] Check lint passes:
  ```bash
  npm run lint
  ```

## 🚀 Running the API

### Development Mode
- [ ] Start development server:
  ```bash
  npm run dev
  ```
- [ ] See startup message:
  ```
  🚀 SummitLogic API is running!
  📍 Server: http://localhost:3000
  🌐 Environment: development
  📊 Database: localhost:3306/summitlogic_db
  ```

### Testing the API
- [ ] Open browser to `http://localhost:3000`
- [ ] See dashboard with API information
- [ ] Click "Check Health" button
- [ ] Verify response shows `database: "connected"`
- [ ] Click "Test Register" and verify success
- [ ] Click "Test Login" and verify success

## 🔍 API Testing Checklist

### Health Endpoint
- [ ] `GET /api/health` returns 200
- [ ] Database status shows "connected"

### Authentication - Register
- [ ] `POST /api/auth/register` with new user data
- [ ] Returns 201 with JWT token
- [ ] User data saved to database

### Authentication - Login
- [ ] `POST /api/auth/login` with correct credentials
- [ ] Returns 200 with JWT token
- [ ] `POST /api/auth/login` with wrong password
- [ ] Returns 401 "Invalid email or password"

## 📂 Project Structure Verification

- [ ] `src/` folder contains all source code
- [ ] `src/config/` has database.ts and environment.ts
- [ ] `src/controllers/` has authController.ts and healthController.ts
- [ ] `src/middleware/` has auth.ts
- [ ] `src/routes/` has auth.ts and health.ts
- [ ] `database/` has schema.sql
- [ ] `public/` has index.html
- [ ] `dist/` has compiled JavaScript (after build)
- [ ] `node_modules/` has dependencies

## 📝 Documentation Verification

- [ ] README.md exists and is readable
- [ ] SETUP_GUIDE.md exists with detailed instructions
- [ ] QUICK_REFERENCE.md exists with command reference
- [ ] PROJECT_SUMMARY.md exists with overview
- [ ] .env.template exists with example variables

## 🔐 Security Verification

- [ ] `.env` file is in `.gitignore`
- [ ] JWT_SECRET is set to a strong random value
- [ ] Passwords are hashed in database (starts with $2a$)
- [ ] `.env` file is NOT in version control
- [ ] Helmet.js is protecting HTTP headers
- [ ] CORS is configured in index.ts

## 🐛 Troubleshooting Checklist

If something goes wrong, check:

### "Cannot find module" Error
- [ ] Run `npm install`
- [ ] Delete `node_modules` and `package-lock.json`, then `npm install`

### Database Connection Error
- [ ] MySQL server is running
- [ ] Database credentials in `.env` are correct
- [ ] Database `summitlogic_db` exists
- [ ] User has permissions

### Port 3000 Already in Use
- [ ] Change `PORT` in `.env` to different port (e.g., 3001)
- [ ] Or kill process using port 3000

### TypeScript Compilation Error
- [ ] Run `npm run lint` to see specific errors
- [ ] Check file for syntax errors
- [ ] Verify all types are correct

### JWT Token Errors
- [ ] Check `Authorization: Bearer <TOKEN>` format
- [ ] Verify token hasn't expired (24h default)
- [ ] Ensure JWT_SECRET matches in `.env`

## 📊 Performance Verification

- [ ] API responds quickly (< 200ms for health check)
- [ ] Database queries complete successfully
- [ ] No memory leaks with extended running
- [ ] Hot reload works properly in dev mode

## 🎯 Next Steps After Setup

- [ ] Review README.md for full documentation
- [ ] Add more endpoints following the existing pattern
- [ ] Implement input validation
- [ ] Add more database tables for your needs
- [ ] Create unit tests
- [ ] Deploy to production environment
- [ ] Setup CI/CD pipeline
- [ ] Configure monitoring and logging

## ✨ Final Verification

- [ ] All checks above completed
- [ ] No error messages in console
- [ ] API responding to requests
- [ ] Database connected and working
- [ ] Dashboard displays correctly
- [ ] JWT tokens working properly
- [ ] Ready for development!

---

## 📞 Quick Help

**Problem**: Database connection failed  
**Solution**: Check MySQL is running and `.env` has correct credentials

**Problem**: Port 3000 in use  
**Solution**: Change PORT in `.env` or kill process on port 3000

**Problem**: npm install fails  
**Solution**: Delete node_modules and package-lock.json, then `npm install`

**Problem**: TypeScript errors  
**Solution**: Run `npm run lint` to see all errors

**Problem**: Styles not loading  
**Solution**: Clear browser cache or hard refresh (Ctrl+Shift+R)

---

## 🎉 You're Ready!

Once all items are checked, your SummitLogic API is ready for development!

Start with:
```bash
npm run dev
```

Then visit: **http://localhost:3000**

Happy coding! 🚀
