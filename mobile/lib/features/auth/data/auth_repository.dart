import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // 1. Đăng ký tài khoản
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Đăng ký thất bại, vui lòng thử lại';
      throw Exception(message);
    }
  }

  // 2. Đăng nhập
  Future<({UserModel user, String token})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data['token'] as String;
      final user = UserModel.fromJson(response.data['user']);

      // Lưu token vào thiết bị
      await TokenStorage.saveToken(token);

      return (user: user, token: token);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Đăng nhập thất bại, vui lòng thử lại';
      throw Exception(message);
    }
  }

  // 3. Đăng xuất
  Future<void> logout() async {
    await TokenStorage.removeToken();
  }
}
