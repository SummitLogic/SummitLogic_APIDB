import { Router } from 'express';
import {
  getAllItems,
  getItemById,
  createItem,
  updateItem,
  deleteItem,
  getAllBeverages,
  createBeverage,
  getAllSnacks,
  createSnack,
  getAllFood,
  createFood,
} from '../controllers/itemController';

const router = Router();

// Items endpoints
router.get('/all/items', getAllItems);
router.get('/items/:id', getItemById);
router.post('/items', createItem);
router.put('/items/:id', updateItem);
router.delete('/items/:id', deleteItem);

// Beverages endpoints
router.get('/beverages', getAllBeverages);
router.post('/beverages', createBeverage);

// Snacks endpoints
router.get('/snacks', getAllSnacks);
router.post('/snacks', createSnack);

// Food endpoints
router.get('/food', getAllFood);
router.post('/food', createFood);

export default router;
