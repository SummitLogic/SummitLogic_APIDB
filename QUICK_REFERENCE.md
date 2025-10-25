# SummitLogic API - Quick Reference

## 🚀 Quick Start Commands

```bash
# 1. Install dependencies
npm install

# 2. Setup environment
cp .env.template .env
# Edit .env with your database credentials

# 3. Create database
mysql -u root -p < database/schema.sql

# 4. Start development server
npm run dev

# 5. Open in browser
# http://localhost:3000
```

## 📡 API Endpoints Quick Reference

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login user, get JWT token |

### Health & Status
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Check API and DB status |

## 🔑 Environment Variables (.env)

```env
PORT=3000
NODE_ENV=development
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=summitlogic_db
DB_PORT=3306
JWT_SECRET=your_secret_key
JWT_EXPIRY=24h
API_BASE_URL=http://localhost:3000
```

## 📝 NPM Scripts

```bash
npm run dev      # Start with hot reload (development)
npm run build    # Compile TypeScript
npm start        # Start production server
npm run lint     # Check TypeScript compilation
```

## 🔐 Using JWT Tokens

After login, include token in requests:

```bash
curl http://localhost:3000/api/protected-endpoint \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

## 📂 Key Files

| File | Purpose |
|------|---------|
| `src/index.ts` | Main server file |
| `src/config/database.ts` | Database connection |
| `src/middleware/auth.ts` | JWT authentication |
| `src/controllers/authController.ts` | Login/Register logic |
| `database/schema.sql` | Database schema |
| `public/index.html` | Web dashboard |
| `.env.template` | Environment template |

## 🎯 Project Structure

```
src/
├── config/          # Configuration files
├── controllers/     # Business logic
├── middleware/      # Express middleware
├── routes/          # API routes
├── types/           # TypeScript interfaces
└── index.ts         # Entry point

database/            # SQL files
public/              # Static files & dashboard
```

## ✨ Features Included

✅ User Registration with password hashing  
✅ User Login with JWT tokens  
✅ Health check endpoint  
✅ Middleware for protected routes  
✅ MySQL database integration  
✅ Beautiful web dashboard  
✅ Environment configuration  
✅ TypeScript strict mode  
✅ Security headers (Helmet.js)  
✅ CORS protection  

## 🔗 Useful Links

- Dashboard: http://localhost:3000
- API Health: http://localhost:3000/api/health
- Full Setup Guide: `SETUP_GUIDE.md`
- Main README: `README.md`

## 💡 Tips

1. Always keep `.env` out of version control (it's in `.gitignore`)
2. Use strong JWT_SECRET in production
3. Update database credentials before running
4. Check `npm run lint` before committing
5. The dashboard is perfect for testing endpoints

## 🆘 Common Issues

**"Cannot find module"** → Run `npm install`  
**"Database connection failed"** → Check MySQL is running and `.env` credentials  
**"Port 3000 already in use"** → Change PORT in `.env` or kill process  
**"JWT errors"** → Ensure token has `Bearer ` prefix in Authorization header  

---

For detailed instructions, see `SETUP_GUIDE.md`
