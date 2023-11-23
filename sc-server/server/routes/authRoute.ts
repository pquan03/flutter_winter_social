import express from 'express';
import authCtrl from '../controllers/authCtrl';
import { CheckEmailExists, checkUserNameExists, validateRegister } from '../middleware/valid';


const router = express.Router();

router.post('/register', validateRegister, authCtrl.register);
router.post('/check_user_name', checkUserNameExists);
router.post('/check_email', CheckEmailExists);
router.post('/forgot_password', authCtrl.forgotPassword);
router.post('/login', authCtrl.login);
router.post('/logout', authCtrl.logout);
router.get('/refresh_token', authCtrl.refreshToken);


export default router;