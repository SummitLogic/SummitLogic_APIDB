import type { Response } from 'express';
import type { AuthRequest } from '../middleware/auth';
import type {
  CreateBottleInstanceRequest,
  UpdateBottleInstanceRequest,
  CreatePackPlanRequest,
  UpdatePackPlanRequest,
  CreateCartRequest,
  UpdateCartRequest,
  CreateTrayRequest,
} from '../types/inventory';
import pool from '../config/database';

// ==================== BOTTLE INSTANCES ====================

// GET all bottles
export const getAllBottles = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { status, airline_id } = req.query;
    let query = `
      SELECT b.*, i.name as item_name, a.name as airline_name 
      FROM bottle_instances b
      LEFT JOIN items i ON b.beverage_item_id = i.id
      LEFT JOIN airlines a ON b.airline_id = a.id
      WHERE 1=1
    `;
    const params: any[] = [];

    if (status) {
      query += ' AND b.status = ?';
      params.push(status);
    }

    if (airline_id) {
      query += ' AND b.airline_id = ?';
      params.push(airline_id);
    }

    query += ' ORDER BY b.created_at DESC';

    const connection = await pool.getConnection();
    try {
      const [bottles] = await connection.query(query, params);
      res.json({
        success: true,
        data: bottles,
        count: (bottles as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get bottles error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching bottles',
    });
  }
};

// CREATE bottle
export const createBottle = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { beverage_item_id, airline_id, qr_code, batch_code, initial_volume_ml } =
      req.body as CreateBottleInstanceRequest;

    if (!beverage_item_id || !airline_id || !qr_code || !initial_volume_ml) {
      res.status(400).json({
        success: false,
        message: 'Required fields: beverage_item_id, airline_id, qr_code, initial_volume_ml',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO bottle_instances (beverage_item_id, airline_id, qr_code, batch_code, initial_volume_ml, current_pct) 
         VALUES (?, ?, ?, ?, ?, 100)`,
        [beverage_item_id, airline_id, qr_code, batch_code || null, initial_volume_ml]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Bottle created successfully',
        data: {
          id: insertResult.insertId,
          beverage_item_id,
          airline_id,
          qr_code,
          batch_code,
          initial_volume_ml,
          current_pct: 100,
          status: 'Returned',
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create bottle error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating bottle',
    });
  }
};

// UPDATE bottle
export const updateBottle = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { current_pct, status, last_flight_id } = req.body as UpdateBottleInstanceRequest;

    const connection = await pool.getConnection();
    try {
      const [bottles] = await connection.query('SELECT * FROM bottle_instances WHERE id = ?', [id]);
      
      if ((bottles as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Bottle not found',
        });
        return;
      }

      const updates: string[] = [];
      const values: any[] = [];

      if (current_pct !== undefined) {
        updates.push('current_pct = ?');
        values.push(current_pct);
      }

      if (status) {
        updates.push('status = ?');
        values.push(status);
      }

      if (last_flight_id !== undefined) {
        updates.push('last_flight_id = ?');
        values.push(last_flight_id);
      }

      if (updates.length === 0) {
        res.status(400).json({
          success: false,
          message: 'No fields to update',
        });
        return;
      }

      values.push(id);
      await connection.query(
        `UPDATE bottle_instances SET ${updates.join(', ')} WHERE id = ?`,
        values
      );

      res.json({
        success: true,
        message: 'Bottle updated successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Update bottle error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating bottle',
    });
  }
};

// ==================== PACK PLANS ====================

// GET all pack plans
export const getAllPackPlans = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { flight_id, status } = req.query;
    let query = `
      SELECT p.*, f.flight_number, u.username as created_by_name
      FROM pack_plans p
      LEFT JOIN flights f ON p.flight_id = f.id
      LEFT JOIN users u ON p.created_by = u.id
      WHERE 1=1
    `;
    const params: any[] = [];

    if (flight_id) {
      query += ' AND p.flight_id = ?';
      params.push(flight_id);
    }

    if (status) {
      query += ' AND p.status = ?';
      params.push(status);
    }

    query += ' ORDER BY p.generated_at DESC';

    const connection = await pool.getConnection();
    try {
      const [plans] = await connection.query(query, params);
      res.json({
        success: true,
        data: plans,
        count: (plans as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get pack plans error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching pack plans',
    });
  }
};

// CREATE pack plan
export const createPackPlan = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { flight_id, created_by, load_factor_pct } = req.body as CreatePackPlanRequest;

    if (!flight_id || !created_by) {
      res.status(400).json({
        success: false,
        message: 'Flight ID and created_by user ID are required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO pack_plans (flight_id, created_by, load_factor_pct, status) 
         VALUES (?, ?, ?, 'draft')`,
        [flight_id, created_by, load_factor_pct || null]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Pack plan created successfully',
        data: {
          id: insertResult.insertId,
          flight_id,
          created_by,
          load_factor_pct,
          status: 'draft',
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create pack plan error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating pack plan',
    });
  }
};

// UPDATE pack plan
export const updatePackPlan = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { status, load_factor_pct } = req.body as UpdatePackPlanRequest;

    const connection = await pool.getConnection();
    try {
      const [plans] = await connection.query('SELECT * FROM pack_plans WHERE id = ?', [id]);
      
      if ((plans as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Pack plan not found',
        });
        return;
      }

      const updates: string[] = [];
      const values: any[] = [];

      if (status) {
        updates.push('status = ?');
        values.push(status);
      }

      if (load_factor_pct !== undefined) {
        updates.push('load_factor_pct = ?');
        values.push(load_factor_pct);
      }

      if (updates.length === 0) {
        res.status(400).json({
          success: false,
          message: 'No fields to update',
        });
        return;
      }

      values.push(id);
      await connection.query(
        `UPDATE pack_plans SET ${updates.join(', ')} WHERE id = ?`,
        values
      );

      res.json({
        success: true,
        message: 'Pack plan updated successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Update pack plan error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating pack plan',
    });
  }
};

// ==================== CARTS ====================

// GET all carts
export const getAllCarts = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { flight_id } = req.query;
    let query = `
      SELECT c.*, f.flight_number
      FROM carts c
      LEFT JOIN flights f ON c.flight_id = f.id
      WHERE 1=1
    `;
    const params: any[] = [];

    if (flight_id) {
      query += ' AND c.flight_id = ?';
      params.push(flight_id);
    }

    query += ' ORDER BY c.created_at DESC';

    const connection = await pool.getConnection();
    try {
      const [carts] = await connection.query(query, params);
      res.json({
        success: true,
        data: carts,
        count: (carts as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get carts error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching carts',
    });
  }
};

// CREATE cart
export const createCart = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { flight_id, code, cart_type } = req.body as CreateCartRequest;

    if (!flight_id || !code) {
      res.status(400).json({
        success: false,
        message: 'Flight ID and code are required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO carts (flight_id, code, cart_type) VALUES (?, ?, ?)`,
        [flight_id, code, cart_type || null]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Cart created successfully',
        data: {
          id: insertResult.insertId,
          flight_id,
          code,
          cart_type,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create cart error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating cart',
    });
  }
};

// UPDATE cart
export const updateCart = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { code, cart_type } = req.body as UpdateCartRequest;

    const connection = await pool.getConnection();
    try {
      const [carts] = await connection.query('SELECT * FROM carts WHERE id = ?', [id]);
      
      if ((carts as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Cart not found',
        });
        return;
      }

      const updates: string[] = [];
      const values: any[] = [];

      if (code) {
        updates.push('code = ?');
        values.push(code);
      }

      if (cart_type !== undefined) {
        updates.push('cart_type = ?');
        values.push(cart_type);
      }

      if (updates.length === 0) {
        res.status(400).json({
          success: false,
          message: 'No fields to update',
        });
        return;
      }

      values.push(id);
      await connection.query(
        `UPDATE carts SET ${updates.join(', ')} WHERE id = ?`,
        values
      );

      res.json({
        success: true,
        message: 'Cart updated successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Update cart error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating cart',
    });
  }
};

// ==================== TRAYS ====================

// GET all trays
export const getAllTrays = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { cart_id } = req.query;
    let query = `
      SELECT t.*, c.code as cart_code
      FROM trays t
      LEFT JOIN carts c ON t.cart_id = c.id
      WHERE 1=1
    `;
    const params: any[] = [];

    if (cart_id) {
      query += ' AND t.cart_id = ?';
      params.push(cart_id);
    }

    query += ' ORDER BY t.created_at DESC';

    const connection = await pool.getConnection();
    try {
      const [trays] = await connection.query(query, params);
      res.json({
        success: true,
        data: trays,
        count: (trays as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get trays error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching trays',
    });
  }
};

// CREATE tray
export const createTray = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { cart_id, position_code } = req.body as CreateTrayRequest;

    if (!cart_id || !position_code) {
      res.status(400).json({
        success: false,
        message: 'Cart ID and position code are required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO trays (cart_id, position_code) VALUES (?, ?)`,
        [cart_id, position_code]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Tray created successfully',
        data: {
          id: insertResult.insertId,
          cart_id,
          position_code,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create tray error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating tray',
    });
  }
};
