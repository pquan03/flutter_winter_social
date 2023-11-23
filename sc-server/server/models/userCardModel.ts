import mongoose from "mongoose";
import { UserCart} from "../config/interface";


const userCartSchema = new mongoose.Schema({
     user: { 
          type: mongoose.Types.ObjectId,
          ref: 'User'
     },
     cart: {
          type: [{
               product: {
                    type: mongoose.Types.ObjectId,
                    ref: 'Product'
               },
               quantity: Number,
          }],
          default: []
     },
     createdAt: {
          type: Date,
          default: Date.now
     },
     updatedAt: {
          type: Date,
          default: Date.now
     },
});

export default mongoose.model<UserCart>('UserCart', userCartSchema)