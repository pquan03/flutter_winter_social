# Social App

SocialApp is a social networking application built with Flutter on the client side and Node.js, Express.js, and MongoDB on the server side. TypeScript is used throughout the project to enhance code quality and maintainability. Real-time communication is facilitated by Socket.IO.


## Technologies Used

| **Client Side**                                 | **Server Side**                                 |
|--------------------------------------------------|-------------------------------------------------|
| [Flutter](https://docs.flutter.dev/)             | [Node.js](https://nodejs.org/)                  |
| [Bloc](https://bloclibrary.dev/#/)         | [Express.js](https://expressjs.com/)            |
| [Provider](https://pub.dev/packages/provider)                   | [MongoDB](https://www.mongodb.com/)             |
|  [Socket.IO](https://socket.io/)    | [TypeScript](https://www.typescriptlang.org/)  |
|                  | [Socket.IO](https://socket.io/)                 |

## Features

* Custom photo feed
* Post photo posts from camera or gallery
    * Like posts
    * Comment on posts
        * View all comments on a post
* Search for users
* Realtime Messaging and Sending images
* Deleting Posts
* Profile Pages
    * Change profile picture
    * Change username
    * Follow / Unfollow Users
    * Change image view from grid layout to feed layout
    * Add your own bio
* Notifications Feed showing recent likes / comments of your posts + new followers
* Swipe to delete notification
* Dark Mode Support
* Stories/Status
* Used Provider to manage state


#  Screens

| Screen          | Description                                                                         | Screenshot                                     |
|-----------------|-------------------------------------------------------------------------------------|------------------------------------------------|
| Welcome         | Provides a warm introduction to new users, inviting them to explore the app or log in. | [![Welcome](assets/welcome.png)](https://www.youtube.com/watch?v=kNGpZPVZufk)                |
| Login           | Allows users to securely log into their accounts, providing a smooth authentication process. | [![Login](assets/login.png)](https://www.youtube.com/watch?v=kNGpZPVZufk)} |
| Signup          | Enables new users to create accounts and join the SocialApp community.                 | [![Signup](assets/signup.png)](https://www.youtube.com/watch?v=kNGpZPVZufk)                  |
| Home            | Scroll through a personalized feed of posts from friends and accounts followed.             | [![Post](assets/home.png)](https://www.youtube.com/watch?v=vqdm-3hcmjA)                     |
| Comment         | Allows users to view and add comments to a specific post, fostering engagement and interaction. | [![Comment](assets/comment.png)](https://www.youtube.com/watch?v=vqdm-3hcmjA)            |
| Message         | Allows users to view and chat realtime by texts, images, symbols | [![Message](assets/message.png)](https://www.youtube.com/watch?v=R4BMpNprKEc)             |
| Discovery       | Combines both "Explore" and "Search User," allowing users to discover new content and find/connect with other users. | [![Discovery](assets/discovery.png)](https://www.youtube.com/watch?v=R4BMpNprKEc) [![SeachUser](assets/searchuser.png)](https://www.youtube.com/watch?v=R4BMpNprKEc)    |
| Upload Image    | Enables users to select and upload images when creating a new post.                    | [![Upload Image](assets/uploadimage1.png)](https://www.youtube.com/watch?v=m_yOBMjIOHU)     |
| Write Content   | Lets users add captions and text content when creating a new post.                     | [![Write Content](assets/addtext.png)](https://www.youtube.com/watch?v=m_yOBMjIOHU)   |
| Notification    | Keeps users informed about likes, comments, and new followers, enhancing the social experience. | [![Notification](assets/notify.png)](https://www.youtube.com/watch?v=n2GBkVdcfpM) |
| Profile         | Showcases the user's profile, including posts, followers, and customization options.  | [![Profile](assets/profile.png)](https://www.youtube.com/watch?v=rzPcdsa99WE)                |



