import type { Response } from 'express';
import type { AuthRequest } from '../middleware/auth';
import type { CreateFlightRequest, UpdateFlightRequest } from '../types/flight';
import pool from '../config/database';

// GET all flights
export const getAllFlights = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const connection = await pool.getConnection();
    try {
      const [flights] = await connection.query(`
        SELECT f.*, a.name as airline_name FROM flights f
        LEFT JOIN airlines a ON f.airline_id = a.id
        ORDER BY f.service_date DESC, f.flight_number
      `);
      res.json({
        success: true,
        data: flights,
        count: (flights as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get flights error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching flights',
    });
  }
};

// GET flight by ID
export const getFlightById = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const connection = await pool.getConnection();
    try {
      const [flights] = await connection.query(`
        SELECT f.*, a.name as airline_name FROM flights f
        LEFT JOIN airlines a ON f.airline_id = a.id
        WHERE f.id = ?
      `, [id]);
      
      if ((flights as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Flight not found',
        });
        return;
      }

      res.json({
        success: true,
        data: (flights as any[])[0],
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get flight error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching flight',
    });
  }
};

// CREATE flight
export const createFlight = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const {
      airline_id,
      flight_number,
      direction,
      aircraft_type,
      departure_airport,
      arrival_airport,
      scheduled_departure,
      scheduled_arrival,
      capacity_seats,
      service_date,
      load_factor_pct,
    } = req.body as CreateFlightRequest;

    // Validate required fields
    if (
      !airline_id ||
      !flight_number ||
      !direction ||
      !aircraft_type ||
      !departure_airport ||
      !arrival_airport ||
      !scheduled_departure ||
      !scheduled_arrival ||
      !capacity_seats ||
      !service_date
    ) {
      res.status(400).json({
        success: false,
        message: 'All required fields must be provided',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO flights (airline_id, flight_number, direction, aircraft_type, 
         departure_airport, arrival_airport, scheduled_departure, scheduled_arrival, 
         capacity_seats, service_date, load_factor_pct) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          airline_id,
          flight_number,
          direction,
          aircraft_type,
          departure_airport,
          arrival_airport,
          scheduled_departure,
          scheduled_arrival,
          capacity_seats,
          service_date,
          load_factor_pct || null,
        ]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Flight created successfully',
        data: {
          id: insertResult.insertId,
          airline_id,
          flight_number,
          direction,
          aircraft_type,
          departure_airport,
          arrival_airport,
          scheduled_departure,
          scheduled_arrival,
          capacity_seats,
          service_date,
          load_factor_pct,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create flight error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating flight',
    });
  }
};

// UPDATE flight
export const updateFlight = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const updates = req.body as UpdateFlightRequest;

    const connection = await pool.getConnection();
    try {
      const [flights] = await connection.query('SELECT * FROM flights WHERE id = ?', [id]);
      
      if ((flights as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Flight not found',
        });
        return;
      }

      const flight = (flights as any[])[0];
      const updateFields: string[] = [];
      const updateValues: any[] = [];

      Object.entries(updates).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          updateFields.push(`${key} = ?`);
          updateValues.push(value);
        }
      });

      if (updateFields.length === 0) {
        res.status(400).json({
          success: false,
          message: 'No fields to update',
        });
        return;
      }

      updateValues.push(id);
      await connection.query(`UPDATE flights SET ${updateFields.join(', ')} WHERE id = ?`, updateValues);

      res.json({
        success: true,
        message: 'Flight updated successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Update flight error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating flight',
    });
  }
};

// DELETE flight
export const deleteFlight = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const connection = await pool.getConnection();
    try {
      const [flights] = await connection.query('SELECT * FROM flights WHERE id = ?', [id]);
      
      if ((flights as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Flight not found',
        });
        return;
      }

      await connection.query('DELETE FROM flights WHERE id = ?', [id]);

      res.json({
        success: true,
        message: 'Flight deleted successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Delete flight error:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting flight',
    });
  }
};
