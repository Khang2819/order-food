import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String? trailingText;
  final VoidCallback? onTrailingTap;
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    this.trailingText,
    this.onTrailingTap,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textLabel,
              ),
            ),
            if (trailingText != null)
              GestureDetector(
                onTap: onTrailingTap,
                child: Text(
                  trailingText!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: onTrailingTap != null
                        ? AppColors.primaryLink
                        : AppColors.primaryText,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1.2),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: AppColors.textMain),
            decoration: InputDecoration(
              prefixIcon: Icon(prefixIcon, color: AppColors.textSub, size: 20),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSub,
                        size: 20,
                      ),
                      onPressed: onToggleObscure,
                    )
                  : null,
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.textHint,
                fontSize: isPassword ? 16 : 13.5,
                letterSpacing: isPassword ? 1.5 : 0,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
