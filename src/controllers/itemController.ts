import type { Response } from 'express';
import type { AuthRequest } from '../middleware/auth';
import type {
  CreateItemRequest,
  UpdateItemRequest,
  CreateBeverageRequest,
  CreateSnackRequest,
  CreateFoodRequest,
} from '../types/item';
import pool from '../config/database';

// ==================== ITEMS ====================

// GET all items
export const getAllItems = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { category, is_active } = req.query;
    let query = 'SELECT * FROM items WHERE 1=1';
    const params: any[] = [];

    if (category) {
      query += ' AND category = ?';
      params.push(category);
    }

    if (is_active !== undefined) {
      query += ' AND is_active = ?';
      params.push(is_active === 'true' ? 1 : 0);
    }

    query += ' ORDER BY category, name';

    const connection = await pool.getConnection();
    try {
      const [items] = await connection.query(query, params);
      res.json({
        success: true,
        data: items,
        count: (items as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get items error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching items',
    });
  }
};

// GET item by ID
export const getItemById = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const connection = await pool.getConnection();
    try {
      const [items] = await connection.query('SELECT * FROM items WHERE id = ?', [id]);
      
      if ((items as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Item not found',
        });
        return;
      }

      res.json({
        success: true,
        data: (items as any[])[0],
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get item error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching item',
    });
  }
};

// CREATE item
export const createItem = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { name, category, brand, unit_desc, size_desc, notes } = req.body as CreateItemRequest;

    if (!name || !category) {
      res.status(400).json({
        success: false,
        message: 'Item name and category are required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO items (name, category, brand, unit_desc, size_desc, notes, is_active) 
         VALUES (?, ?, ?, ?, ?, ?, 1)`,
        [name, category, brand || null, unit_desc || null, size_desc || null, notes || null]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Item created successfully',
        data: {
          id: insertResult.insertId,
          name,
          category,
          brand,
          unit_desc,
          size_desc,
          notes,
          is_active: true,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create item error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating item',
    });
  }
};

// UPDATE item
export const updateItem = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const updates = req.body as UpdateItemRequest;

    const connection = await pool.getConnection();
    try {
      const [items] = await connection.query('SELECT * FROM items WHERE id = ?', [id]);
      
      if ((items as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Item not found',
        });
        return;
      }

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
      await connection.query(`UPDATE items SET ${updateFields.join(', ')} WHERE id = ?`, updateValues);

      res.json({
        success: true,
        message: 'Item updated successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Update item error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating item',
    });
  }
};

// DELETE item
export const deleteItem = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const connection = await pool.getConnection();
    try {
      const [items] = await connection.query('SELECT * FROM items WHERE id = ?', [id]);
      
      if ((items as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Item not found',
        });
        return;
      }

      await connection.query('DELETE FROM items WHERE id = ?', [id]);

      res.json({
        success: true,
        message: 'Item deleted successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Delete item error:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting item',
    });
  }
};

// ==================== BEVERAGES ====================

// GET all beverages
export const getAllBeverages = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const connection = await pool.getConnection();
    try {
      const [beverages] = await connection.query(`
        SELECT b.*, i.name, i.brand FROM beverages b
        LEFT JOIN items i ON b.item_id = i.id
        ORDER BY i.name
      `);
      res.json({
        success: true,
        data: beverages,
        count: (beverages as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get beverages error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching beverages',
    });
  }
};

// CREATE beverage
export const createBeverage = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { item_id, type, flavour, volume_ml, alcohol_pct, default_pack_qty } =
      req.body as CreateBeverageRequest;

    if (!item_id || !volume_ml) {
      res.status(400).json({
        success: false,
        message: 'Item ID and volume are required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO beverages (item_id, type, flavour, volume_ml, alcohol_pct, default_pack_qty) 
         VALUES (?, ?, ?, ?, ?, ?)`,
        [item_id, type || null, flavour || null, volume_ml, alcohol_pct || null, default_pack_qty || null]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Beverage created successfully',
        data: {
          id: insertResult.insertId,
          item_id,
          type,
          flavour,
          volume_ml,
          alcohol_pct,
          default_pack_qty,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create beverage error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating beverage',
    });
  }
};

// ==================== SNACKS ====================

// GET all snacks
export const getAllSnacks = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const connection = await pool.getConnection();
    try {
      const [snacks] = await connection.query(`
        SELECT s.*, i.name, i.brand FROM snacks s
        LEFT JOIN items i ON s.item_id = i.id
        ORDER BY i.name
      `);
      res.json({
        success: true,
        data: snacks,
        count: (snacks as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get snacks error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching snacks',
    });
  }
};

// CREATE snack
export const createSnack = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { item_id, type, size_grams, default_pack_qty } = req.body as CreateSnackRequest;

    if (!item_id) {
      res.status(400).json({
        success: false,
        message: 'Item ID is required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO snacks (item_id, type, size_grams, default_pack_qty) 
         VALUES (?, ?, ?, ?)`,
        [item_id, type || null, size_grams || null, default_pack_qty || null]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Snack created successfully',
        data: {
          id: insertResult.insertId,
          item_id,
          type,
          size_grams,
          default_pack_qty,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create snack error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating snack',
    });
  }
};

// ==================== FOOD ====================

// GET all food
export const getAllFood = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const connection = await pool.getConnection();
    try {
      const [food] = await connection.query(`
        SELECT f.*, i.name, i.brand FROM food f
        LEFT JOIN items i ON f.item_id = i.id
        ORDER BY i.name
      `);
      res.json({
        success: true,
        data: food,
        count: (food as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get food error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching food',
    });
  }
};

// CREATE food
export const createFood = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { item_id, ingredients, serving_size, default_pack_qty } = req.body as CreateFoodRequest;

    if (!item_id) {
      res.status(400).json({
        success: false,
        message: 'Item ID is required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO food (item_id, ingredients, serving_size, default_pack_qty) 
         VALUES (?, ?, ?, ?)`,
        [item_id, ingredients || null, serving_size || null, default_pack_qty || null]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Food created successfully',
        data: {
          id: insertResult.insertId,
          item_id,
          ingredients,
          serving_size,
          default_pack_qty,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create food error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating food',
    });
  }
};
