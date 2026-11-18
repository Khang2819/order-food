require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const authRoutes = require('./src/routes/authRoutes');

const app = express();
const PORT = process.env.PORT || 3000;
const MONGO_URI = process.env.MONGO_URI;

app.use(cors());
app.use(express.json());

mongoose
  .connect(MONGO_URI)
  .then(() => console.log('Đã kết nối thành công với MongoDB'))
  .catch((e) => console.error('Lỗi kết nối với MongoDB:', e.message));

app.use('/api/auth', authRoutes);

app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Server Order Food đang hoạt động tốt!' });
});

app.listen(PORT, () => {
  console.log(`Server Express đang chạy tại: http://localhost:${PORT}`);
});
