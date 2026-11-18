import '../models/user_model.dart';

abstract class AuthState {
  const AuthState();
}

// 1. Trạng thái ban đầu
class AuthInitial extends AuthState {
  const AuthInitial();
}

// 2. Trạng thái đang tải (Loading xoay vòng)
class AuthLoading extends AuthState {
  const AuthLoading();
}

// 3. Trạng thái Đăng nhập thành công (đã có Token)
class AuthLoginSuccess extends AuthState {
  final UserModel user;
  final String message;

  const AuthLoginSuccess({
    required this.user,
    required this.message,
  });
}

// 4. Trạng thái Đăng ký tài khoản thành công
class AuthRegisterSuccess extends AuthState {
  final UserModel user;
  final String message;

  const AuthRegisterSuccess({
    required this.user,
    required this.message,
  });
}

// 5. Trạng thái lỗi (báo lỗi ra UI)
class AuthFailure extends AuthState {
  final String errorMessage;

  const AuthFailure(this.errorMessage);
}

// 6. Trạng thái Chưa đăng nhập / Đã đăng xuất
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
