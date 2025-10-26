import { Router } from 'express';
import {
  getAllAirlines,
  getAirlineById,
  createAirline,
  updateAirline,
  deleteAirline,
} from '../controllers/airlineController';

const router = Router();

router.get('/', getAllAirlines);
router.get('/:id', getAirlineById);
router.post('/', createAirline);
router.put('/:id', updateAirline);
router.delete('/:id', deleteAirline);

export default router;
