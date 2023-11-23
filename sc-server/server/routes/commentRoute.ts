import express from 'express';
import { auth } from '../middleware/auth';
import commentCtrl from '../controllers/commentCtrl';
const router = express.Router();

router.post('/comment_post', auth, commentCtrl.createCommentPost);
router.post('/comment_reel', auth, commentCtrl.createCommentReel);
router.post('/post_comments/:id', auth, commentCtrl.getPostComments);
router.post('/reel_comments/:id', auth, commentCtrl.getReelComments);
router.get('/replies_comments/:id', commentCtrl.getRepliesComment);
router.patch('/comment/:id', auth, commentCtrl.updateComment);
router.patch('/comment/:id/like', auth, commentCtrl.likeComment);
router.patch('/comment/:id/unlike', auth, commentCtrl.unLikeComment);
router.delete('/comment/:id/post/:postId', auth, commentCtrl.deleteComment);

router.post('/comment/:id/answer', auth, commentCtrl.createAnswerComment);

export default router;