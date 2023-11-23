import mongoose, { ConnectOptions } from 'mongoose';
mongoose.set('strictQuery', false);
const URI = process.env.MONGODB_URI;
mongoose.connect(`${URI}`, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
} as ConnectOptions, (err: any) => {
    if (err) throw err;
    console.log('Connected to MongoDB');
})




