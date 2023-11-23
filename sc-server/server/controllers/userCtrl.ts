import Users from '../models/userModel'
import { Request, Response } from 'express'
import { IReqAuthType } from '../config/interface'
import bcrypt from "bcrypt"
import postModel from '../models/postModel'
import Conversation from '../models/conversationModel'
import Message from '../models/messageModel'
import { ApiFeatures } from './messageCtrl'

const userCtrl = {
   searchUser: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const users = await Users.find({ username: { $regex: req.query.username, $nin: req.user.username } }).limit(10).select('fullname username avatar')
         res.json(users)
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   searchUserWithMessage: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const users = await Users.find({ username: { $regex: req.query.username, $nin: req.user.username } }).limit(10).select('fullname username avatar')
         const newData = Promise.all(users.map(async(conversation: any) => { 
            const featuresMessage = new ApiFeatures(Message.find({ $or: [
               { senderId: req.user!._id, recipientId: conversation._id },
               { senderId: conversation._id, recipientId: req.user!._id },
            ] }), req.query).paginating();
            const messages = await featuresMessage.query.sort('-createdAt')
            console.log(messages.length);
            const newConversation = { ...conversation._doc, messages }
            return newConversation;
         }))
         const data = await newData;
         res.json(data)
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   getUser: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const user = await Users.findById(req.params.id).select('-password')
         if (!user) return res.status(400).json({ msg: 'User does not exist!' })
         const features = new ApiFeatures(postModel.find({ user: req.params.id }), req.query).paginating()
         const countPosts = await postModel.find({ user: req.params.id }).countDocuments()
         const posts = await features.query.sort('-createdAt').populate('user', 'avatar username fullname')
         const featuresMessage = new ApiFeatures(Message.find({ $or: [
            { senderId: req.user!._id, recipientId: req.params.id },
            { senderId: req.params.id, recipientId: req.user!._id },
         ] }), {
            limit: 20,
         }).paginating();
         const messages = await featuresMessage.query.sort('-createdAt')
         res.json({ user: {
            ...user._doc,
            countPosts,
         }, data: posts, messages })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   updateUser: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const { avatar, fullname, mobile, address, story, website, gender, username } = req.body;
         if (!fullname) return res.status(400).json({ msg: 'Please, Add your full name!' })
         await Users.findOneAndUpdate({ _id: req.user._id }, {
            avatar, fullname, mobile, address, story, website, gender, username
         })
         res.json({ msg: 'Update Success!' })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   follow: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const users = await Users.find({ _id: req.params.id, followers: req.user._id })
         if (users.length > 0) return res.status(400).json({ msg: 'You followed this user!' })

         await Users.findOneAndUpdate({ _id: req.params.id }, { $push: { followers: req.user._id } }, { new: true });
         await Users.findOneAndUpdate({ _id: req.user._id }, { $push: { following: req.params.id } }, { new: true });

         res.json({ msg: 'Follow Success!' })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   unfollow: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const users = await Users.find({ _id: req.params.id, followers: req.user._id })
         if (users.length === 0) return res.status(400).json({ msg: 'You do not follow this user!' })

         await Users.findOneAndUpdate({ _id: req.params.id }, { $pull: { followers: req.user._id } }, { new: true });
         await Users.findOneAndUpdate({ _id: req.user._id }, { $pull: { following: req.params.id } }, { new: true });

         res.json({ msg: 'Follow Success!' })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   suggestionsUser: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const newArr = [...req.user.following, req.user._id]; // List user have relationship with user
         const num = Number(req.query.num) || 10;

         const users = await Users.aggregate([
            { $match: { _id: { $nin: newArr } } },
            { $sample: { size: num } },
            { $lookup: { from: 'users', localField: 'followers', foreignField: '_id', as: 'followers' } },
            { $lookup: { from: 'users', localField: 'following', foreignField: '_id', as: 'following' } },
         ]).project({ password: false })

         res.json({
            users,
            total: users.length
         })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   resetPassword: async (req: Request, res: Response) => {
      console.log(req.body);
      try {
         const { _id, password } = req.body;
         const passwordHash = await bcrypt.hash(password, 12);
         await Users.findOneAndUpdate({ _id }, { password: passwordHash })
         res.json({ msg: 'OK' })
      } catch(err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   getInfoListUser: async (req: IReqAuthType, res: Response) => {
      try {
         const users = await Users.find({ _id: { $in: req.body } }).select('avatar username fullname')
         res.json(users)
      } catch(err: any) {
         return res.status(500).json({ msg: err.message })
      }
   }
}

export default userCtrl;