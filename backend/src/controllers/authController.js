const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

//đăng kí

exports.register = async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;

    if (!name || !email || !password || !phone) {
      return res
        .status(400)
        .json({ message: 'Vui lòng điền đầy đủ tất cả các trường' });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'Email này đã được sử dùng rồi' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({
      name,
      email,
      password: hashedPassword,
      phone,
    });
    await newUser.save();
    res.status(201).json({
      message: 'Bạn đã đăng kí tài khoản thành công',
      user: {
        id: newUser._id,
        name: newUser.name,
        email: newUser.email,
        phone: newUser.phone,
        role: newUser.role,
      },
    });
  } catch (e) {
    res.status(500).json({ message: 'Lỗi server: ' + e.message });
  }
};

//đăng nhập

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res
        .status(400)
        .json({ message: 'Vui lòng nhập đầy đủ tài khoản và mật khẩu' });
    }

    const account = email.trim();
    const user = await User.findOne({
      $or: [{ email: account.toLowerCase() }, { phone: account }],
    });
    if (!user) {
      return res.status(400).json({ message: 'Sai tài khoản hoặc mật khẩu' });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Sai tài khoản hoặc mật khẩu' });
    }
    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '3d' }
    );
    res.json({
      message: 'Đăng nhập thành công!',
      token: token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
      },
    });
  } catch (e) {
    res.status(500).json({ message: 'Lỗi server: ' + e.message });
  }
};
