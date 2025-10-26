import { Router } from 'express';
import {
  getAllBottles,
  createBottle,
  updateBottle,
  getAllPackPlans,
  createPackPlan,
  updatePackPlan,
  getAllCarts,
  createCart,
  updateCart,
  getAllTrays,
  createTray,
} from '../controllers/inventoryController';

const router = Router();

// Bottles endpoints
router.get('/bottles', getAllBottles);
router.post('/bottles', createBottle);
router.put('/bottles/:id', updateBottle);

// Pack Plans endpoints
router.get('/pack-plans', getAllPackPlans);
router.post('/pack-plans', createPackPlan);
router.put('/pack-plans/:id', updatePackPlan);

// Carts endpoints
router.get('/carts', getAllCarts);
router.post('/carts', createCart);
router.put('/carts/:id', updateCart);

// Trays endpoints
router.get('/trays', getAllTrays);
router.post('/trays', createTray);

export default router;
