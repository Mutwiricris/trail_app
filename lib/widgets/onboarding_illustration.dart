import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class OnboardingIllustration extends StatelessWidget {
  final OnboardingIllustrationType type;

  const OnboardingIllustration({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case OnboardingIllustrationType.safari:
        return const SafariIllustration();
      case OnboardingIllustrationType.hiddenGems:
        return const HiddenGemsIllustration();
      case OnboardingIllustrationType.community:
        return const CommunityIllustration();
    }
  }
}

enum OnboardingIllustrationType {
  safari,
  hiddenGems,
  community,
}

// Safari Discovery Illustration
class SafariIllustration extends StatelessWidget {
  const SafariIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circles
          Positioned(
            top: 20,
            right: 30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.berryCrushLight.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main illustration container
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.berryCrush.withOpacity(0.1),
                  AppColors.berryCrushLight.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Binoculars icon
                const Icon(
                  Icons.travel_explore,
                  size: 80,
                  color: AppColors.berryCrush,
                ),

                // Small accent icons around
                Positioned(
                  top: 20,
                  right: 30,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.info,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.landscape,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 30,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.berryCrushLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.berryCrush.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: AppColors.white,
                    ),
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

// Hidden Gems Illustration
class HiddenGemsIllustration extends StatelessWidget {
  const HiddenGemsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background shapes
          Positioned(
            top: 30,
            left: 40,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 30,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.berryCrushLight.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.berryCrushLight.withOpacity(0.12),
                  AppColors.berryCrush.withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Main map icon
                const Icon(
                  Icons.map,
                  size: 80,
                  color: AppColors.berryCrushLight,
                ),

                // Location markers
                Positioned(
                  top: 35,
                  right: 45,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.info,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.info.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.place,
                      size: 18,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 50,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.berryCrush,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.berryCrush.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 40,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.info.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.diamond,
                      size: 14,
                      color: AppColors.white,
                    ),
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

// Community Illustration
class CommunityIllustration extends StatelessWidget {
  const CommunityIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background elements
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.berryCrushDark.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.berryCrushDark.withOpacity(0.12),
                  AppColors.berryCrush.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Main groups icon
                const Icon(
                  Icons.groups,
                  size: 80,
                  color: AppColors.berryCrushDark,
                ),

                // Floating elements around
                Positioned(
                  top: 25,
                  right: 35,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.info,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.info.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 35,
                  left: 30,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.berryCrushLight,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.berryCrush.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chat_bubble,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 25,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.berryCrush,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.berryCrush.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 14,
                      color: AppColors.white,
                    ),
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
