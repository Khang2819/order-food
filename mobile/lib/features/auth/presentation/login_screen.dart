import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../food/presentation/home_screen.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'register_screen.dart';
import 'widgets/auth_gradient_button.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_prompt_and_footer.dart';
import 'widgets/auth_social_section.dart';
import 'widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _accountController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ email và mật khẩu'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Gửi yêu cầu đăng nhập qua Cubit
    context.read<AuthCubit>().login(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) => ModalRoute.of(context)?.isCurrent ?? true,
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else if (state is AuthLoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Xin chào, ${state.user.name}! Đăng nhập thành công.'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header (Logo, Badge, Tiêu đề, Phụ đề)
                    const AuthHeader(
                      title: 'Chào mừng bạn trở lại! 👋',
                      subtitle: 'Đăng nhập để khám phá ẩm thực và nhận ưu đãi hôm nay',
                    ),
                    const SizedBox(height: 32),

                    // Ô nhập Email / SĐT
                    AuthTextField(
                      label: 'Email hoặc Số điện thoại',
                      trailingText: 'Bắt buộc',
                      controller: _accountController,
                      hintText: 'saigon.foodie@gmail.com',
                      prefixIcon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Ô nhập Mật khẩu
                    AuthTextField(
                      label: 'Mật khẩu',
                      trailingText: 'Quên mật khẩu?',
                      onTrailingTap: () {
                        // Xử lý quên mật khẩu
                      },
                      controller: _passwordController,
                      hintText: '••••••••••••',
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggleObscure: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    const SizedBox(height: 28),

                    // Nút Đăng nhập
                    AuthGradientButton(
                      text: 'ĐĂNG NHẬP',
                      isLoading: isLoading,
                      onPressed: _handleLogin,
                    ),
                    const SizedBox(height: 32),

                    // Phân cách mạng xã hội
                    const AuthDivider(text: 'HOẶC ĐĂNG NHẬP NHANH BẰNG'),
                    const SizedBox(height: 24),

                    // Nút Google
                    AuthSocialButton(
                      onTap: () {
                        // Xử lý Google Sign In
                      },
                    ),
                    const SizedBox(height: 28),

                    // Chuyển sang Đăng ký
                    AuthPromptRow(
                      text: 'Chưa có tài khoản? ',
                      actionText: 'Đăng ký ngay',
                      onActionTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Điều khoản dịch vụ
                    const AuthTermsFooter(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
