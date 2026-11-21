const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../../.env') });
const mongoose = require('mongoose');
const Category = require('../models/Category');
const Food = require('../models/Food');

const MONGO_URI = process.env.MONGO_URI;

const categoriesData = [
  { name: 'Cơm trưa', icon: '🍲', slug: 'rice', order: 1, isActive: true },
  { name: 'Bún & Phở', icon: '🍜', slug: 'noodle', order: 2, isActive: true },
  { name: 'Ăn vặt', icon: '🍟', slug: 'fastfood', order: 3, isActive: true },
  { name: 'Đồ uống', icon: '🥤', slug: 'drink', order: 4, isActive: true },
];

async function seedData() {
  try {
    if (!MONGO_URI) {
      console.error('❌ Chưa cấu hình MONGO_URI trong file .env');
      process.exit(1);
    }

    console.log('⏳ Đang kết nối MongoDB...');
    await mongoose.connect(MONGO_URI);
    console.log('✅ Kết nối MongoDB thành công!');

    // 1. Dọn sạch dữ liệu cũ
    console.log('🧹 Đang làm sạch dữ liệu cũ...');
    await Category.deleteMany({});
    await Food.deleteMany({});

    // 2. Thêm Danh mục
    console.log('📁 Đang tạo danh mục...');
    const createdCategories = await Category.insertMany(categoriesData);
    console.log(`✅ Đã tạo ${createdCategories.length} danh mục!`);

    const catMap = {};
    createdCategories.forEach((c) => {
      catMap[c.slug] = c._id;
    });

    // 3. Thêm Món ăn chuẩn khớp giao diện
    console.log('🍔 Đang tạo món ăn...');
    const foodsData = [
      {
        name: 'Cơm Tấm Sườn Bì Chả Đặc Biệt',
        price: 55000,
        image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
        description: 'Hạt cơm tấm thơm dẻo, sườn nướng mật ong thảo mộc xém cạnh đậm vị, bì thính rang tay giòn ngậy, chả trứng chưng truyền thống và mỡ hành béo bùi.',
        rating: 4.9,
        ratingCount: '1.2k',
        deliveryTime: '15–20 phút',
        category: catMap['rice'],
        isAvailable: true,
        size: [
          { name: 'Tiêu chuẩn (Vừa)', description: '1 miếng sườn, bì, chả chưng tiêu chuẩn', price: 0 },
          { name: 'Phần Lớn (Nhiều cơm & sườn)', description: 'Gấp đôi sườn nướng & cơm thơm giòn', price: 15000 },
        ],
        topings: [
          { name: 'Trứng ốp la lòng đào', description: 'Trứng gà ta chiên rìa giòn tan', price: 10000 },
          { name: 'Chả cua hoàng kim', description: 'Thịt cua biển tươi quyện nấm mèo', price: 15000 },
          { name: 'Canh rong biển thịt bằm', description: 'Nước dùng hầm xương ngọt thanh mát', price: 12000 },
        ],
      },
      {
        name: 'Cơm Gà Xối Mỡ Da Giòn',
        price: 48000,
        image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600',
        description: 'Cơm chiên hạt vàng ươm, đùi gà góc tư xối mỡ lớp da giòn rụm bên trong mọng nước, ăn kèm dưa leo và nước mắm tỏi ớt chua ngọt.',
        rating: 4.8,
        ratingCount: '950',
        deliveryTime: '20–25 phút',
        category: catMap['rice'],
        isAvailable: true,
        size: [
          { name: 'Đùi gà xối mỡ vừa', price: 0 },
          { name: 'Góc tư đùi lớn đặc biệt', price: 15000 },
        ],
        topings: [
          { name: 'Trứng ốp la', price: 8000 },
          { name: 'Thêm chén cơm chiên', price: 10000 },
        ],
      },
      {
        name: 'Phở Bò Tái Nạm Hoa Hồi',
        price: 65000,
        image: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=600',
        description: 'Nước dùng hầm từ xương ống bò 12 tiếng thơm hương thảo quả, quế và hoa hồi. Thịt bò tái mềm ngọt kèm nạm giòn sần sật.',
        rating: 4.8,
        ratingCount: '850',
        deliveryTime: '20–25 ph',
        category: catMap['noodle'],
        isAvailable: true,
        size: [
          { name: 'Tô vừa', price: 0 },
          { name: 'Tô đặc biệt (thêm bắp bò)', price: 20000 },
        ],
        topings: [
          { name: 'Quẩy giòn nóng hổi (2 cái)', price: 5000 },
          { name: 'Trứng gà ta chần lòng đào', price: 8000 },
          { name: 'Tiết bò hầm', price: 10000 },
        ],
      },
      {
        name: 'Bún Bò Huế Chả Cua Đậm Vị',
        price: 60000,
        image: 'https://images.unsplash.com/photo-1594041680534-e8c8cdebd659?w=600',
        description: 'Sợi bún to tròn mềm mại quyện nước dùng cay nồng mùi sả và mắm ruốc Huế. Topping ngập tràn: nạm bò, chả cua quết, tiết và móng giò.',
        rating: 4.9,
        ratingCount: '1.5k',
        deliveryTime: '15–20 ph',
        category: catMap['noodle'],
        isAvailable: true,
        size: [
          { name: 'Tô thường', price: 0 },
          { name: 'Tô đặc biệt đầy đủ', price: 18000 },
        ],
        topings: [
          { name: 'Chả cua thêm', price: 12000 },
          { name: 'Thêm bắp bò hoa', price: 15000 },
        ],
      },
      {
        name: 'Bánh Mì Heo Quay Giòn Rụm',
        price: 35000,
        image: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=600',
        description: 'Vỏ bánh mì nóng giòn tan, nhân thịt ba chỉ heo quay da nổ giòn rụm kết hợp pate gan béo ngậy, sốt tương đậm đà và đồ chua thanh mát.',
        rating: 4.9,
        ratingCount: '2.1k',
        deliveryTime: '10–15 ph',
        category: catMap['fastfood'],
        isAvailable: true,
        size: [{ name: 'Ổ tiêu chuẩn', price: 0 }],
        topings: [
          { name: 'Thêm thịt heo quay', price: 10000 },
          { name: 'Thêm pate gan béo', price: 5000 },
          { name: 'Thêm chả lụa', price: 7000 },
        ],
      },
      {
        name: 'Khoai Tây Chiên Lắc Phô Mai',
        price: 30000,
        image: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=600',
        description: 'Khoai tây cọng giòn rụm màu vàng óng, lắc đều cùng bột phô mai truyền thống thơm lừng, béo ngậy và đậm đà.',
        rating: 4.7,
        ratingCount: '620',
        deliveryTime: '10–15 ph',
        category: catMap['fastfood'],
        isAvailable: true,
        size: [
          { name: 'Phần vừa (150g)', price: 0 },
          { name: 'Phần lớn (250g)', price: 15000 },
        ],
        topings: [{ name: 'Thêm sốt tương cà & mayonnaise', price: 3000 }],
      },
      {
        name: 'Trà Sữa Ô Long Nướng Trân Châu',
        price: 45000,
        image: 'https://images.unsplash.com/photo-1558857563-b37cf528c1d5?w=600',
        description: 'Trà ô long thượng hạng ủ dậy mùi khói nướng quyện cùng sữa tươi béo thơm, kết hợp trân châu đường đen dẻo dai ngọt dịu.',
        rating: 4.9,
        ratingCount: '3.4k',
        deliveryTime: '15–20 ph',
        category: catMap['drink'],
        isAvailable: true,
        size: [
          { name: 'Size M (500ml)', price: 0 },
          { name: 'Size L (700ml)', price: 8000 },
        ],
        topings: [
          { name: 'Trân châu đen hoàng kim', price: 7000 },
          { name: 'Kem cheese béo mặn', price: 10000 },
          { name: 'Pudding trứng', price: 8000 },
        ],
      },
      {
        name: 'Trà Đào Cam Sả Tươi Mát',
        price: 42000,
        image: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600',
        description: 'Hương vị đào thanh ngọt kết hợp vị chua dịu của cam tươi và mùi thơm thư thái của sả tươi đập dập. Giải khát cực sảng khoái.',
        rating: 4.8,
        ratingCount: '1.8k',
        deliveryTime: '15–20 ph',
        category: catMap['drink'],
        isAvailable: true,
        size: [
          { name: 'Size M', price: 0 },
          { name: 'Size L', price: 7000 },
        ],
        topings: [
          { name: 'Thêm 2 miếng đào giòn', price: 10000 },
          { name: 'Thạch nha đam', price: 6000 },
        ],
      },
    ];

    const createdFoods = await Food.insertMany(foodsData);
    console.log(`✅ Đã tạo thành công ${createdFoods.length} món ăn mẫu!`);
    console.log('🎉 Hoàn tất quá trình Seed dữ liệu!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Lỗi khi seed dữ liệu:', error);
    process.exit(1);
  }
}

seedData();
