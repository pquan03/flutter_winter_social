import { IReqAuthType } from "../config/interface";
import { Request, Response } from "express";
import productModel from "../models/productModel";


const productCtrl = {
     createProduct: async (req: IReqAuthType, res: Response) => {
          if (!req.user) return res.status(400).json({ msg: 'Invalid Authentication!' })
          try {
               const { medias, title, description, price, numberOfStock, variants, category } = req.body;
               const newProduct = new productModel({
                    user: req.user._id,
                    medias, title, description, price, numberOfStock, variants, category
               })
               await newProduct.save();
               res.json({
                    ...newProduct._doc,
                    user: req.user
               })
          } catch (err: any) {
               return res.status(500).json({ msg: err.message })
          }
     },
}

export default productCtrl;