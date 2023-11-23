import { Request, Response, NextFunction } from "express"
import Users from "../models/userModel";

export const checkUserNameExists = async (req: Request, res: Response) => {
   const { username } = req.body;
   const user = await Users.findOne({ username: username })
   if (user) return res.status(500).json({ msg: 'This user name alredy exists!' })
   return res.status(200).json({ msg: 'OK' })
}

export const CheckEmailExists = async (req: Request, res: Response) => {
   const { email } = req.body;
   if (validateEmail(email)) {
      const user = await Users.findOne({ email: email })
      if (user) return res.status(500).json({ msg: 'This email alredy exists!' })
      return res.status(200).json({ msg: 'OK' })
   } else {
      return res.status(500).json({ msg: 'Invalid email!' })
   }
}


export const validateRegister = async (req: Request, res: Response, next: NextFunction) => {
   const { fullname, username, email, password } = req.body;
   const erros: string[] = []

   if (!fullname) return erros.push('Please, add your full name!')
   else if (fullname.lenth > 25) erros.push('Full name must be less than 25 characters!')

   if (!username) return erros.push('Please, add your user name!')
   else {
      if (username.length > 25) erros.push('User name must be less than 25 characters!')
      else {
         const user_name = await Users.findOne({ username: username })
         if (user_name) erros.push('This user name alredy exists!')
      }
   }


   if (!password) return erros.push('Please, add your password!')
   else if (password.length < 6) erros.push('Password must be at least 6 characters!')

   if (!email) return erros.push('Please, add your email!')
   else {
      if (validateEmail(email)) {
         const email_user = await Users.findOne({ email: email })
         if (email_user) erros.push('This email alredy exists')
      }
   }

   if (erros.length > 0) return res.status(400).json({ msg: erros })
   next()
}



export const validateEmail = (email: string) => {
   return String(email)
      .toLowerCase()
      .match(
         /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      );
};

export const isVietnamesePhoneNumber = (number: string) => {
   return /(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})\b/.test(number);
}