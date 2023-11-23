import { IReqAuthType } from "../config/interface";
import { Request, Response } from "express";
import storyModel from "../models/storyModel";
import Users from "../models/userModel";

const storyCtrl = {
    createStory: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const { media, duration } = req.body;
            const newStory = new storyModel({
                user: req.user._id,
                media: {
                    media, duration
                }
            })
            await newStory.save();
            res.json({
                ...newStory._doc,
                user: req.user
            })
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    },
    getStories: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const following = [...req.user.following, req.user._id];
            // get all stories of following, 24h
            const stories = await storyModel.aggregate(
                [
                    {
                        $match:
                        {
                            $and: [
                                { user: { $in: following } },
                                { createdAt: { $gte: new Date(new Date().setDate(new Date().getDate() - 1)) } }
                            ]
                        }
                    },
                    { $sort: { createdAt: 1 } },
                    {
                        $lookup: {
                            from: 'users',
                            let: { user_id: '$user' },
                            pipeline: [
                                { $match: { $expr: { $eq: ['$_id', '$$user_id'] } } },
                                { $project: { username: 1, avatar: 1 } }
                            ],
                            as: 'user'
                        }
                    },
                    { $unwind: '$user' },
                    {
                        $group: {
                            _id: '$user._id',
                            user: { $addToSet: '$user' },
                            stories: { $push: '$$ROOT' }
                        }
                    },
                    {
                        $project: {
                            user: { $arrayElemAt: ['$user', 0] },
                            stories: { $slice: ['$stories', 10] }
                        }
                    }
                ]
            )
            res.json(stories)
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    },
    deleteStory: async (req: IReqAuthType, res: Response) => {
        if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
        try {
            const story = await storyModel.findOneAndDelete({
                _id: req.params.id,
                user: req.user._id
            })
            if (!story) return res.status(400).json({ msg: 'Story not found!' })
        } catch (err: any) {
            return res.status(500).json({ msg: err.message })
        }
    }
};


export default storyCtrl;