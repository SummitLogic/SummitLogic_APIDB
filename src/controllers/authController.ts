import type { Response } from 'express';
import type { AuthRequest } from '../middleware/auth';
import type { RegisterRequest, LoginRequest, AuthResponse } from '../types/user';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import pool from '../config/database';
import { config } from '../config/environment';

export const register = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { firstName, lastName, email, username, role, password } = req.body as RegisterRequest;

    // Validate all required fields
    if (!firstName || !lastName || !email || !username || !role || !password) {
      res.status(400).json({
        success: false,
        message: 'All fields are required: firstName, lastName, email, username, role, password',
      });
      return;
    }

    // Validate role
    if (role !== 'Flight Crew' && role !== 'Ground Crew') {
      res.status(400).json({
        success: false,
        message: 'Role must be either "Flight Crew" or "Ground Crew"',
      });
      return;
    }

    const connection = await pool.getConnection();

    try {
      // Check if email already exists
      const [existingEmail] = await connection.query('SELECT id FROM users WHERE email = ?', [email]);

      if ((existingEmail as any[]).length > 0) {
        res.status(409).json({
          success: false,
          message: 'Email already registered',
        });
        return;
      }

      // Check if username already exists
      const [existingUsername] = await connection.query('SELECT id FROM users WHERE username = ?', [username]);

      if ((existingUsername as any[]).length > 0) {
        res.status(409).json({
          success: false,
          message: 'Username already taken',
        });
        return;
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Create user
      const [result] = await connection.query(
        'INSERT INTO users (firstName, lastName, email, username, role, password) VALUES (?, ?, ?, ?, ?, ?)',
        [firstName, lastName, email, username, role, hashedPassword]
      );

      const insertResult = result as any;
      const token = jwt.sign(
        { id: insertResult.insertId.toString(), email, username, role },
        config.jwtSecret,
        { expiresIn: config.jwtExpiry }
      );

      const response: AuthResponse = {
        success: true,
        message: 'User registered successfully',
        token,
        user: {
          id: insertResult.insertId.toString(),
          firstName,
          lastName,
          email,
          username,
          role,
        },
      };

      res.status(201).json(response);
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({
      success: false,
      message: 'Error registering user',
    });
  }
};

export const login = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { email, password } = req.body as LoginRequest;

    if (!email || !password) {
      res.status(400).json({
        success: false,
        message: 'Email and password are required',
      });
      return;
    }

    const connection = await pool.getConnection();

    try {
      // Find user
      const [users] = await connection.query('SELECT * FROM users WHERE email = ?', [email]);

      if ((users as any[]).length === 0) {
        res.status(401).json({
          success: false,
          message: 'Invalid email or password',
        });
        return;
      }

      const user = (users as any[])[0];

      // Compare password
      const isPasswordValid = await bcrypt.compare(password, user.password);

      if (!isPasswordValid) {
        res.status(401).json({
          success: false,
          message: 'Invalid email or password',
        });
        return;
      }

      // Generate token
      const token = jwt.sign(
        { id: user.id.toString(), email: user.email },
        config.jwtSecret,
        { expiresIn: config.jwtExpiry as string }
      );

      const response: AuthResponse = {
        success: true,
        message: 'Login successful',
        token,
        user: {
          id: user.id.toString(),
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
        },
      };

      res.json(response);
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Error logging in',
    });
  }
};
