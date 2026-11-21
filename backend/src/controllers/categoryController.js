const Category = require('../models/Category');

exports.getAllCategories = async (req, res) => {
  try {
    const categories = await Category.find({ isActive: true }).sort({
      order: 1,
      createdAt: 1,
    });
    return res.status(200).json({
      success: true,
      message: 'Lấy danh sách thư mục thành công',
      total: categories.length,
      data: categories,
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: e.message || 'Lỗi server khi lấy danh mục',
    });
  }
};

exports.getCategoryById = async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    if (!category) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy danh mục này',
      });
    }
    return res.status(200).json({
      success: true,
      message: 'Lấy chi tiết danh mục thành công',
      data: category,
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: e.message || 'Lỗi server khi lấy chi tiết danh mục',
    });
  }
};

exports.createCategory = async (req, res) => {
  try {
    const { name, icon, slug, order, isActive } = req.body;
    const categorySlug = slug
      ? slug.toLowerCase().trim()
      : name
          .toLowerCase()
          .normalize('NFD')
          .replace(/[\u0300-\u036f]/g, '')
          .replace(/[^a-z0-9]/g, '-')
          .replace(/-+/g, '-');
    const newCategory = await Category.create({
      name,
      icon,
      slug: categorySlug,
      order: order || 0,
      isActive: isActive !== undefined ? isActive : true,
    });
    return res.status(201).json({
      success: true,
      message: 'Thêm danh mục thành công',
      data: newCategory,
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: e.message || 'Lỗi server khi tạo danh mục',
    });
  }
};

exports.updateCategory = async (req, res) => {
  try {
    const updatedCategory = await Category.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    if (!updatedCategory) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy danh mục để cập nhật',
      });
    }
    return res.status(200).json({
      success: true,
      message: 'Cập nhật danh mục thành công',
      data: updatedCategory,
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: e.message || 'Lỗi server khi cập nhật danh mục',
    });
  }
};

exports.deleteCategory = async (req, res) => {
  try {
    const deletedCategory = await Category.findByIdAndDelete(req.params.id);
    if (!deletedCategory) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy danh mục để xóa',
      });
    }
    return res.status(200).json({
      success: true,
      message: 'Xóa danh mục thành công',
      data: deletedCategory,
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: e.message || 'Lỗi server khi xóa danh mục',
    });
  }
};
