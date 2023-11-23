import mongoose from "mongoose";


enum NOTIFY_TYPES {
   POST = "post",
   REEL = "reel",
   FOLLOW = "follow",
   MESSAGE = "message"
}

const notifySchema = new mongoose.Schema({
   user: {type: mongoose.Schema.Types.ObjectId, ref: "Users"},
   recipients: [mongoose.Types.ObjectId],
   url: String,
   text: String,
   type:  {
      type: String,
      enum: NOTIFY_TYPES,
   },
   content: String,
   image: String,
   isRead: {type: Boolean, default: false},
}, { timestamps: true});


export default mongoose.model("Notify", notifySchema);