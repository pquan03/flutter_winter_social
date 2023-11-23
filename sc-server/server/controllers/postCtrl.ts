import Posts from '../models/postModel';
import { IPost } from '../config/interface';
import { IReqAuthType } from '../config/interface';
import { Request, Response } from 'express';
import Comment from '../models/commentModel';
import Users from '../models/userModel';

// 
export class ApiFeatures {
   query: any;
   queryString: any
   constructor(query: any, queryString: any) {
      this.query = query;
      this.queryString = queryString
   }

   paginating() {
      const page = this.queryString.page * 1 || 1;
      const limit = this.queryString.limit * 1 || 9;
      const skip = (page - 1) * limit;
      this.query = this.query.skip(skip).limit(limit);
      return this
   }
}

const postCtrl = {
   createPost: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const { content, images } = req.body;
         const newPost = new Posts({ content, images, user: req.user._id })
         await newPost.save();
         res.json({
            ...(newPost._doc),
            user: {
               _id: req.user._id,
               username: req.user.username,
               avatar: req.user.avatar
            }
         }
         )
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   getPost: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const features = new ApiFeatures(Posts.find({ user: [...req.user.following, req.user._id] }), req.query).paginating()
         const posts = await features.query.sort('-createdAt').populate('user', 'avatar username')
         res.json(posts)
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   updatePost: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const { content, images } = req.body;
         await Posts.findOneAndUpdate({ _id: req.params.id }, { content, images })
         res.json({ msg: 'Update Success!' })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   likePost: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const post = await Posts.find({ _id: req.params.id, likes: req.user._id })
         if (!post) return res.status(400).json({ msg: 'Invalid Post!' })
         if (post.length > 0) return res.status(400).json({ msg: 'You already liked this post!' })
         await Posts.findOneAndUpdate({ _id: req.params.id }, { $push: { likes: req.user._id } }, { new: true })
         res.json({ msg: 'Like Success!' })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   unLikesPost: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const post = await Posts.find({ _id: req.params.id, likes: req.user._id })
         if (!post) return res.status(400).json({ msg: 'Invalid Post!' })
         if (post.length === 0) return res.status(400).json({ msg: 'you do not unlike this post! ' })
         await Posts.findOneAndUpdate({ _id: req.params.id }, { $pull: { likes: req.user._id } }, { new: true })
         res.json({ msg: 'UnLike Success!' })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   getUserPosts: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const features = new ApiFeatures(Posts.find({ user: req.params.id }), req.query).paginating()
         const posts = await features.query.sort('-createdAt').populate('user', 'avatar username')
         res.json(posts)
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   getDetailPost: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const post = await Posts.findOne({ _id: req.params.id })
            .populate('user likes', 'avatar username fullname followers')
            .populate({
               path: 'comments',
               populate: {
                  path: 'user likes',
                  select: '-password',
               },
            })
            .populate({
               path: 'comments',
               populate: {
                  path: 'reply',
                  populate: {
                     path: 'user likes',
                  }
               },
            })
         if (!post) return res.status(400).json({ msg: 'Post does not exist!' })

         res.json({
            post
         })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   getPostsDiscover: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const features = new ApiFeatures(Posts.find({ user:{$nin: [...req.user.following, req.user._id] }}), req.query).paginating()
         const posts = await features.query.sort('-createdAt').populate('user', 'avatar username')
         res.json(posts);
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   deletePost: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const post = await Posts.findOneAndDelete({ _id: req.params.id, user: req.user._id })
         if (!post) return res.status(400).json({ msg: 'Post does not exist!' })
         await Comment.deleteMany({ _id: { $in: post.comments } })
         res.json({
            msg: 'Delete Success!',
            post: {
               ...post,
               user: req.user
            }
         })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   savePost: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const user = await Users.find({ _id: req.user._id, saved: req.params.id });
         if (user.length > 0) return res.status(400).json({ msg: 'You saved this post' })
         const save = await Users.findOneAndUpdate({ _id: req.user._id }, { $push: { saved: req.params.id } }, { new: true })
         if (!save) return res.status(400).json({ msg: 'Save post failed!' })
         res.json({ msg: 'Save Success!' })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   unsavePost: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const user = await Users.find({ _id: req.user._id, saved: req.params.id });
         if (user.length === 0) return res.status(400).json({ msg: 'You do not save this post' })
         const save = await Users.findOneAndUpdate({ _id: req.user._id }, { $pull: { saved: req.params.id } }, { new: true })
         if (!save) return res.status(400).json({ msg: 'Save post failed!' })
         res.json({ msg: 'Un save Success!' })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   getSavedPosts: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const features = new ApiFeatures(Posts.find({ _id: { $in: req.user.saved } }), req.query).paginating()
         const posts = await features.query.sort('-createdAt').populate('user', 'avatar username fullname')
         res.json(posts);
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
}


export default postCtrl;