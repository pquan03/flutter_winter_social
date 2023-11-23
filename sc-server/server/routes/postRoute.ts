import express from 'express';
import postCtrl from '../controllers/postCtrl';
import { auth } from '../middleware/auth';
const router = express.Router();

router.route('/posts')
      .post(auth, postCtrl.createPost)
      .get(auth, postCtrl.getPost);

router.route('/posts/:id')
      .patch(auth, postCtrl.updatePost)
      .get(auth, postCtrl.getDetailPost)
      .delete(auth, postCtrl.deletePost);

router.patch('/posts/:id/like', auth, postCtrl.likePost);
router.patch('/posts/:id/unlike', auth, postCtrl.unLikesPost);

router.get('/user_posts/:id', auth, postCtrl.getUserPosts);
router.get('/post_discover', auth, postCtrl.getPostsDiscover);
router.patch('/save_post/:id/save' , auth, postCtrl.savePost);
router.patch('/save_post/:id/unsave' , auth, postCtrl.unsavePost);
router.get('/saved_posts', auth, postCtrl.getSavedPosts);
export default router;
