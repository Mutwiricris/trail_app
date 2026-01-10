import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class AnimatedOnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final PageController pageController;
  final int index;

  const AnimatedOnboardingPage({
    super.key,
    required this.data,
    required this.pageController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double opacity = 1.0;

        if (pageController.position.haveDimensions) {
          final pageOffset = pageController.page! - index;
          opacity = (1 - pageOffset.abs()).clamp(0.0, 1.0);
        }

        return Opacity(
          opacity: opacity,
          child: child!,
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen image
          if (data.imageUrl != null)
            Image.network(
              data.imageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.beige.withOpacity(0.2),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.berryCrush,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.beige.withOpacity(0.3),
                );
              },
            ),

          // Gradient overlay for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
          ),

          // Text content at bottom
          Positioned(
            left: 24,
            right: 24,
            bottom: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data.description,
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors.white.withOpacity(0.95),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPageData {
  final String? imageUrl;
  final String title;
  final String description;

  OnboardingPageData({
    this.imageUrl,
    required this.title,
    required this.description,
  });
}
