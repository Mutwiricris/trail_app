import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/screens/discover/comprehensive_browse_screen.dart';

/// Curated travel collections section
class TravelCollectionsSection extends StatelessWidget {
  final Function(Map<String, dynamic>)? onCollectionTap;

  const TravelCollectionsSection({super.key, this.onCollectionTap});

  @override
  Widget build(BuildContext context) {
    final collections = [
      {
        'title': 'Weekend Getaways',
        'description': 'Perfect 2-3 day escapes',
        'icon': '🏖️',
        'count': '12 experiences',
        'gradient': [AppColors.berryCrush, AppColors.berryCrush.withValues(alpha: 0.7)],
      },
      {
        'title': 'Adventure Seekers',
        'description': 'Thrilling outdoor activities',
        'icon': '⛰️',
        'count': '18 experiences',
        'gradient': [AppColors.success, AppColors.success.withValues(alpha: 0.7)],
      },
      {
        'title': 'Family Friendly',
        'description': 'Fun for all ages',
        'icon': '👨‍👩‍👧‍👦',
        'count': '15 experiences',
        'gradient': [AppColors.warning, AppColors.warning.withValues(alpha: 0.7)],
      },
      {
        'title': 'Cultural Tours',
        'description': 'Immerse in local culture',
        'icon': '🎭',
        'count': '10 experiences',
        'gradient': [AppColors.info, AppColors.info.withValues(alpha: 0.7)],
      },
      {
        'title': 'Wildlife Safari',
        'description': 'Close encounters with nature',
        'icon': '🦁',
        'count': '8 experiences',
        'gradient': [AppColors.success, AppColors.success.withValues(alpha: 0.7)],
      },
    ];

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Travel Collections',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Curated experiences just for you',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ComprehensiveBrowseScreen(initialTab: 0),
                      ),
                    );
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.berryCrush,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: collections.length,
              itemBuilder: (context, index) {
                final collection = collections[index];
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: collection['gradient'] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onCollectionTap?.call(collection),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      collection['icon'] as String,
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(AppRadius.xlarge),
                                  ),
                                  child: Text(
                                    collection['count'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  collection['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  collection['description'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
