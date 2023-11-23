import Reel from "../models/reelModel";
import Users from "../models/userModel";
import { IReqAuthType } from "../config/interface";
import { Request, Response } from "express";
import Comment from "../models/commentModel";
import reelModel from "../models/reelModel";

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


const ReelCtrl = {
    createReel: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const { content, videoUrl, backgroundUrl } = req.body;
            const newReel = new Reel({ content, videoUrl, user: req.user._id, backgroundUrl })
            await newReel.save();
            res.json({
                ...((newReel as any)._doc),
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
    getReel: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const features = new ApiFeatures(Reel.find({}), req.query).paginating()
            const reels = await features.query.sort('-createdAt').populate('user', 'avatar username')
            res.json(reels)
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    },
    likePost: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const post = await Reel.find({ _id: req.params.id, likes: req.user._id })
            if (!post) return res.status(400).json({ msg: 'Invalid Post!' })
            if (post.length > 0) return res.status(400).json({ msg: 'You already liked this post!' })
            await Reel.findOneAndUpdate({ _id: req.params.id }, { $push: { likes: req.user._id } }, { new: true })
            res.json({ msg: 'Like Success!' })
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    },
    unLikesPost: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const post = await Reel.find({ _id: req.params.id, likes: req.user._id })
            if (!post) return res.status(400).json({ msg: 'Invalid Post!' })
            if (post.length === 0) return res.status(400).json({ msg: 'you do not unlike this post! ' })
            await Reel.findOneAndUpdate({ _id: req.params.id }, { $pull: { likes: req.user._id } }, { new: true })
            res.json({ msg: 'UnLike Success!' })
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    },
    getUserPosts: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const features = new ApiFeatures(Reel.find({ user: req.params.id }), req.query).paginating()
            const posts = await features.query.sort('-createdAt').populate('user', 'avatar username')
            res.json(posts)
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    },
    saveReel: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const user = await Users.find({ _id: req.user._id, saved: req.params.id });
            if (user.length > 0) return res.status(400).json({ msg: 'You saved this reel' })
            const save = await Users.findOneAndUpdate({ _id: req.user._id }, { $push: { saved: req.params.id } }, { new: true })
            if (!save) return res.status(400).json({ msg: 'Save reel failed!' })
            res.json({ msg: 'Save Success!' })
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    },
    unsaveReel: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const user = await Users.find({ _id: req.user._id, saved: req.params.id });
            if (user.length === 0) return res.status(400).json({ msg: 'You do not save this reel' })
            const save = await Users.findOneAndUpdate({ _id: req.user._id }, { $pull: { saved: req.params.id } }, { new: true })
            if (!save) return res.status(400).json({ msg: 'Save reel failed!' })
            res.json({ msg: 'Un save Success!' })
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    },
    getSavedReel: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const features = new ApiFeatures(reelModel.find({ _id: { $in: req.user.saved } }), req.query).paginating()
            const reels = await features.query.sort('-createdAt').populate('user', 'avatar username fullname')
            res.json(reels);
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    },
    getUserReel: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const features = new ApiFeatures(Reel.find({ user: req.params.id }), req.query).paginating()
            const posts = await features.query.sort('-createdAt').populate('user', 'avatar username')
            res.json(posts)
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    },
    deleteReel: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const reel = await Reel.findByIdAndDelete({ _id: req.params.id, user: req.user._id })
            if (!reel) return res.status(400).json({ msg: 'Reel does not exist!' })
            await Comment.deleteMany({ _id: { $in: reel.comments } })
            res.json({ msg: 'Delete Success!' })
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    }
}

export default ReelCtrl;