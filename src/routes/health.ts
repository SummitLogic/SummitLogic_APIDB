import type { Router as ExpressRouter } from 'express';
import { Router } from 'express';
import { getHealth } from '../controllers/healthController';

const router: ExpressRouter = Router();

/**
 * @route GET /api/health
 * @description Check if the API is running and database is connected
 */
router.get('/', getHealth);

export default router;
