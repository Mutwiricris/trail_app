import 'package:flutter/material.dart';
import 'package:zuritrails/models/activity_data.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:intl/intl.dart';

/// Bottom sheet preview for an activity with Join and Chat buttons
class ActivityPreviewSheet extends StatelessWidget {
  final ActivityData activity;

  const ActivityPreviewSheet({
    super.key,
    required this.activity,
  });

  String _getActivityEmoji() {
    switch (activity.type) {
      case 'food_drinks':
        return '🍴';
      case 'nightlife':
        return '🎉';
      case 'outdoor':
        return '🥾';
      case 'sightseeing':
        return '🗺️';
      case 'entertainment':
        return '🎭';
      case 'shopping':
        return '🛍️';
      default:
        return '✨';
    }
  }

  String _getTypeName() {
    switch (activity.type) {
      case 'food_drinks':
        return 'Food & Drinks';
      case 'nightlife':
        return 'Nightlife';
      case 'outdoor':
        return 'Outdoor & Active';
      case 'sightseeing':
        return 'Sightseeing';
      case 'entertainment':
        return 'Entertainment';
      case 'shopping':
        return 'Shopping';
      default:
        return 'Activity';
    }
  }

  String _formatDate() {
    if (activity.date == null) return 'Today';
    final now = DateTime.now();
    final activityDate = activity.date!;

    if (activityDate.day == now.day &&
        activityDate.month == now.month &&
        activityDate.year == now.year) {
      return 'Today';
    } else if (activityDate.day == now.day + 1 &&
        activityDate.month == now.month &&
        activityDate.year == now.year) {
      return 'Tomorrow';
    } else {
      return DateFormat('MMM d').format(activityDate);
    }
  }

  String _getTimeText() {
    if (activity.timeType == 'flexible') {
      return 'Flexible time';
    } else if (activity.specificTime != null) {
      return activity.specificTime!;
    }
    return 'Anytime';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Activity type badge and emoji
                Row(
                  children: [
                    Text(
                      _getActivityEmoji(),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.berryCrush.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getTypeName(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.berryCrush,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Privacy indicator
                    if (activity.privacy == 'private')
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 16,
                          color: AppColors.grey,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Activity description
                Text(
                  activity.description ?? 'Join this activity',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 20),

                // Date and Time
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.access_time,
                      size: 18,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getTimeText(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Age range
                Row(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 18,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ages ${activity.minAge}-${activity.maxAge}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      activity.privacy == 'open' ? 'Open to all' : 'Approval required',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Organizer info (placeholder)
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.berryCrush.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.berryCrush,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Organized by',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'You',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
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
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Hosting',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Implement chat
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Chat feature coming soon!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.berryCrush,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 20,
                                color: AppColors.berryCrush,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Chat',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.berryCrush,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement join
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You joined this activity!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.berryCrush,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Join',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
