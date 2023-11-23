import mongoose from "mongoose";
import { IStory } from "../config/interface";

const storySchema = new mongoose.Schema({
    user: { type: mongoose.Types.ObjectId, ref: 'Users' },
    media: {
        media: String,
        duration: Number
    },
    likes: [{ type: mongoose.Types.ObjectId, ref: 'Users' }]
}, { timestamps: true})


export default mongoose.model<IStory>('Story', storySchema)