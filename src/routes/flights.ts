import { Router } from 'express';
import {
  getAllFlights,
  getFlightById,
  createFlight,
  updateFlight,
  deleteFlight,
} from '../controllers/flightController';

const router = Router();

router.get('/', getAllFlights);
router.get('/:id', getFlightById);
router.post('/', createFlight);
router.put('/:id', updateFlight);
router.delete('/:id', deleteFlight);

export default router;
