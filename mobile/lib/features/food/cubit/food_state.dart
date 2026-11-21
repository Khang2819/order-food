import '../models/category_model.dart';
import '../models/food_model.dart';

abstract class FoodState {}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<CategoryModel> categories;
  final List<FoodModel> foods;
  final String selectedCategoryId;

  FoodLoaded({
    required this.categories,
    required this.foods,
    this.selectedCategoryId = 'all',
  });

  FoodLoaded copyWith({
    List<CategoryModel>? categories,
    List<FoodModel>? foods,
    String? selectedCategoryId,
  }) {
    return FoodLoaded(
      categories: categories ?? this.categories,
      foods: foods ?? this.foods,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class FoodError extends FoodState {
  final String message;
  FoodError(this.message);
}
