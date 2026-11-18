import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class ApiClient {
  // LƯU Ý KHI CHẠY THỰC TẾ:
  // - Máy ảo Android (Android Emulator): Dùng http://10.0.2.2:3000/api
  // - Thiết bị thật (Cắm dây USB): Dùng địa chỉ IP Wifi máy tính (ví dụ: http://192.168.1.5:3000/api)
  // - Web / iOS Simulator: Dùng http://localhost:3000/api
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
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
