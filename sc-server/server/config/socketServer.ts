import { Socket } from 'socket.io';
let users: any[] = []


const EditData = (data: any[], id: any, call: any) => {
   const newData = data.map(item => (
      item.id === id ?  {...item, call} : item
   ))
   return newData;
}


const SocketServer = (socket: Socket) => {
   // joinUser
   socket.on('joinUser', (user: any) => {
      // get ip address user
      const address = socket.handshake.address;
      console.log('New connection from ' + address + '.');
      console.log('Connected: ' + socket.id);
      if(users.every(item => item.id !== user._id)) {
         users.push({ id: user._id, socketId: socket.id, followers: user.followers })
      }
   })

   // Disconnect
   socket.on('disconnect', () => {
      console.log('Disconnected: ' + socket.id);
      const data = users.find(user => user.socketId === socket.id)
      if(data) {
         const clients = users.filter(ele => (data.followers as any[]).find(item => item._id === ele.id))
         if(clients.length > 0) {
            clients.forEach(client => {
               socket.to(`${client.socketId}`).emit('checkUserOffline', data.id)
            } )
         }
         console.log({ disconnectUser: data});
         if(data.call) {
            const callUser = users.find(user => user.id === data.call)
            if(callUser) {
               users =EditData(users, callUser.id, null)
               socket.to(`${callUser.socketId}`).emit('callerDisconnect')
            }
         }
         
      }
      users = users.filter(user => user.socketId !== socket.id)
   })

   // Like Post
   socket.on('likePost', (data: any) => {
      const newArr = [...data.user.followers, data.user._id]
      const clients = users.filter(item => newArr.includes(item.id))
      if (clients.length > 0) {
         clients.forEach(client => {
            socket.to(`${client.socketId}`).emit('likeToClient', data)
         })
      }
   })
   // Un Like Post
   socket.on('unLikePost', (data: any) => {
      const newArr = [...data.user.followers, data.user._id]
      const clients = users.filter(item => newArr.includes(item.id))
      if (clients.length > 0) {
         clients.forEach(client => {
            socket.to(`${client.socketId}`).emit('unLikeToClient', data)
         })
      }
   })

   // Create Comment
   socket.on('createComment', (data: any) => {
      const newArr = [...data.user.followers, data.user._id]
      const clients = users.filter(item => newArr.includes(item.id))
      if (clients.length > 0) {
         clients.forEach(client => {
            socket.to(`${client.socketId}`).emit('createCommentToClient', data)
         })
      }
   })

   // Create answer Comment
   socket.on('createAnswerComment', (data: any) => {
      const newArr = [...data.user.followers, data.user._id]
      const clients = users.filter(item => newArr.includes(item.id))
      if (clients.length > 0) {
         clients.forEach(client => {
            socket.to(`${client.socketId}`).emit('createAnswerCommentToClient', data)
         })
      }
   })

   // Delete Comment
   socket.on('deleteComment', (data: any) => {
      const newArr = [...data.user.followers, data.user._id]
      const clients = users.filter(item => newArr.includes(item.id))
      if (clients.length > 0) {
         clients.forEach(client => {
            socket.to(`${client.socketId}`).emit('deleteCommentToClient', data)
         })
      }
   })

   // Follow Comment
   socket.on('follow', (data: any) => {
      const user = users.find(user => user.id === data.user?._id)
      user && socket.to(`${user.socketId}`).emit('followToClient', data)
   })



   // UnFollow Comment
   socket.on('unFollow', (data: any) => {
      const user = users.find(user => user.id === data.user?._id)
      user && socket.to(`${user.socketId}`).emit('unFollowToClient', data)
   })


   // Notifycation
   socket.on('createNotify', (data: any) => {
      const client = users.find(item => data.recipients.includes(item.id))
      client && socket.to(`${client.socketId}`).emit('createNotifyToClient', data)
   })

   socket.on('deleteNotify', (data: any) => {
      console.log(data);
      const client = users.find(item => data.recipients.includes(item.id))
      client && socket.to(`${client.socketId}`).emit('deleteNotifyToClient', data)
   })

   // Message
   socket.on('addMessage', (msg: any) => {
      console.log(msg);
      const user = users.find(user => user.id === msg.recipientId)
      user && socket.to(`${user.socketId}`).emit('addMessageToClient', msg)
   })

   socket.on('deleteMessage', (msg: any) => {
      const user = users.find(user => user.id === msg.recipientId)
      user && socket.to(`${user.socketId}`).emit('deleteMessageToClient', msg)
   })

   // Check User Online / Offline
   socket.on('checkUserOnline', (data: any) => {
      const following = users.filter(user => (data.following as any[]).find((item) => item._id === user.id))
      socket.emit('checkUserOnlineToMe', following)

      const clients = users.filter(user => (data.followers as any[]).find((item) => item._id === user.id))
      
      if(clients.length > 0) {
         clients.forEach(client => {
            socket.to(`${client.socketId}`).emit('checkUserOnlineToClient', data._id)
         })
      }
   })


   // Call
   socket.on('callUser', (data: any) => {
      console.log(data);
      // Add status call to person start caller
      const client = users.find(item => item.id === data.recipient); // Check user is online or not
      if(client) {
         users = EditData(users, data.sender, data.recipient);
         if(client.call) {
            users = EditData(users, data.sender, null);
            console.log('UserBusy');
            socket.emit('UserBusy', data)
         } else {
            console.log('CallUserToClient');
            users = EditData(users, data.recipient, data.sender);
            socket.to(`${client.socketId}`).emit('callUserToClient', data)
         }
      }
   })

   socket.on('endCall', (data: any) => {
      console.log(data);
      const client = users.find(item => item.id === data.sender);
      if(client) {
         socket.to(`${client.socketId}`).emit('endCallToClient', data)
         users = EditData(users, client.id, null)

         if(client.call) {
            const clientCall = users.find(item => item.id === client.call);
            clientCall && socket.to(`${clientCall.socketId}`).emit('endCallToClient', data)
            users = EditData(users, clientCall.id, null)
         }
      }
   })
}

export default SocketServer;