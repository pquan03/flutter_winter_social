import mongoose from "mongoose";
import { IProduct } from "../config/interface";

const productSchema = new mongoose.Schema({
     user: {
          type: mongoose.Types.ObjectId,
          ref: 'User'
     },
     medias: {
          type: Array,
          required: true
     },
     title: {
          type: String,
          required: true,
          maxKength: 200,
          trim: true,
     },
     description: {
          type: String,
          required: true,
          maxKength: 2000,
          trim: true
     },
     price: {
          type: Number,
          required: true,
     },
     numberOfStock: {
          type: Number,
          required: true,
     },
     numberOfSold: {
          type: Number,
          default: 0
     },
     variants: {
          type: [{
               title: {
                    type: String,
                    required: true,
                    trim: true,
               },
               options: [String]
          }],
          required: true
     },
     category: {
          type: String,
          required: true,
     },
     rates: [{
          star: Number,
          comment: String,
     }],
     createdAt: {
          type: Date,
          default: Date.now
     },
     updatedAt: {
          type: Date,
          default: Date.now
     },
}, { timestamps: true})

export default mongoose.model<IProduct>('Product', productSchema)
