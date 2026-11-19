import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/food_model.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodModel? food;

  const FoodDetailScreen({super.key, this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late FoodModel _food;
  int _quantity = 1;
  late String _selectedSizeId;
  final Set<String> _selectedToppingIds = {'top1'};
  final TextEditingController _noteController = TextEditingController();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Dữ liệu mặc định khớp 100% hình ảnh nếu không truyền food từ ngoài vào
    _food = widget.food ??
        const FoodModel(
          id: '1',
          name: 'Cơm Tấm Sườn Bì Chả\nĐặc Biệt',
          restaurantName: 'Cơm Tấm Ba Ghiền',
          price: 55000,
          imageUrl:
              'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
          description:
              'Hạt cơm tấm thơm dẻo, sườn nướng mật ong thảo mộc xém cạnh đậm vị, bì thính rang tay giòn ngậy, chả trứng chưng truyền thống và mỡ hành béo bùi.',
          tag: 'Món Bán Chạy Nhất Sài Gòn',
          rating: 4.9,
          ratingCount: '1.2k',
          deliveryTime: '15–20 phút',
          calories: '680 kcal',
          secretTip:
              'Sườn ướp nước mắm nhĩ Phú Quốc nướng than hoa thơm lừng.',
          sizes: [
            FoodOption(
              id: 'size1',
              name: 'Tiêu chuẩn (Vừa)',
              description: '1 miếng sườn, bì, chả chưng tiêu chuẩn',
              price: 0,
            ),
            FoodOption(
              id: 'size2',
              name: 'Phần Lớn (Nhiều cơm & sườn)',
              description: 'Gấp đôi sườn nướng & cơm thơm giòn',
              price: 15000,
            ),
          ],
          toppings: [
            FoodOption(
              id: 'top1',
              name: 'Trứng ốp la lòng đào',
              description: 'Trứng gà ta chiên rìa giòn tan',
              price: 10000,
            ),
            FoodOption(
              id: 'top2',
              name: 'Chả cua hoàng kim',
              description: 'Thịt cua biển tươi quyện nấm mèo',
              price: 15000,
            ),
            FoodOption(
              id: 'top3',
              name: 'Canh rong biển thịt bằm',
              description: 'Nước dùng hầm xương ngọt thanh mát',
              price: 12000,
            ),
          ],
        );

    _selectedSizeId = _food.sizes.isNotEmpty ? _food.sizes.first.id : '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // Tính tổng tiền động (Giá gốc + Size + Các Topping chọn) * Số lượng
  double get _totalPrice {
    double total = _food.price;

    // Cộng giá Size
    final selectedSize = _food.sizes.firstWhere(
      (s) => s.id == _selectedSizeId,
      orElse: () => const FoodOption(id: '', name: '', price: 0),
    );
    total += selectedSize.price;

    // Cộng giá các Topping đã chọn
    for (final top in _food.toppings) {
      if (_selectedToppingIds.contains(top.id)) {
        total += top.price;
      }
    }

    return total * _quantity;
  }

  // Format tiền VNĐ
  String _formatCurrency(double amount) {
    final int value = amount.round();
    final String str = value.toString();
    final StringBuffer buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi Tiet Mon An',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primaryRust,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Ảnh món ăn lớn với các nút tương tác
                  _buildHeroImage(),
                  const SizedBox(height: 16),

                  // 2. Tên món ăn & Giá tiền
                  _buildTitleAndPrice(),
                  const SizedBox(height: 10),

                  // 3. Mô tả món ăn
                  Text(
                    _food.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSub,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 4. Các badge thông số (Sao, Thời gian, Calories)
                  _buildMetaPills(),
                  const SizedBox(height: 14),

                  // 5. Thẻ "Bí quyết gia truyền"
                  _buildSecretTipCard(),
                  const SizedBox(height: 22),

                  // 6. Mục "Chọn kích cỡ" (Radio)
                  _buildSectionHeader(
                    title: 'Chọn kích cỡ',
                    badgeText: 'Bắt buộc',
                    isBadgeRequired: true,
                  ),
                  const SizedBox(height: 10),
                  ..._food.sizes.map((size) => _buildSizeItem(size)),
                  const SizedBox(height: 20),

                  // 7. Mục "Topping thêm yêu thích" (Checkbox)
                  _buildSectionHeader(
                    title: 'Topping thêm yêu thích',
                    badgeText: 'Tùy chọn',
                    isBadgeRequired: false,
                  ),
                  const SizedBox(height: 10),
                  ..._food.toppings.map((top) => _buildToppingItem(top)),
                  const SizedBox(height: 20),

                  // 8. Mục "Ghi chú cho quán"
                  _buildNoteSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // 9. Thanh cố định dưới cùng (Số lượng + Nút Thêm vào giỏ)
          _buildBottomAction(),
        ],
      ),
    );
  }

  // 1. Ảnh món ăn với các nút Share, Heart và Tag nổi bật
  Widget _buildHeroImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: double.infinity,
            height: 240,
            color: AppColors.primaryLight,
            child: _food.imageUrl.startsWith('http')
                ? Image.network(
                    _food.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                  )
                : _buildImagePlaceholder(),
          ),
        ),
        // Nút Back tròn
        Positioned(
          top: 12,
          left: 12,
          child: _buildCircleIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ),
        // Nút Share và Favorite
        Positioned(
          top: 12,
          right: 12,
          child: Row(
            children: [
              _buildCircleIconButton(
                icon: Icons.share_outlined,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _buildCircleIconButton(
                icon: _isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: _isFavorite ? Colors.red : AppColors.textMain,
                onTap: () {
                  setState(() => _isFavorite = !_isFavorite);
                },
              ),
            ],
          ),
        ),
        // Tag "Món Bán Chạy Nhất Sài Gòn"
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x20000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  _food.tag,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    Color iconColor = AppColors.textMain,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(235),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.primaryLight,
      child: const Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 60,
          color: AppColors.primaryRust,
        ),
      ),
    );
  }

  // 2. Tên món ăn và Giá tiền
  Widget _buildTitleAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            _food.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textMain,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${_formatCurrency(_food.price)}đ',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryRust,
          ),
        ),
      ],
    );
  }

  // 4. Các badge thông số
  Widget _buildMetaPills() {
    return Row(
      children: [
        _buildPillItem(
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFEA580C),
          label: '${_food.rating} (${_food.ratingCount})',
        ),
        const SizedBox(width: 10),
        _buildPillItem(
          icon: Icons.access_time_rounded,
          iconColor: AppColors.textSub,
          label: _food.deliveryTime,
        ),
        const SizedBox(width: 10),
        _buildPillItem(
          icon: Icons.local_fire_department_rounded,
          iconColor: const Color(0xFFEA580C),
          label: _food.calories,
        ),
      ],
    );
  }

  Widget _buildPillItem({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
          ),
        ],
      ),
    );
  }

  // 5. Thẻ Bí quyết gia truyền
  Widget _buildSecretTipCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE8DC), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.restaurant_menu_rounded,
                size: 18,
                color: AppColors.primaryRust,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bí quyết gia truyền',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _food.secretTip,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSub,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header cho từng section
  Widget _buildSectionHeader({
    required String title,
    required String badgeText,
    required bool isBadgeRequired,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.primaryRust,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
          ],
        ),
        if (isBadgeRequired)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFECE5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badgeText,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryRust,
              ),
            ),
          )
        else
          Text(
            badgeText,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
      ],
    );
  }

  // 6. Item Kích cỡ (Radio)
  Widget _buildSizeItem(FoodOption size) {
    final isSelected = size.id == _selectedSizeId;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedSizeId = size.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryRust : AppColors.border,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primaryRust : AppColors.textHint,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    size.name,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
                  ),
                  if (size.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      size.description,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSub,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              size.price > 0 ? '+${_formatCurrency(size.price)}đ' : '+0đ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primaryRust : AppColors.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 7. Item Topping (Checkbox)
  Widget _buildToppingItem(FoodOption top) {
    final isChecked = _selectedToppingIds.contains(top.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isChecked) {
            _selectedToppingIds.remove(top.id);
          } else {
            _selectedToppingIds.add(top.id);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isChecked ? AppColors.primaryRust : AppColors.border,
            width: isChecked ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.primaryRust : Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isChecked ? AppColors.primaryRust : AppColors.textHint,
                  width: 1.5,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    top.name,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
                  ),
                  if (top.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      top.description,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSub,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              '+${_formatCurrency(top.price)}đ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isChecked ? AppColors.primaryRust : AppColors.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 8. Mục Ghi chú cho quán
  Widget _buildNoteSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.edit_note_rounded,
                    size: 20, color: AppColors.textMain),
                SizedBox(width: 6),
                Text(
                  'Ghi chú cho quán',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMain,
                  ),
                ),
              ],
            ),
            Text(
              '${_noteController.text.length}/120',
              style: const TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1.2),
          ),
          child: TextField(
            controller: _noteController,
            maxLength: 120,
            onChanged: (text) => setState(() {}),
            style: const TextStyle(fontSize: 13, color: AppColors.textMain),
            decoration: const InputDecoration(
              hintText:
                  'Ví dụ: Nhiều mỡ hành, nước mắm để riêng, ít cơm...',
              hintStyle:
                  TextStyle(color: AppColors.textHint, fontSize: 12.5),
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  // 9. Thanh cố định dưới cùng
  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Nút Tăng / Giảm số lượng
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  _buildQuantityBtn(
                    icon: Icons.remove_rounded,
                    onTap: () {
                      if (_quantity > 1) {
                        setState(() => _quantity--);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                  _buildQuantityBtn(
                    icon: Icons.add_rounded,
                    isAdd: true,
                    onTap: () {
                      setState(() => _quantity++);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Nút "Thêm vào giỏ"
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRust,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã thêm $_quantity x ${_food.name.replaceAll('\n', ' ')} vào giỏ (${_formatCurrency(_totalPrice)}đ)!',
                        ),
                        backgroundColor: AppColors.primaryRust,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 19,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Thêm vào giỏ ${_formatCurrency(_totalPrice)}đ',
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityBtn({
    required IconData icon,
    bool isAdd = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isAdd ? AppColors.primaryRust : Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isAdd ? Colors.white : AppColors.textMain,
        ),
      ),
    );
  }
}
