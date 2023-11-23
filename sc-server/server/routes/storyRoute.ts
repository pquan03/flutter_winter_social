import express from 'express';
import { auth } from '../middleware/auth';
import storyCtrl from '../controllers/storyCtrl';

const router = express.Router();


router.route('/story')
    .post(auth, storyCtrl.createStory)
    .get(auth, storyCtrl.getStories)

router.delete('/story/:id', auth, storyCtrl.deleteStory)

export default router;