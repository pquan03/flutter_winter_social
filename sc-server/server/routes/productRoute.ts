import express from 'express';
import { auth } from '../middleware/auth';
import productCtrl from '../controllers/productCtrl';
const router = express.Router();

router.route('/products')
     .post(auth, productCtrl.createProduct)