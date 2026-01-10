import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/screens/discover/comprehensive_browse_screen.dart';

/// Tour Operators horizontal section
class OperatorsSection extends StatelessWidget {
  final Function(Map<String, dynamic>)? onOperatorTap;

  const OperatorsSection({super.key, this.onOperatorTap});

  @override
  Widget build(BuildContext context) {
    final operators = [
      {
        'name': 'Safari Experts',
        'logo': '🦁',
        'tours': '45',
        'rating': 4.9,
        'verified': true,
      },
      {
        'name': 'Mountain Guides',
        'logo': '⛰️',
        'tours': '32',
        'rating': 4.8,
        'verified': true,
      },
      {
        'name': 'Beach Adventures',
        'logo': '🏖️',
        'tours': '28',
        'rating': 4.7,
        'verified': true,
      },
      {
        'name': 'Culture Tours',
        'logo': '🎭',
        'tours': '38',
        'rating': 4.9,
        'verified': true,
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
                      'Trusted Tour Operators',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Verified professionals you can trust',
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
                        builder: (context) => const ComprehensiveBrowseScreen(initialTab: 2),
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
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: operators.length,
              itemBuilder: (context, index) {
                final operator = operators[index];
                return GestureDetector(
                  onTap: () => onOperatorTap?.call(operator),
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.beige.withValues(alpha: 0.5),
                        AppColors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(
                      color: AppColors.greyLight.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            operator['logo'] as String,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              operator['name'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (operator['verified'] == true) ...[
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.verified,
                              size: 12,
                              color: AppColors.info,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 11,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${operator['rating']}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${operator['tours']} tours',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
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
