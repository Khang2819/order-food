import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../data/food_repository.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';
import 'food_detail_screen.dart';
import 'widgets/category_selector.dart';
import 'widgets/food_item_card.dart';

class AllFoodsScreen extends StatefulWidget {
  final String initialCategoryId;
  final String title;

  const AllFoodsScreen({
    super.key,
    this.initialCategoryId = 'all',
    this.title = 'Tất cả món ngon',
  });

  @override
  State<AllFoodsScreen> createState() => _AllFoodsScreenState();
}

class _AllFoodsScreenState extends State<AllFoodsScreen> {
  final FoodRepository _foodRepository = FoodRepository();
  final TextEditingController _searchController = TextEditingController();

  late String _selectedCategoryId;
  String _selectedSortBy = 'popular'; // popular, rating, price_asc, price_desc
  bool _isLoading = true;
  List<FoodModel> _foods = [];
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
    _initData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    setState(() => _isLoading = true);
    try {
      final fetchedCategories = await _foodRepository.getCategories();
      _categories = [
        const CategoryModel(id: 'all', name: 'Tất cả', icon: '🍽'),
        ...fetchedCategories,
      ];
      await _fetchFoods();
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchFoods() async {
    setState(() => _isLoading = true);
    final foods = await _foodRepository.getFoods(
      category: _selectedCategoryId,
      search: _searchController.text,
      sortBy: _selectedSortBy == 'popular' ? null : _selectedSortBy,
    );
    if (mounted) {
      setState(() {
        _foods = foods;
        _isLoading = false;
      });
    }
  }

  String _getCategoryTitle() {
    if (_selectedCategoryId == 'all') return widget.title;
    final cat = _categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => const CategoryModel(id: '', name: 'Món ngon', icon: ''),
    );
    return cat.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textMain,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _getCategoryTitle(),
          style: const TextStyle(
            color: AppColors.textMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textMain,
                  size: 24,
                ),
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryRust,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 1. Ô tìm kiếm món ăn
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _fetchFoods(),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm món ăn, quán quen...',
                hintStyle: const TextStyle(
                  color: AppColors.textSub,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSub,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _fetchFoods();
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 2. Thanh Danh mục (Categories) lướt ngang
          if (_categories.isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 12),
              child: CategorySelector(
                categories: _categories,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: (id) {
                  setState(() => _selectedCategoryId = id);
                  _fetchFoods();
                },
              ),
            ),

          // 3. Thanh bộ lọc sắp xếp (Sorting Chips)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 0.8),
                bottom: BorderSide(color: Colors.grey.shade200, width: 0.8),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('Phổ biến nhất', 'popular'),
                  const SizedBox(width: 8),
                  _buildSortChip('Đánh giá cao ★', 'rating'),
                  const SizedBox(width: 8),
                  _buildSortChip('Giá tăng dần ↑', 'price_asc'),
                  const SizedBox(width: 8),
                  _buildSortChip('Giá giảm dần ↓', 'price_desc'),
                ],
              ),
            ),
          ),

          // 4. Danh sách món ăn
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRust,
                    ),
                  )
                : _foods.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Không tìm thấy món ăn phù hợp',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Hãy thử tìm từ khóa hoặc danh mục khác nhé!',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSub,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.primaryRust,
                        onRefresh: _fetchFoods,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _foods.length,
                          itemBuilder: (context, index) {
                            final food = _foods[index];
                            return FoodItemCard(
                              food: food,
                              onAddToCart: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Đã thêm "${food.name.replaceAll('\n', ' ')}" vào giỏ hàng!',
                                    ),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: AppColors.primaryRust,
                                  ),
                                );
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FoodDetailScreen(food: food),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _selectedSortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedSortBy = value);
        _fetchFoods();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryRust.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryRust : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.primaryRust : AppColors.textMain,
          ),
        ),
      ),
    );
  }
}
