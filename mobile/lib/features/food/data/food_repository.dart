import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';

class FoodRepository {
  final ApiClient _apiClient;

  FoodRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // 1. Lấy danh sách danh mục trực tiếp từ API Backend
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.dio.get('/categories');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        return list.map((item) => CategoryModel.fromJson(item)).toList();
      }
    } catch (e) {
      // Bắt lỗi mạng hoặc lỗi server
      rethrow;
    }
    return [];
  }

  // 2. Lấy danh sách món ăn trực tiếp từ API Backend (có lọc danh mục, tìm kiếm, sắp xếp)
  Future<List<FoodModel>> getFoods({
    String? category,
    String? search,
    String? sortBy,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty && category != 'all') {
        queryParams['category'] = category;
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }

      final response = await _apiClient.dio.get(
        '/foods',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        return list.map((item) => FoodModel.fromJson(item)).toList();
      }
    } catch (e) {
      // Bắt lỗi mạng hoặc lỗi server
      rethrow;
    }
    return [];
  }
}
