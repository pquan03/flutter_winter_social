import mongoose from "mongoose";
import { IComment } from "../config/interface";

const commentSchema = new mongoose.Schema({
   content: {
      type: String,
      required: true,
      trim: true
   },
   tag: Object,
   reply: [{ type: mongoose.Types.ObjectId, ref: "Comment" }],
   commentRootId: mongoose.Types.ObjectId,
   likes: [{ type: mongoose.Types.ObjectId, ref: "Users" }],
   user: {type: mongoose.Types.ObjectId, ref: 'Users'},
   postId: mongoose.Types.ObjectId,
   postUserId: mongoose.Types.ObjectId
}, { timestamps: true });



export default mongoose.model<IComment>("Comment", commentSchema);

