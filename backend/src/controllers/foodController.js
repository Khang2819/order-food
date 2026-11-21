const Food = require('../models/Food');
const Category = require('../models/Category');

exports.getAllFood = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const search = req.query.search || '';
    const category = req.query.category || '';
    const sortBy = req.query.sortBy || '';
    const skip = (page - 1) * limit;

    const queryCondition = {
      isAvailable: true,
      name: { $regex: search.trim(), $options: 'i' },
    };

    if (category && category !== 'all') {
      if (category.match(/^[0-9a-fA-F]{24}$/)) {
        queryCondition.category = category;
      } else {
        const foundCategory = await Category.findOne({ slug: category });
        if (foundCategory) {
          queryCondition.category = foundCategory._id;
        }
      }
    }

    // Tùy chọn sắp xếp
    let sortOptions = { createdAt: -1 };
    if (sortBy === 'price_asc') sortOptions = { price: 1 };
    if (sortBy === 'price_desc') sortOptions = { price: -1 };
    if (sortBy === 'rating') sortOptions = { rating: -1 };

    const [foods, totalItems] = await Promise.all([
      Food.find(queryCondition)
        .populate('category', 'name slug icon')
        .sort(sortOptions)
        .skip(skip)
        .limit(limit),
      Food.countDocuments(queryCondition),
    ]);

    const totalPages = Math.ceil(totalItems / limit);

    return res.status(200).json({
      success: true,
      message: 'Lấy danh sách món ăn thành công',
      page: page,
      totalPages: totalPages,
      totalItems: totalItems,
      data: foods,
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: e.message || 'Lỗi server khi lấy danh sách món ăn',
    });
  }
};

// lấy chi tiết món ăn

exports.getFoodById = async (req, res) => {
  try {
    const food = await Food.findById({ _id: req.params.id }).populate(
      'category',
      'name slug icon'
    );
    if (!food) {
      return res
        .status(404)
        .json({ success: false, message: 'Không tìm thấy món ăn' });
    }
    return res.status(200).json({
      success: true,
      message: 'Lấy món ăn thành công',
      data: food,
    });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

exports.createFood = async (req, res) => {
  try {
    const newFood = await Food.create(req.body);
    return res.status(201).json({
      success: true,
      message: 'Thêm món ăn thành công',
      data: newFood,
    });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

// xóa món ăn
exports.deleteFood = async (req, res) => {
  try {
    const deleteFood = await Food.findByIdAndDelete({ _id: req.params.id });
    if (!deleteFood) {
      return res
        .status(404)
        .json({ message: 'Không tìm thấy đồ ăn', success: false });
    }
    res.status(200).json({
      success: true,
      message: 'Xóa món ăn thành công',
      data: deleteFood,
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

exports.updateFood = async (req, res) => {
  try {
    const updateFood = await Food.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!updateFood) {
      return res
        .status(404)
        .json({ message: 'Không tìm thấy món ăn để cập nhật', success: false });
    }
    res.status(200).json({
      success: true,
      message: 'Cập nhập món ăn thành công',
      data: updateFood,
    });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};
