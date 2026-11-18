import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';
import '../models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthInitial());

  // 1. Hàm Đăng nhập
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final result = await _authRepository.login(
        email: email,
        password: password,
      );
      emit(AuthLoginSuccess(
        user: result.user,
        message: 'Đăng nhập thành công!',
      ));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // 2. Hàm Đăng ký
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final response = await _authRepository.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      final user = UserModel.fromJson(response['user'] ?? {});
      emit(AuthRegisterSuccess(
        user: user,
        message: response['message'] ?? 'Đăng ký tài khoản thành công!',
      ));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // 3. Hàm Đăng xuất
  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
