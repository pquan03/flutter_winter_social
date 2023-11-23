import Message from '../models/messageModel';
import Conversation from '../models/conversationModel';
import { Request, Response } from 'express';
import { IReqAuthType } from '../config/interface';

export class ApiFeatures {
   query: any;
   queryString: any
   constructor(query: any, queryString: any) {
      this.query = query;
      this.queryString = queryString
   }

   paginating() {
      const page = this.queryString.page * 1 || 1;
      const limit = this.queryString.limit * 1 || 20;
      const skip = (page - 1) * limit;
      this.query = this.query.skip(skip).limit(limit);
      return this
   }
}

const messageCtrl = {
   createMessage: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         console.log(req.body)
         const { recipientId, text, media, call, linkPost, linkReel, linkStory } = req.body;
         if (!recipientId) return;
         const newConversation = await Conversation.findOneAndUpdate({
            $or: [
               { recipients: [req.user._id, recipientId] },
               { recipients: [recipientId, req.user._id] }
            ]
         }, {
            recipients: [req.user._id, recipientId],
            text, media, call, isRead: [req.user._id],
         }, { new: true, upsert: true }).populate('recipients', 'avatar username fullname')
         const message = new Message({
            conversationId: newConversation._id,
            senderId: req.user._id,
            recipientId,
            linkPost: linkPost ? linkPost : null,
            linkReel: linkReel ? linkReel : null,
            linkStory: linkStory ? linkStory : null,
            text,
            media,
            call,
         })
         await message.save();
         res.json({
            conversation: newConversation,
            message: {
               ...(message as any)._doc,
               linkPost: linkPost,
               linkReel: linkReel,
               linkStory: linkStory,
            }
         })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   readMessage: async (req: IReqAuthType, res: Response) => {
      try {
         await Conversation.findByIdAndUpdate(req.params.id, {
            $push: { isRead: req.user?._id }
         }, { new: true})
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   unReadMessage: async (req: IReqAuthType, res: Response) => {
      try {
         await Conversation.findOneAndUpdate({
            $and: [
               { _id: req.params.id },
               { isRead: req.user?._id }
            ]
         }, {
            $pull: { isRead: req.user?._id }
         }, { new: true })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   getConversation: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const featuresConversation = new ApiFeatures(Conversation.find({
            recipients: { $in: [req.user._id] }
         }), req.query).paginating();
         const conversations = await featuresConversation.query.select('-text -call -media').populate('recipients', 'avatar username fullname').sort('-updatedAt');
         const newData = Promise.all(conversations.map(async (conversation: any) => {
            const featuresMessage = new ApiFeatures(Message.find({ conversationId: conversation._id }), req.query).paginating();
            const messages = await featuresMessage.query.sort('-createdAt')
               .populate(
                  {
                     path: 'linkPost',
                     populate: {
                        path: 'user',
                        select: 'avatar username fullname'
                     }
                  }
               )
               .populate(
                  {
                     path: 'linkReel',
                     populate: {
                        path: 'user',
                        select: 'avatar username fullname'
                     }
                  }
               )
               .populate(
                  {
                     path: 'linkStory',
                     populate: {
                        path: 'user',
                        select: 'avatar username fullname'
                     }
                  }
               )
            const newConversation = { ...conversation._doc, messages, isRead: conversation.isRead, }
            return newConversation;
         }))
         const data = await newData;
         res.json(data);
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   getMessages: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         // find from conversationId and recipients , recipients have two senderId and recipientId
         const features = new ApiFeatures(Message.find({
            $or: [
               { conversationId: req.params.id },
               { senderId: req.user._id, recipientId: req.params.id },
               { senderId: req.params.id, recipientId: req.user._id },
            ]
         }), req.query).paginating();
         const messages = await features.query.sort('-createdAt')
         res.json(messages);
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   deleteMessage: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         await Message.findByIdAndDelete(req.params.id)
         res.json({ msg: 'Message deleted successfully!' })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   deleteConversation: async (req: IReqAuthType, res: Response) => {
      if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
      try {
         const conversation = await Conversation.findOneAndDelete({
            $or: [
               { recipients: [req.user._id, req.params.id] },
               { recipients: [req.params.id, req.user._id] }
            ]
         })
         if (!conversation) return res.status(400).json({ msg: 'This conversation does not exist!' })
         await Message.deleteMany({ conversation: conversation._id })

         res.json({ msg: 'Delete Success!' })
      } catch (err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
}


export default messageCtrl;