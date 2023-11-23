import notifyCtrl from "../controllers/notifyCtrl";
import express from 'express';
const router = express.Router();
import { auth } from "../middleware/auth";

router.post('/notify', auth, notifyCtrl.createNotify);
router.delete('/notify/:id', auth, notifyCtrl.deleteNotify);
router.get('/notify', auth, notifyCtrl.getNotifies)
router.patch('/isReadNotify/:id', auth, notifyCtrl.isRead)
router.delete('/deleteAllNotfies', auth, notifyCtrl.deleteAllNotfies)

export default router;

