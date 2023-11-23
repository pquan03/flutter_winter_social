import { generateAccessToken, generateRefreshToken } from './../config/generateToken';
import Users from "../models/userModel";
import bcrypt from "bcrypt";
import { Request, Response } from "express";
import jwt from 'jsonwebtoken';
import { IDecodedType } from '../config/interface';
import { isVietnamesePhoneNumber, validateEmail } from '../middleware/valid';
import postModel from '../models/postModel';
const authCtrl = {
   register: async(req: Request, res: Response) => {
      try {
         const { fullname, username, email, password } = req.body;
         const newUserName = username.toLowerCase().replace(/ /g, '');

         const passwordHash = await bcrypt.hash(password, 12);

         const newUser = new Users({
            fullname, username: newUserName, email, password: passwordHash
         })
         
         const access_token = generateAccessToken({ id: newUser._id})
         const refresh_token = generateRefreshToken({ id: newUser._id}, res)

         await newUser.save();
         res.json({ 
            msg: 'Register successfully!',
            // access_token,
            // user: {
            //    ...newUser._doc,
            //    password: '',
            // }
         })
      } catch(err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   login: async(req: Request, res: Response) => {
      try {
         const { account, password} = req.body;
         let user;
         if(validateEmail(account)) {
            user = await Users.findOne({ email: account });
         } else if(isVietnamesePhoneNumber(account)) {
            user = await Users.findOne({ mobile: account });
         }else {
            user = await Users.findOne({ username: account });
         }
         if(!user) return res.status(400).json({ msg: 'This email does not exist!' });
         const isMatch = await bcrypt.compare(password, user.password);
         if(!isMatch) return res.status(400).json({ msg: 'Wrong password!' });
         
         const access_token = generateAccessToken({ id: user._id})
         const refresh_token = generateRefreshToken({ id: user._id}, res)
         const countPosts = await postModel.find({ user: user._id }).count();
         console.log(countPosts)
         res.json({ 
            msg: 'Login successfully!',
            refresh_token,
            access_token,
            user: {
               countPosts,
               ...user._doc,
               password: '',
            }
         })


      } catch(err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   logout: async(req: Request, res: Response) => {
      try {
         res.clearCookie('refreshtoken', { path: '/api/refresh_token' });
         return res.json({ msg: 'Logout successfully!' });
      } catch(err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   refreshToken: async(req: Request, res: Response) => {
      try {
         const rf_token = req.header('Authorization')?.split(' ')[1] || req.header('Authorization');        
         if(!rf_token) return res.status(400).json({ msg: 'Pleae, Login now!'})
         const decoded = <IDecodedType>jwt.verify(rf_token, `${process.env.REFRESH_TOKEN_SECRET}`);
         if(!decoded.id) return res.status(400).json({ msg: 'Pleae, Login now!'})
         const user = await Users.findById(decoded.id).select('-password');
         if(!user) return res.status(400).json({ msg: 'This account does not exist!' })
         const access_token = generateAccessToken({ id: user._id})
         const refresh_token = generateRefreshToken({ id: user._id}, res);
         const countPosts = await postModel.find({ user: user._id }).count();
         res.json({
            refresh_token,
            access_token,
            user: {
               countPosts,
               ...user._doc,
            },
            msg: 'Refresh Token Success!'
         })
      } catch(err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
   forgotPassword: async(req: Request, res: Response) => {
      try {
         const { account } = req.body;
         let user;
         if(validateEmail(account)) {
            user = await Users.findOne({ email: account }).select('avatar username');
         } else {
            user = await Users.findOne({ username: account }).select('avatar username');
         }
         if(!user) {
            return res.status(400).json({ msg: 'This email or username does not exist!' })
         } else {
            return res.status(200).json(user)
         }
      } catch(err: any) {
         return res.status(500).json({ msg: err.message })
      }
   },
}



export default authCtrl;