import Users from '../models/userModel'
import { Request } from 'express'
import { StringExpression } from 'mongoose'
export interface IUser {
   _id?: string
   fullname: string
   username: string
   email: string
   password: string
   avatar: string
   role: string
   gender: string
   mobile: string,
   address: string,
   story: string,
   website: string,
   followers: string[],
   following: string[],
   saved: string[]
   _doc: Document
}


export interface IDecodedType {
   id: string
   iat: number
   exp: number
}

export interface IReqAuthType extends Request {
   user?: IUser
}


export interface IPost {
   _id: string
   content: string
   images: string[]
   likes: string[]
   comments: string[]
   user: IUser
   _doc?: Document
}

export interface IComment {
   _id: string
   content: string
   tag: Object
   reply: string[]
   likes: string[]
   _doc?: Document
}

export interface IReel {
   _id: string
   content: string
   videoUrl: string
   backgroundUrl: string
   likes: string[]
   comments: string[]
   user: IUser
   _doc?: Document
}

export interface IStory {
   _id: string
   user: IUser
   media: {
      media: string
      duration: number
   }
   likes: string[]
   _doc?: Document
}

export interface Variants {
   title: string
   options: string[]
}

export interface IProduct {
   _id: string
   user: string
   medias: string[]
   rates: {
      star: number
      comment: string
   }
   title: string
   price: number
   description: string
   numberOfStock: number
   numberOfSold: number
   variants: Variants[]
   category: string
   averageRating: number
   createdAt: string
   updatedAt: string
   _doc?: Document
}

export interface UserCart {
   _id: string
   user: string
   cart: {
      product: IProduct
      quantity: number
   }[]
   createdAt: string
   updatedAt: string
}   