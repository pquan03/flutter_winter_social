import mongoose from "mongoose";

const messageSchema = new mongoose.Schema({
   conversationId: { type: mongoose.Schema.Types.ObjectId, ref: "Conversation" },
   senderId: { type: mongoose.Schema.Types.ObjectId, ref: "Users" },
   recipientId: { type: mongoose.Schema.Types.ObjectId, ref: "Users" },
   linkPost: { type: mongoose.Schema.Types.ObjectId, ref: "Post" },
   linkReel: { type: mongoose.Schema.Types.ObjectId, ref: "Reel" },
   linkStory: { type: mongoose.Schema.Types.ObjectId, ref: "Story" },
   text: String,
   media: Array,
   call: Object,
}, { timestamps: true })


export default mongoose.model("Message", messageSchema);