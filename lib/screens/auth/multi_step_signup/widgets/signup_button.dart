import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class SignupButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const SignupButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColors.berryCrush : AppColors.berryCrush.withOpacity(0.5),
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.berryCrush.withOpacity(0.5),
          disabledForegroundColor: AppColors.white.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
