import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import { config } from './config/environment';
import { errorHandler } from './middleware/auth';
import authRoutes from './routes/auth';
import healthRoutes from './routes/health';

dotenv.config();

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/health', healthRoutes);

// Home route
app.get('/', (req: express.Request, res: express.Response) => {
  res.sendFile('index.html', { root: 'public' });
});

// Error handler middleware
app.use(errorHandler);

// 404 handler
app.use((req: express.Request, res: express.Response) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint not found',
    path: req.path,
  });
});

// Start server
app.listen(config.port, () => {
  console.log(`
🚀 SummitLogic API is running!
📍 Server: http://localhost:${config.port}
🌐 Environment: ${config.nodeEnv}
📊 Database: ${config.database.host}:${config.database.port}/${config.database.name}
  `);
});
