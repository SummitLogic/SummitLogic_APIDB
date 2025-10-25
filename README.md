# SummitLogic API Database

A robust TypeScript REST API with authentication, CRUD capabilities, and MySQL integration for the SummitLogic platform.

## 🚀 Features

- **User Authentication**: Register and Login with bcrypt hashing
- **JWT Tokens**: Secure token-based authentication
- **Health Check**: Monitor API and database status
- **CRUD Operations**: Foundation for data management
- **Type Safety**: Full TypeScript implementation
- **Security**: Helmet.js, CORS, input validation
- **Database**: MySQL with connection pooling
- **Beautiful Dashboard**: Web interface to view endpoints and test API

## 📋 Prerequisites

- Node.js 18.0.0 or higher
- npm or yarn
- MySQL 5.7 or higher
- TypeScript 5.0 or higher

## 🛠️ Installation

1. Clone the repository or navigate to the project directory
2. Install dependencies:
```bash
npm install
```

3. Configure environment variables:
```bash
cp .env.template .env
```
Then edit `.env` with your database credentials and configuration.

4. Create the database:
```bash
mysql -u root -p < database/schema.sql
```

## 📝 Environment Configuration

Create a `.env` file with the following variables:

```env
PORT=3000
NODE_ENV=development

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=summitlogic_db
DB_PORT=3306

JWT_SECRET=your_super_secret_jwt_key_here
JWT_EXPIRY=24h

API_BASE_URL=http://localhost:3000
```

## 🚀 Running the API

### Development Mode (with hot reload):
```bash
npm run dev
```

### Production Mode:
```bash
npm run build
npm start
```

### Linting:
```bash
npm run lint
```

The API will start on `http://localhost:3000`

## 📡 API Endpoints

### Health Check
- **GET** `/api/health` - Check API and database status

### Authentication
- **POST** `/api/auth/register` - Register a new user
  ```json
  {
    "email": "user@example.com",
    "password": "securePassword",
    "firstName": "John",
    "lastName": "Doe"
  }
  ```

- **POST** `/api/auth/login` - Login user
  ```json
  {
    "email": "user@example.com",
    "password": "securePassword"
  }
  ```

## 🏗️ Project Structure

```
SummitLogic_APIDB/
├── src/
│   ├── config/
│   │   ├── database.ts       # Database connection pool
│   │   └── environment.ts    # Environment configuration
│   ├── controllers/
│   │   ├── authController.ts # Authentication logic
│   │   └── healthController.ts # Health check logic
│   ├── middleware/
│   │   └── auth.ts           # JWT authentication middleware
│   ├── routes/
│   │   ├── auth.ts           # Auth routes
│   │   └── health.ts         # Health routes
│   ├── types/
│   │   └── user.ts           # User interfaces
│   └── index.ts              # Main server file
├── database/
│   └── schema.sql            # Database schema
├── public/
│   └── index.html            # Dashboard UI
├── .env.template             # Environment template
├── package.json
├── tsconfig.json
└── README.md
```

## 🔐 Security Features

- **Bcryptjs**: Password hashing with 10 salt rounds
- **JWT**: Token-based authentication
- **Helmet**: HTTP headers security
- **CORS**: Cross-origin resource sharing protection
- **Input Validation**: Request data validation
- **Middleware**: Authentication middleware for protected routes

## 💾 Database

The database includes:
- **users** table: Stores user credentials and information
- **projects** table: Example table for CRUD operations (can be extended)

Run migrations:
```bash
mysql -u root -p < database/schema.sql
```

## 🧪 Testing

Visit `http://localhost:3000` to access the dashboard with:
- Quick health check
- Register test
- Login test
- Real-time API responses

## 📚 Adding More Endpoints

1. Create a controller in `src/controllers/`
2. Define types in `src/types/`
3. Create routes in `src/routes/`
4. Import and use the routes in `src/index.ts`

Example:
```typescript
import { Router } from 'express';
import { authenticateToken } from '../middleware/auth';

const router = Router();

router.get('/data', authenticateToken, (req, res) => {
  res.json({ message: 'Protected data' });
});

export default router;
```

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## 📄 License

MIT License - feel free to use this project

## 📞 Support

For issues or questions, please create an issue in the repository.

## 🎯 Future Enhancements

- [ ] User profile endpoints
- [ ] Password reset functionality
- [ ] Email verification
- [ ] Role-based access control
- [ ] Rate limiting
- [ ] API documentation (Swagger/OpenAPI)
- [ ] Unit tests
- [ ] Integration tests
- [ ] Docker support
- [ ] CI/CD pipeline

---

**Built with ❤️ using TypeScript, Express.js, and MySQL**
