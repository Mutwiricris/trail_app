import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class ExplorerCard extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String location;
  final String time;
  final String activity;
  final VoidCallback onTap;

  const ExplorerCard({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.location,
    required this.time,
    required this.activity,
    required this.onTap,
  });

  IconData _getActivityIcon() {
    switch (activity.toLowerCase()) {
      case 'hiking':
        return Icons.hiking;
      case 'safari':
        return Icons.camera_alt;
      case 'camping':
        return Icons.forest;
      case 'biking':
        return Icons.pedal_bike;
      case 'wildlife':
        return Icons.pets;
      default:
        return Icons.explore;
    }
  }

  Color _getActivityColor() {
    switch (activity.toLowerCase()) {
      case 'hiking':
        return AppColors.success;
      case 'safari':
        return AppColors.warning;
      case 'camping':
        return AppColors.info;
      case 'biking':
        return AppColors.berryCrush;
      case 'wildlife':
        return AppColors.berryCrushLight;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.greyLight.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar with Live Indicator
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getActivityColor().withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(avatarUrl),
                    backgroundColor: AppColors.beige.withOpacity(0.3),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: avatarUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 32,
                            color: AppColors.textSecondary,
                          )
                        : null,
                  ),
                ),
                // Live indicator
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Activity and Time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getActivityColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getActivityIcon(),
                              size: 12,
                              color: _getActivityColor(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              activity,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _getActivityColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.berryCrush.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.berryCrush,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
