import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';
import 'widgets/category_selector.dart';
import 'widgets/food_item_card.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/main_bottom_nav_bar.dart';
import 'widgets/promo_banner_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;
  String _selectedCategoryId = 'all';

  // Danh mục mẫu
  final List<CategoryModel> _categories = const [
    CategoryModel(id: 'all', name: 'Tất cả', icon: '🍽'),
    CategoryModel(id: 'rice', name: 'Cơm trưa', icon: '🍲'),
    CategoryModel(id: 'noodle', name: 'Bún & Phở', icon: '🍜'),
    CategoryModel(id: 'drink', name: 'Đồ uống', icon: '🥤'),
    CategoryModel(id: 'fastfood', name: 'Ăn vặt', icon: '🍟'),
  ];

  // Danh sách món ăn mẫu khớp 100% hình ảnh
  final List<FoodModel> _foods = const [
    FoodModel(
      id: '1',
      name: 'Cơm Tấm Sườn Bì Chả Đặc Biệt',
      restaurantName: 'Cơm Tấm Ba Ghiền',
      price: 55000,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
      rating: 4.9,
      deliveryTime: '15–20 ph',
      soldCount: '1.2k+ đã mua',
      categoryId: 'rice',
    ),
    FoodModel(
      id: '2',
      name: 'Phở Bò Tái Nạm Hoa Hồi',
      restaurantName: 'Phở Thìn Lò Đúc',
      price: 65000,
      imageUrl: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=400',
      rating: 4.8,
      deliveryTime: '20–25 ph',
      soldCount: '850 đã mua',
      categoryId: 'noodle',
    ),
    FoodModel(
      id: '3',
      name: 'Bánh Mì Heo Quay Giòn Rụm',
      restaurantName: 'Bánh Mì Huỳnh Hoa',
      price: 35000,
      imageUrl: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400',
      rating: 4.9,
      deliveryTime: '10–15 ph',
      soldCount: '2.1k+ đã mua',
      categoryId: 'fastfood',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Logo, KhamPha, Địa chỉ, Giỏ hàng)
              HomeHeader(
                address: '123 Nguyễn Huệ, Q.1',
                cartCount: 3,
                onNotificationTap: () {},
                onProfileTap: () {},
                onAddressTap: () {},
                onCartTap: () {},
              ),
              const SizedBox(height: 16),

              // 2. Ô tìm kiếm
              HomeSearchBar(
                onChanged: (value) {},
                onFilterTap: () {},
              ),
              const SizedBox(height: 16),

              // 3. Thanh chọn Danh mục lướt ngang
              CategorySelector(
                categories: _categories,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: (id) {
                  setState(() => _selectedCategoryId = id);
                },
              ),
              const SizedBox(height: 18),

              // 4. Banner Khuyến mãi "Giảm 30% Đơn Trưa"
              PromoBannerCard(
                onUseNowTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã áp dụng mã TRUANGON30 thành công!'),
                      backgroundColor: AppColors.primaryRust,
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),

              // 5. Tiêu đề section: "Món ngon đề xuất"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Món ngon đề xuất',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textMain,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Lựa chọn hàng đầu gần bạn',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSub,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Xem thêm',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryRust,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: AppColors.primaryRust,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 6. Danh sách các món ăn đề xuất
              ..._foods.map(
                (food) => FoodItemCard(
                  food: food,
                  onAddToCart: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm "${food.name}" vào giỏ hàng!'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: AppColors.primaryRust,
                      ),
                    );
                  },
                  onTap: () {
                    // Xem chi tiết món ăn
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      // 7. Thanh điều hướng dưới cùng (Bottom Navigation Bar 4 tabs)
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
        },
      ),
    );
  }
}
