import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';

/// Quick booking cards for featured experiences
class QuickBookingCards extends StatelessWidget {
  const QuickBookingCards({super.key});

  @override
  Widget build(BuildContext context) {
    final featured = [
      {
        'title': 'Weekend Safari Escape',
        'subtitle': '2 Days | Maasai Mara',
        'description': 'All-inclusive safari with game drives and luxury tented camp',
        'price': '\$520',
        'originalPrice': '\$650',
        'discount': '20% OFF',
        'icon': Icons.camera_alt,
        'gradient': [AppColors.berryCrush, AppColors.berryCrush.withValues(alpha: 0.8)],
        'features': ['Game drives', 'Luxury camp', 'All meals'],
        'availability': '8 spots left',
      },
      {
        'title': 'Coastal Paradise',
        'subtitle': '3 Days | Diani Beach',
        'description': 'Beach resort stay with water sports and snorkeling',
        'price': '\$280',
        'originalPrice': '\$350',
        'discount': '20% OFF',
        'icon': Icons.beach_access,
        'gradient': [AppColors.info, AppColors.info.withValues(alpha: 0.8)],
        'features': ['Beach resort', 'Water sports', 'Breakfast'],
        'availability': 'Limited slots',
      },
      {
        'title': 'Mountain Adventure',
        'subtitle': '4 Days | Mount Kenya',
        'description': 'Guided trekking with professional guides and camping',
        'price': '\$340',
        'originalPrice': '\$425',
        'discount': '20% OFF',
        'icon': Icons.terrain,
        'gradient': [AppColors.success, AppColors.success.withValues(alpha: 0.8)],
        'features': ['Expert guides', 'Camping gear', 'All meals'],
        'availability': '5 spots left',
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Featured Experiences',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Book now and save up to 20%',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.error,
                        AppColors.error.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.xlarge),
                  ),
                  child: const Text(
                    'SALE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: featured.length,
              itemBuilder: (context, index) {
                final experience = featured[index];
                return Container(
                  width: 340,
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
                      onTap: () {},
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: Column(
                        children: [
                          // Header with gradient
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: experience['gradient'] as List<Color>,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppRadius.medium),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(AppRadius.small),
                                  ),
                                  child: Icon(
                                    experience['icon'] as IconData,
                                    size: 24,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        experience['title'] as String,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        experience['subtitle'] as String,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.white.withValues(alpha: 0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(AppRadius.small),
                                  ),
                                  child: Text(
                                    experience['discount'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: (experience['gradient'] as List<Color>).first,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    experience['description'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  // Features
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: (experience['features'] as List<String>)
                                        .map((feature) => Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.beige.withValues(alpha: 0.5),
                                                borderRadius: BorderRadius.circular(AppRadius.small),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    size: 12,
                                                    color: AppColors.success.withValues(alpha: 0.8),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    feature,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors.textPrimary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  const Spacer(),
                                  // Price and CTA
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                experience['price'] as String,
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.berryCrush,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                experience['originalPrice'] as String,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            experience['availability'] as String,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppColors.error.withValues(alpha: 0.8),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: experience['gradient'] as List<Color>,
                                          ),
                                          borderRadius: BorderRadius.circular(AppRadius.medium),
                                          boxShadow: [
                                            BoxShadow(
                                              color: (experience['gradient'] as List<Color>).first
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {},
                                            borderRadius: BorderRadius.circular(AppRadius.medium),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Book Now',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    size: 16,
                                                    color: AppColors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
