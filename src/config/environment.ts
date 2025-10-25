import dotenv from 'dotenv';

dotenv.config();

export const config = {
  port: parseInt(process.env.PORT || '3000', 10),
  nodeEnv: process.env.NODE_ENV || 'development',
  jwtSecret: process.env.JWT_SECRET || 'your_jwt_secret_key',
  jwtExpiry: process.env.JWT_EXPIRY || '24h',
  database: {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    name: process.env.DB_NAME || 'summitlogic_db',
    port: parseInt(process.env.DB_PORT || '3306', 10),
  },
  apiBaseUrl: process.env.API_BASE_URL || 'http://localhost:3000',
};
