import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'widgets/auth_gradient_button.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_prompt_and_footer.dart';
import 'widgets/auth_social_section.dart';
import 'widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ tất cả các trường'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu phải có ít nhất 6 ký tự'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không trùng khớp'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Gửi yêu cầu đăng ký qua Cubit
    context.read<AuthCubit>().register(
          name: name,
          email: email,
          phone: phone,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textMain, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
            } else if (state is AuthRegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context); // Quay về màn hình login sau khi đăng ký thành công
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header (Logo, Badge, Tiêu đề, Phụ đề)
                    const AuthHeader(
                      title: 'Tạo tài khoản mới! 🎉',
                      subtitle: 'Đăng ký thành viên để nhận voucher ưu đãi cho đơn hàng đầu tiên',
                    ),
                    const SizedBox(height: 28),

                    // Họ và tên
                    AuthTextField(
                      label: 'Họ và tên',
                      trailingText: 'Bắt buộc',
                      controller: _nameController,
                      hintText: 'Nguyễn Văn Khang',
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    AuthTextField(
                      label: 'Email',
                      trailingText: 'Bắt buộc',
                      controller: _emailController,
                      hintText: 'khang.foodie@gmail.com',
                      prefixIcon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Số điện thoại
                    AuthTextField(
                      label: 'Số điện thoại',
                      trailingText: 'Bắt buộc',
                      controller: _phoneController,
                      hintText: '0901 234 567',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // Mật khẩu
                    AuthTextField(
                      label: 'Mật khẩu',
                      trailingText: 'Ít nhất 6 ký tự',
                      controller: _passwordController,
                      hintText: '••••••••••••',
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggleObscure: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Xác nhận mật khẩu
                    AuthTextField(
                      label: 'Xác nhận mật khẩu',
                      trailingText: 'Bắt buộc',
                      controller: _confirmPasswordController,
                      hintText: '••••••••••••',
                      prefixIcon: Icons.lock_reset_rounded,
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      onToggleObscure: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                    const SizedBox(height: 26),

                    // Nút Đăng ký
                    AuthGradientButton(
                      text: 'ĐĂNG KÝ NGAY',
                      isLoading: isLoading,
                      onPressed: _handleRegister,
                    ),
                    const SizedBox(height: 28),

                    // Phân cách mạng xã hội
                    const AuthDivider(text: 'HOẶC ĐĂNG KÝ NHANH BẰNG'),
                    const SizedBox(height: 22),

                    // Nút Google
                    AuthSocialButton(
                      onTap: () {
                        // Xử lý Google Sign In
                      },
                    ),
                    const SizedBox(height: 26),

                    // Đã có tài khoản? Đăng nhập ngay
                    AuthPromptRow(
                      text: 'Đã có tài khoản? ',
                      actionText: 'Đăng nhập ngay',
                      onActionTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20),

                    // Điều khoản
                    const AuthTermsFooter(
                      prefixText: 'Bằng việc đăng ký, bạn đồng ý với ',
                    ),
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
