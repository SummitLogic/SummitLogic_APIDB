import { Router } from 'express';
import {
  getAllGames,
  getGameById,
  createGame,
  updateGame,
  deleteGame,
  getGameQuestions,
  createGameQuestion,
  getAllGameProgress,
  createGameProgress,
} from '../controllers/gameController';

const router = Router();

// Games endpoints
router.get('/', getAllGames);
router.get('/:id', getGameById);
router.post('/', createGame);
router.put('/:id', updateGame);
router.delete('/:id', deleteGame);

// Game Questions endpoints
router.get('/:gameId/questions', getGameQuestions);
router.post('/:gameId/questions', createGameQuestion);

// Game Progress endpoints
router.get('/progress/all', getAllGameProgress);
router.post('/progress', createGameProgress);

export default router;
