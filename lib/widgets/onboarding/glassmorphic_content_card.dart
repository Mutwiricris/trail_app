import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class GlassmorphicContentCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;

  const GlassmorphicContentCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.blur = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.white.withOpacity(0.25),
                AppColors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              width: 1.5,
              color: AppColors.white.withOpacity(0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}
