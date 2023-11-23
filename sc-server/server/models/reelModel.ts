import mongoose from "mongoose";
import { IReel } from "../config/interface";


const reelSchema = new mongoose.Schema({
    content: {
        type: String,
        maxLength: 50,
    },
    videoUrl: {
        type: String,
        require: true        
    },
    backgroundUrl: {
        type: String,
        require: true
    },
    comments: [{type: mongoose.Types.ObjectId, ref: 'Comment'}],
    user: { type: mongoose.Types.ObjectId, ref: 'Users' },
    likes: [{type: mongoose.Types.ObjectId, ref: 'Users'}],
}, { timestamps: true});

export default mongoose.model<IReel>("Reel", reelSchema);