import type { Request, Response } from 'express';
import pool from '../config/database';

export const getHealth = async (req: Request, res: Response): Promise<void> => {
  try {
    const connection = await pool.getConnection();
    await connection.ping();
    connection.release();

    res.status(200).json({
      success: true,
      message: 'API is running',
      timestamp: new Date().toISOString(),
      database: 'connected',
      version: '1.0.0',
      api: 'SummitLogic_APIDB',
    });
  } catch (error) {
    console.error('Health check error:', error);
    res.status(503).json({
      success: false,
      message: 'Database connection failed',
      timestamp: new Date().toISOString(),
      database: 'disconnected',
    });
  }
};
