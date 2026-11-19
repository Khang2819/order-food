const mongoose = require('mongoose');

const foodSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, ''],
    },

    price: {
      type: Number,
      required: [true, 'Vui lòng nhập giá món ăn'],
      min: 0,
    },

    image: {
      type: String,
      required: [true, 'Vui lòng cung cấp link ảnh món ăn'],
    },

    description: {
      type: String,
      default: '',
    },

    rating: {
      type: Number,
      default: 4.9,
    },

    ratingCount: {
      type: String,
      default: '1k+',
    },
    deliveryTime: {
      type: String,
      default: '15–20 phút',
    },

    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Category',
      required: true,
    },
    size: [
      {
        name: { type: String, required: true },
        description: { type: String, default: '' },
        price: { type: Number, default: 0 },
      },
    ],
    topings: [
      {
        name: { type: String, required: true },
        description: { type: String, default: '' },
        price: { type: Number, default: 0 },
      },
    ],
    isAvailable: {
      type: Boolean,
      default: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Food', foodSchema);
