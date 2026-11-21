import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/storage/token_storage.dart';
import '../../auth/presentation/login_screen.dart';
import '../cubit/food_cubit.dart';
import '../cubit/food_state.dart';
import 'all_foods_screen.dart';
import 'food_detail_screen.dart';
import 'widgets/category_selector.dart';
import 'widgets/food_item_card.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/main_bottom_nav_bar.dart';
import 'widgets/promo_banner_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FoodCubit()..fetchHomeData(),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  int _currentBottomNavIndex = 0;

  String _getSectionTitle(String categoryId) {
    switch (categoryId) {
      case 'rice':
        return 'Món ngon Cơm trưa';
      case 'noodle':
        return 'Hương vị Bún & Phở';
      case 'drink':
        return 'Đồ uống & Trà sữa';
      case 'fastfood':
        return 'Món ăn vặt giòn ngon';
      default:
        return 'Món ngon đề xuất';
    }
  }

  String _getSectionSubtitle(String categoryId) {
    switch (categoryId) {
      case 'rice':
        return 'Cơm nóng sốt, chuẩn vị nhà làm';
      case 'noodle':
        return 'Nước dùng hầm xương đậm đà, nóng hổi';
      case 'drink':
        return 'Giải khát mát lạnh sảng khoái';
      case 'fastfood':
        return 'Giao nhanh, nóng giòn tiện lợi';
      default:
        return 'Lựa chọn hàng đầu gần bạn';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryRust,
          onRefresh: () => context.read<FoodCubit>().fetchHomeData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Logo, Địa chỉ, Giỏ hàng)
                HomeHeader(
                  address: '123 Nguyễn Huệ, Q.1',
                  cartCount: 3,
                  onNotificationTap: () {},
                  onProfileTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        title: const Text(
                          'Tài khoản',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Hủy', style: TextStyle(color: AppColors.textSub)),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await TokenStorage.removeToken();
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  (route) => false,
                                );
                              }
                            },
                            child: const Text(
                              'Đăng xuất',
                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onAddressTap: () {},
                  onCartTap: () {},
                ),
                const SizedBox(height: 16),

                // 2. Ô tìm kiếm (bấm vào mở trang AllFoodsScreen)
                HomeSearchBar(
                  onChanged: (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AllFoodsScreen()),
                    );
                  },
                  onFilterTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AllFoodsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // 3. Banner Khuyến mãi
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
                const SizedBox(height: 18),

                // 4. BlocBuilder hiển thị Danh mục & Món ăn từ Backend
                BlocBuilder<FoodCubit, FoodState>(
                  builder: (context, state) {
                    if (state is FoodLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(color: AppColors.primaryRust),
                        ),
                      );
                    }

                    if (state is FoodError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            children: [
                              const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.textSub),
                              const SizedBox(height: 8),
                              Text(state.message, style: const TextStyle(color: AppColors.textSub)),
                              TextButton(
                                onPressed: () => context.read<FoodCubit>().fetchHomeData(),
                                child: const Text('Thử lại', style: TextStyle(color: AppColors.primaryRust)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is FoodLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thanh chọn Danh mục lướt ngang
                          CategorySelector(
                            categories: state.categories,
                            selectedCategoryId: state.selectedCategoryId,
                            onCategorySelected: (id) {
                              context.read<FoodCubit>().selectCategory(id);
                            },
                          ),
                          const SizedBox(height: 18),

                          // Tiêu đề Section (đổi động theo danh mục)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getSectionTitle(state.selectedCategoryId),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textMain,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getSectionSubtitle(state.selectedCategoryId),
                                    style: const TextStyle(fontSize: 12.5, color: AppColors.textSub),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AllFoodsScreen(
                                        initialCategoryId: state.selectedCategoryId,
                                        title: _getSectionTitle(state.selectedCategoryId),
                                      ),
                                    ),
                                  );
                                },
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

                          // Danh sách món ăn
                          if (state.foods.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                children: const [
                                  Icon(Icons.fastfood_outlined, size: 48, color: AppColors.textSub),
                                  SizedBox(height: 12),
                                  Text(
                                    'Chưa có món ăn trong danh mục này',
                                    style: TextStyle(color: AppColors.textSub, fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...state.foods.map(
                              (food) => FoodItemCard(
                                food: food,
                                onAddToCart: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Đã thêm "${food.name.replaceAll('\n', ' ')}" vào giỏ hàng!'),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: AppColors.primaryRust,
                                    ),
                                  );
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FoodDetailScreen(food: food),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),

      // 5. Thanh điều hướng dưới cùng
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
        },
      ),
    );
  }
}
