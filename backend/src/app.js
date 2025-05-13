const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const cors = require('cors');
const bookingsRouter = require('./routes/bookings');
const authMiddleware = require('./middleware/auth');
const db = require('./utils/db');

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

db.connect();

app.use('/bookings', bookingsRouter);

app.use((err, req, res, next) => {
  res.status(err.status || 500).json({ error: err.message || 'Internal Server Error' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});