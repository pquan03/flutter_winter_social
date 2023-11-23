import mongoose from "mongoose";
import { IPost } from "../config/interface";


const postSchema = new mongoose.Schema({
   content: {
      type: String,
      maxLength: 50,
   },
   images: {
      type: Array,
      default:  [],
      require: true
   },
   likes: [ {type: mongoose.Types.ObjectId, ref: 'Users'} ],
   user: { type: mongoose.Types.ObjectId, ref: 'Users' },
   comments: [ {type: mongoose.Types.ObjectId, ref: 'Comment'}  ],
}, { timestamps: true });



export default mongoose.model<IPost>("Post", postSchema);

