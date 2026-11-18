import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class ApiClient {
  // Link Server Backend chạy online trên Render
  static const String baseUrl = 'https://order-food-backend-6ln7.onrender.com/api';

  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Tự động gắn Token vào Header cho mọi Request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // Xử lý lỗi tập trung (nếu token hết hạn 401 thì xóa token)
          if (error.response?.statusCode == 401) {
            TokenStorage.removeToken();
          }
          return handler.next(error);
        },
      ),
    );
  }
}
