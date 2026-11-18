import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AuthPromptRow extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onActionTap;

  const AuthPromptRow({
    super.key,
    required this.text,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLink,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryLink,
            ),
          ),
        ),
      ],
    );
  }
}

class AuthTermsFooter extends StatelessWidget {
  final String prefixText;

  const AuthTermsFooter({
    super.key,
    this.prefixText = 'Bằng việc tiếp tục, bạn đồng ý với ',
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: prefixText,
        style: const TextStyle(
          fontSize: 11.5,
          color: AppColors.textHint,
          height: 1.5,
        ),
        children: const [
          TextSpan(
            text: 'Điều khoản dịch vụ',
            style: TextStyle(
              color: AppColors.textMuted,
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(text: '\nvà '),
          TextSpan(
            text: 'Chính sách bảo mật',
            style: TextStyle(
              color: AppColors.textMuted,
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(text: ' của FoodHub Sài Gòn.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
