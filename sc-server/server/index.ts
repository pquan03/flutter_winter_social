import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import cookieParser from 'cookie-parser';
import morgan from 'morgan';
import routes from './routes/index';
import { Socket, Server } from 'socket.io';
import { createServer } from 'http';
import SocketServer from './config/socketServer';
import { ExpressPeerServer } from 'peer';

dotenv.config();
const app = express();

app.use(cors({
      origin: `${process.env.BASE_URL}`,
      credentials: true
}));
app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));


// SOCKET
const http = createServer(app);
const io = new Server(http, {
      cors: {
            origin: `${process.env.BASE_URL}`,
            credentials: true
      }
});

io.on('connection', (socket: Socket) => {
      console.log({
            id: socket.id,
            message: 'User connected'
      })
      SocketServer(socket);
})


// Create peer server
ExpressPeerServer(http, { path: '/' })

// ROUTES
app.use('/api', routes.authRoute)
app.use('/api', routes.userRoute)
app.use('/api', routes.postRoute)
app.use('/api', routes.reelRoute)
app.use('/api', routes.commentRoute)
app.use('/api', routes.notifyRoute)
app.use('/api', routes.messageRoute)
app.use('/api', routes.storyRoute)

// Connect to MongoDB
import './config/database';


const PORT = process.env.PORT || 5000;
http.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
})