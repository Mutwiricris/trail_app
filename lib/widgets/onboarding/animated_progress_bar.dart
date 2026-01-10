import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zuritrails/utils/app_colors.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final int totalPages;
  final double width;
  final double height;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.totalPages,
    this.width = 120,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.greyLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        width: width * progress,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.berryCrush,
              AppColors.berryCrush.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(height / 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.berryCrush.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
      ),
    );
  }
}
