import type { Response } from 'express';
import type { AuthRequest } from '../middleware/auth';
import type { CreateAirlineRequest, UpdateAirlineRequest } from '../types/airline';
import pool from '../config/database';

// GET all airlines
export const getAllAirlines = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const connection = await pool.getConnection();
    try {
      const [airlines] = await connection.query('SELECT * FROM airlines ORDER BY name');
      res.json({
        success: true,
        data: airlines,
        count: (airlines as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get airlines error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching airlines',
    });
  }
};

// GET airline by ID
export const getAirlineById = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const connection = await pool.getConnection();
    try {
      const [airlines] = await connection.query('SELECT * FROM airlines WHERE id = ?', [id]);
      
      if ((airlines as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Airline not found',
        });
        return;
      }

      res.json({
        success: true,
        data: (airlines as any[])[0],
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get airline error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching airline',
    });
  }
};

// CREATE airline
export const createAirline = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { name, iata_code, icao_code } = req.body as CreateAirlineRequest;

    if (!name) {
      res.status(400).json({
        success: false,
        message: 'Airline name is required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        'INSERT INTO airlines (name, iata_code, icao_code) VALUES (?, ?, ?)',
        [name, iata_code || null, icao_code || null]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Airline created successfully',
        data: {
          id: insertResult.insertId,
          name,
          iata_code,
          icao_code,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create airline error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating airline',
    });
  }
};

// UPDATE airline
export const updateAirline = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { name, iata_code, icao_code } = req.body as UpdateAirlineRequest;

    const connection = await pool.getConnection();
    try {
      const [airlines] = await connection.query('SELECT * FROM airlines WHERE id = ?', [id]);
      
      if ((airlines as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Airline not found',
        });
        return;
      }

      await connection.query(
        'UPDATE airlines SET name = ?, iata_code = ?, icao_code = ? WHERE id = ?',
        [name || (airlines as any[])[0].name, iata_code, icao_code, id]
      );

      res.json({
        success: true,
        message: 'Airline updated successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Update airline error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating airline',
    });
  }
};

// DELETE airline
export const deleteAirline = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const connection = await pool.getConnection();
    try {
      const [airlines] = await connection.query('SELECT * FROM airlines WHERE id = ?', [id]);
      
      if ((airlines as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Airline not found',
        });
        return;
      }

      await connection.query('DELETE FROM airlines WHERE id = ?', [id]);

      res.json({
        success: true,
        message: 'Airline deleted successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Delete airline error:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting airline',
    });
  }
};
