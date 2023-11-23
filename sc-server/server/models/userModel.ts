import mongoose from 'mongoose';
import { IUser } from '../config/interface';

const userSchema = new mongoose.Schema({
   fullname: {
      type: String,
      required: true,
      trim: true,
      maxLength: 25
   },
   username: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      maxLength: 25,
   },
   email: {
      type: String,
      required: true,
      trim: true,
      unique: true,
   },
   password: {
      type: String,
      required: true,
      minLength: 6,
   },
   avatar: {
      type: String,
      default: 'https://res.cloudinary.com/devatchannel/image/upload/v1602752402/avatar/avatar_cugq40.png'
   },
   role: { type: String, default: 'user' },
   gender: { type: String, default: 'male' },
   mobile: { type: String, default: '', unique: true, trim: true },
   address: { type: String, default: '' },
   story: {
      type: String,
      default: '',
      trim: true,
      maxLength: 200
   },
   website: { type: String, default: '' },
   followers: [
      {
         type: mongoose.Schema.Types.ObjectId,
         ref: 'Users'
      }
   ],
   following: [
      {
         type: mongoose.Schema.Types.ObjectId,
         ref: 'Users'
      }
   ],
   saved: [
      {
         type: mongoose.Schema.Types.ObjectId,
         ref: 'Post'
      }
   ]
}, { timestamps: true })


export default mongoose.model<IUser>('Users', userSchema);