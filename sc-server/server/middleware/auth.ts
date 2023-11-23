import { IDecodedType } from './../config/interface';
import { Request, Response, NextFunction } from "express";
import Users from "../models/userModel";
import  Jwt  from "jsonwebtoken";
import { IReqAuthType } from './../config/interface';

export const auth = async(req: IReqAuthType, res: Response, next: NextFunction) => {
   try {
      const token = req.header('Authorization') ? req.headers.authorization?.split(' ')[1] : req.header('Authorization');
      if(!token) return res.status(400).json({ msg: 'Invalid Authentication!'}) 

      const decoded = <IDecodedType>Jwt.verify(token, `${process.env.ACCESS_TOKEN_SECRET}`);
      if(!decoded) return res.status(400).json({ msg: 'Invalid Authentication!'}) ;

      const user = await Users.findOne({ _id: decoded.id });
      if(!user) return res.status(400).json({ msg: 'This user does not exist!'}) ;
      req.user = user;
      next();
   } catch(err: any) {
      return res.status(500).json({ msg: err.message})
   }
}