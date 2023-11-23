import { IComment } from "../config/interface";
import { IReqAuthType } from "../config/interface";
import { Request, Response } from "express";
import Comments from "../models/commentModel";
import Posts from "../models/postModel";
import { ApiFeatures } from "./postCtrl";
import reelModel from "../models/reelModel";


const commentCtrl = {
   createCommentPost: async (req: IReqAuthType, res: Response) => {
      if(!req.user) return res.status(401).json({ message: 'Invalid Authentication!' });
      try {
         const { postId, content} = req.body;   
         console.log(req.body)
         const newComment = new Comments({
            user: req.user._id, content,
         })
         const post = await Posts.findByIdAndUpdate(postId, { $push: { comments: newComment._id }}, { new: true});
         if(!post) return res.status(400).json({ msg: 'Post not found!' });
         await newComment.save();
         res.json({
            ...newComment._doc,
            user: {
               _id: req.user._id,
               username: req.user.username,
               avatar: req.user.avatar
            }
         })
      } catch(err: any) {
         return res.status(500).json({ message: err.message });
      }
   },
   createCommentReel: async (req: IReqAuthType, res: Response) => {
      if(!req.user) return res.status(401).json({ message: 'Invalid Authentication!' });
      try {
         const { postId, content} = req.body;   
         const newComment = new Comments({
            user: req.user._id, content,
         })
         const post = await reelModel.findByIdAndUpdate(postId, { $push: { comments: newComment._id }}, { new: true});
         if(!post) return res.status(400).json({ msg: 'Post not found!' });
         await newComment.save();
         res.json({
            ...newComment._doc,
            user: {
               _id: req.user._id,
               username: req.user.username,
               avatar: req.user.avatar
            }
         })
      } catch(err: any) {
         return res.status(500).json({ message: err.message });
      }
   },
   getPostComments: async (req: IReqAuthType, res: Response) => {
      if(!req.user) return res.status(401).json({ message: 'Invalid Authentication!' });
      try {
         const post = await Posts.findById(req.params.id);
         if(!post) return res.status(400).json({ msg: 'Post not found!' });
         const features = new ApiFeatures(Comments.find({ _id: { $in: post.comments } }), req.query).paginating();
         const comments = await features.query
         .populate('user', 'avatar username')
         .populate('tag', 'avatar')
         .populate({
            path: 'reply',
            populate: {
               path: 'user',
               select: '-password -followers -following -createdAt -updatedAt -__v -fullname -email -website -role -gender -mobile -address -saved -story',
            },
         })
         .sort('-createdAt');
         res.json(comments);
      } catch(err: any) {
         return res.status(500).json({ message: err.message });
      }
   },
   getReelComments: async (req: IReqAuthType, res: Response) => {
      if(!req.user) return res.status(401).json({ message: 'Invalid Authentication!' });
      try {
         const post = await reelModel.findById(req.params.id);
         if(!post) return res.status(400).json({ msg: 'Post not found!' });
         const features = new ApiFeatures(Comments.find({ _id: { $in: post.comments } }), req.query).paginating();
         const comments = await features.query
         .populate('user', 'avatar username')
         .populate('tag', 'avatar')
         .populate({
            path: 'reply',
            populate: {
               path: 'user',
               select: '-password -followers -following -createdAt -updatedAt -__v -fullname -email -website -role -gender -mobile -address -saved -story',
            },
         })
         .sort('-createdAt');
         res.json(comments);
      } catch(err: any) {
         return res.status(500).json({ message: err.message });
      }
   },
   getRepliesComment: async (req: Request, res: Response) => {
      // if(!req.user) return res.status(401).json({ message: 'Invalid Authentication!' });
      try {
         const comment = await Comments.findById(req.params.id);
         if(!comment) return res.status(400).json({ msg: 'Post not found!' });
         const features = new ApiFeatures(Comments.find({ _id: { $in: comment.reply } }), req.query).paginating();
         const comments = await features.query.populate('user', 'avatar username').sort('-createdAt');
         let data = (comments).map((e: any) => {
            return {
               ...e._doc,
               tag: {
                  _id: e.tag._id,
                  username: e.tag.username,
                  avatar: e.tag.avatar
               }
            }
         })
         res.json(data);
      } catch(err: any) {
         return res.status(500).json({ message: err.message });
      }
   },
   updateComment: async (req: IReqAuthType, res: Response) => {
      if(!req.user) return res.status(401).json({ message: 'Invalid Authentication!' });
      try {
         const {  content } = req.body;   
         await Comments.findByIdAndUpdate(req.params.id, { content });
         res.json({ msg: 'Comment updated!' })
      } catch(err: any) {
         return res.status(500).json({ message: err.message });
      }
   },
   likeComment : async (req: IReqAuthType, res: Response) => {
      if(!req.user) return res.status(401).json({ message: 'Invalid Authentication!' });
      try {
         const comment = await Comments.find({ _id: req.params.id, likes: req.user._id })
         if(comment.length > 0) return res.status(400).json({ msg: 'You already liked this comment!' })
         await Comments.findByIdAndUpdate(req.params.id, { $push: { likes: req.user._id }}, { new: true});
         res.json({ msg: 'Like Success!'})
      } catch(err: any) {
         return res.status(500).json({ message: err.message });
      }
   },
   unLikeComment: async (req: IReqAuthType, res: Response) => {
      if(!req.user) return res.status(401).json({ message: 'Invalid Authentication!' });
      try {
         const comment = await Comments.find({ _id: req.params.id, likes: req.user._id })
         if(comment.length === 0) return res.status(400).json({ msg: 'you do not unlike this comment! ' })
         await Comments.findByIdAndUpdate(req.params.id, { $pull: { likes: req.user._id }}, { new: true});
         res.json({ msg: 'Unlike Success!'})
      } catch(err: any) {
         return res.status(500).json({ message: err.message });
      }
   },
   deleteComment: async (req: IReqAuthType, res: Response) => {
      if(!req.user) return res.status(401).json({ message: 'Invalid Authentication!' });
      try {
         await Comments.findByIdAndDelete(req.params.id);
         await Posts.findOneAndUpdate({ _id: req.params.postId }, { $pull: { comments: req.params.id }}, { new: true});
         res.json({ msg: 'Comment deleted!' })
      } catch(err: any) {
         return res.status(500).json({ message: err.message });
      }
   },
   createAnswerComment: async (req: IReqAuthType, res: Response) => {
      if(!req.user) return res.status(401).json({ message: 'Invalid Authentication!' });
      try {
         const { postId, content, tag} = req.body;   
         const post = await Posts.findById(postId);
         if(!post) return res.status(400).json({ msg: 'Post does not exist!' })
         const newComment = new Comments({
            user: req.user._id, content, tag, commentRootId: req.params.id
         })
         await Comments.findByIdAndUpdate(req.params.id, { $push: { reply: newComment._id }}, { new: true});
         await newComment.save();

         res.json({
            ...newComment._doc,
            user: {
               _id: req.user._id,
               username: req.user.username,
               avatar: req.user.avatar
            }
         })
      } catch(err: any) {
         return res.status(500).json({ message: err.message });
      }
   },
}

export default commentCtrl;