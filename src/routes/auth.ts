import type { Router as ExpressRouter } from 'express';
import { Router } from 'express';
import { register, login } from '../controllers/authController';

const router: ExpressRouter = Router();

/**
 * @route POST /api/auth/register
 * @description Register a new user
 * @body {email, password, firstName, lastName}
 */
router.post('/register', register);

/**
 * @route POST /api/auth/login
 * @description Login an existing user
 * @body {email, password}
 */
router.post('/login', login);

export default router;
