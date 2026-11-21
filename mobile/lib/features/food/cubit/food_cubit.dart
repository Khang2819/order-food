import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/food_repository.dart';
import '../models/category_model.dart';
import 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  final FoodRepository _repository;

  FoodCubit({FoodRepository? repository})
      : _repository = repository ?? FoodRepository(),
        super(FoodInitial());

  // Tải dữ liệu ban đầu cho Trang chủ (Cả danh mục và danh sách món ăn)
  Future<void> fetchHomeData() async {
    emit(FoodLoading());
    try {
      final results = await Future.wait([
        _repository.getCategories(),
        _repository.getFoods(),
      ]);

      final categories = results[0] as List<CategoryModel>;
      final foods = results[1] as List<dynamic>;

      // Đưa thêm lựa chọn 'Tất cả' lên đầu danh sách danh mục
      final fullCategories = [
        const CategoryModel(id: 'all', name: 'Tất cả', icon: '🍽'),
        ...categories,
      ];

      emit(FoodLoaded(
        categories: fullCategories,
        foods: foods.cast(),
        selectedCategoryId: 'all',
      ));
    } catch (e) {
      emit(FoodError('Không thể tải dữ liệu món ăn: $e'));
    }
  }

  // Lọc món theo danh mục được bấm chọn
  Future<void> selectCategory(String categoryId) async {
    if (state is FoodLoaded) {
      final currentState = state as FoodLoaded;
      emit(FoodLoading());
      try {
        final foods = await _repository.getFoods(category: categoryId);
        emit(currentState.copyWith(
          selectedCategoryId: categoryId,
          foods: foods,
        ));
      } catch (e) {
        emit(FoodError('Lỗi khi lọc món ăn: $e'));
      }
    }
  }
}
