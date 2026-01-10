import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/screens/discover/comprehensive_browse_screen.dart';

/// Trending destinations carousel
class TrendingSection extends StatelessWidget {
  final Function(Map<String, dynamic>)? onDestinationTap;

  const TrendingSection({super.key, this.onDestinationTap});

  @override
  Widget build(BuildContext context) {
    final trending = [
      {
        'name': 'Maasai Mara',
        'location': 'Narok County',
        'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
        'rating': 4.9,
        'reviews': 1240,
        'price': 'From \$450/person',
        'trending': 'Hot this week',
      },
      {
        'name': 'Diani Beach',
        'location': 'South Coast',
        'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
        'rating': 4.8,
        'reviews': 856,
        'price': 'From \$120/person',
        'trending': 'Most viewed',
      },
      {
        'name': 'Mount Kenya',
        'location': 'Central Kenya',
        'image': 'https://images.unsplash.com/photo-1621414050345-53db43f7e7ab?w=800',
        'rating': 4.7,
        'reviews': 642,
        'price': 'From \$280/person',
        'trending': 'Rising fast',
      },
      {
        'name': 'Lake Nakuru',
        'location': 'Nakuru County',
        'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
        'rating': 4.8,
        'reviews': 934,
        'price': 'From \$200/person',
        'trending': 'Popular now',
      },
    ];

    return Container(
      color: AppColors.beige.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.warning.withValues(alpha: 0.2),
                        AppColors.warning.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    size: 20,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trending Destinations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Popular this week',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
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
                    'See All',
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
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: trending.length,
              itemBuilder: (context, index) {
                final destination = trending[index];
                return Container(
                  width: 240,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onDestinationTap?.call(destination),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image with trending badge
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(AppRadius.medium),
                                ),
                                child: Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.berryCrush.withValues(alpha: 0.3),
                                        AppColors.beige.withValues(alpha: 0.3),
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.landscape,
                                    size: 60,
                                    color: AppColors.greyLight.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                              // Trending badge
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.warning,
                                        AppColors.warning.withValues(alpha: 0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(AppRadius.xlarge),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.warning.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department,
                                        size: 14,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        destination['trending'] as String,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Rating badge
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.95),
                                    borderRadius: BorderRadius.circular(AppRadius.xlarge),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 12,
                                        color: AppColors.warning,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${destination['rating']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Content
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        destination['location'] as String,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${destination['reviews']} reviews',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                                      ),
                                    ),
                                    Text(
                                      destination['price'] as String,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.berryCrush,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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
