import express from 'express';
import ReelCtrl from '../controllers/reelCtrl';
import { auth } from '../middleware/auth';
const router = express.Router();

router.route('/reels')
    .post(auth, ReelCtrl.createReel)
    .get(auth, ReelCtrl.getReel);


router.patch('/reel/:id/like', auth, ReelCtrl.likePost);
router.patch('/reel/:id/unlike', auth, ReelCtrl.unLikesPost);
router.patch('/save_reel/:id/save' , auth, ReelCtrl.saveReel);
router.patch('/save_reel/:id/unsave' , auth, ReelCtrl.unsaveReel);
router.get('/saved_reels', auth, ReelCtrl.getSavedReel);
router.get('/user_reel/:id', auth, ReelCtrl.getUserReel);


router.delete('/reel/:id', auth, ReelCtrl.deleteReel);

export default router;
