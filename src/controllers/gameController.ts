import type { Response } from 'express';
import type { AuthRequest } from '../middleware/auth';
import type {
  CreateGameRequest,
  UpdateGameRequest,
  CreateGameQuestionRequest,
  CreateGameProgressRequest,
} from '../types/game';
import pool from '../config/database';

// ==================== GAMES ====================

// GET all games
export const getAllGames = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { is_active } = req.query;
    let query = 'SELECT * FROM games WHERE 1=1';
    const params: any[] = [];

    if (is_active !== undefined) {
      query += ' AND is_active = ?';
      params.push(is_active === 'true' ? 1 : 0);
    }

    query += ' ORDER BY title';

    const connection = await pool.getConnection();
    try {
      const [games] = await connection.query(query, params);
      res.json({
        success: true,
        data: games,
        count: (games as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get games error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching games',
    });
  }
};

// GET game by ID with questions
export const getGameById = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const connection = await pool.getConnection();
    try {
      const [games] = await connection.query('SELECT * FROM games WHERE id = ?', [id]);
      
      if ((games as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Game not found',
        });
        return;
      }

      const [questions] = await connection.query(
        'SELECT * FROM game_questions WHERE game_id = ? ORDER BY order_index',
        [id]
      );

      res.json({
        success: true,
        data: {
          ...(games as any[])[0],
          questions,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get game error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching game',
    });
  }
};

// CREATE game
export const createGame = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { title, description } = req.body as CreateGameRequest;

    if (!title) {
      res.status(400).json({
        success: false,
        message: 'Game title is required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO games (title, description, is_active) VALUES (?, ?, 1)`,
        [title, description || null]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Game created successfully',
        data: {
          id: insertResult.insertId,
          title,
          description,
          is_active: true,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create game error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating game',
    });
  }
};

// UPDATE game
export const updateGame = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const updates = req.body as UpdateGameRequest;

    const connection = await pool.getConnection();
    try {
      const [games] = await connection.query('SELECT * FROM games WHERE id = ?', [id]);
      
      if ((games as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Game not found',
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
      await connection.query(
        `UPDATE games SET ${updateFields.join(', ')} WHERE id = ?`,
        updateValues
      );

      res.json({
        success: true,
        message: 'Game updated successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Update game error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating game',
    });
  }
};

// DELETE game
export const deleteGame = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const connection = await pool.getConnection();
    try {
      const [games] = await connection.query('SELECT * FROM games WHERE id = ?', [id]);
      
      if ((games as any[]).length === 0) {
        res.status(404).json({
          success: false,
          message: 'Game not found',
        });
        return;
      }

      await connection.query('DELETE FROM games WHERE id = ?', [id]);

      res.json({
        success: true,
        message: 'Game deleted successfully',
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Delete game error:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting game',
    });
  }
};

// ==================== GAME QUESTIONS ====================

// GET all questions for a game
export const getGameQuestions = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { gameId } = req.params;
    const connection = await pool.getConnection();
    try {
      const [questions] = await connection.query(
        'SELECT * FROM game_questions WHERE game_id = ? ORDER BY order_index',
        [gameId]
      );
      res.json({
        success: true,
        data: questions,
        count: (questions as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get game questions error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching game questions',
    });
  }
};

// CREATE game question
export const createGameQuestion = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { game_id, question_text, question_type, options_json, correct_answer, order_index } =
      req.body as CreateGameQuestionRequest;

    if (!game_id || !question_text || !question_type) {
      res.status(400).json({
        success: false,
        message: 'Game ID, question text, and type are required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO game_questions (game_id, question_text, question_type, options_json, correct_answer, order_index) 
         VALUES (?, ?, ?, ?, ?, ?)`,
        [
          game_id,
          question_text,
          question_type,
          options_json ? JSON.stringify(options_json) : null,
          correct_answer || null,
          order_index || 0,
        ]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Game question created successfully',
        data: {
          id: insertResult.insertId,
          game_id,
          question_text,
          question_type,
          options_json,
          correct_answer,
          order_index,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create game question error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating game question',
    });
  }
};

// ==================== GAME PROGRESS ====================

// GET all game progress
export const getAllGameProgress = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { user_id, game_id } = req.query;
    let query = `
      SELECT gp.*, u.username, g.title as game_title, gq.question_text
      FROM game_progress gp
      LEFT JOIN users u ON gp.user_id = u.id
      LEFT JOIN games g ON gp.game_id = g.id
      LEFT JOIN game_questions gq ON gp.question_id = gq.id
      WHERE 1=1
    `;
    const params: any[] = [];

    if (user_id) {
      query += ' AND gp.user_id = ?';
      params.push(user_id);
    }

    if (game_id) {
      query += ' AND gp.game_id = ?';
      params.push(game_id);
    }

    query += ' ORDER BY gp.started_at DESC';

    const connection = await pool.getConnection();
    try {
      const [progress] = await connection.query(query, params);
      res.json({
        success: true,
        data: progress,
        count: (progress as any[]).length,
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Get game progress error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching game progress',
    });
  }
};

// CREATE game progress
export const createGameProgress = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { user_id, game_id, question_id, answer_text, is_correct, score_points } =
      req.body as CreateGameProgressRequest;

    if (!user_id || !game_id || !question_id) {
      res.status(400).json({
        success: false,
        message: 'User ID, game ID, and question ID are required',
      });
      return;
    }

    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query(
        `INSERT INTO game_progress (user_id, game_id, question_id, answer_text, is_correct, score_points) 
         VALUES (?, ?, ?, ?, ?, ?)`,
        [user_id, game_id, question_id, answer_text || null, is_correct || null, score_points || 0]
      );

      const insertResult = result as any;
      res.status(201).json({
        success: true,
        message: 'Game progress recorded successfully',
        data: {
          id: insertResult.insertId,
          user_id,
          game_id,
          question_id,
          answer_text,
          is_correct,
          score_points,
        },
      });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('Create game progress error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating game progress',
    });
  }
};
