import express from 'express';
import { auth } from '../middleware/auth';
import messageCtrl from '../controllers/messageCtrl';
const router = express.Router();

router.post('/message', auth, messageCtrl.createMessage);
router.get('/conversations', auth, messageCtrl.getConversation);
router.get('/messages/:id', auth, messageCtrl.getMessages);
router.delete('/messages/:id', auth, messageCtrl.deleteMessage);
router.delete('/conversation/:id', auth, messageCtrl.deleteConversation)
router.patch('/read_message/:id/read', auth, messageCtrl.readMessage);
router.patch('/read_message/:id/unread', auth, messageCtrl.readMessage);
export default router;