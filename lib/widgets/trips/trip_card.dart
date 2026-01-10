import 'package:flutter/material.dart';
import 'package:zuritrails/models/trip.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Trip card widget - displays trip information
///
/// Shows:
/// - Cover image (first trip item or default)
/// - Title, dates, status badge
/// - Item count and progress
/// - Action buttons based on status
class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onStartTrip;
  final VoidCallback? onResumeJourney;

  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStartTrip,
    this.onResumeJourney,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            _buildCoverImage(),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trip.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Date Range
                  if (trip.startDate != null || trip.endDate != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getDateRangeText(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 8),

                  // Stats Row
                  Row(
                    children: [
                      // Item count
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.berryCrush,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${trip.destinationCount} destination${trip.destinationCount != 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Progress (if has items)
                      if (trip.items.isNotEmpty) ...[
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${trip.visitedCount}/${trip.destinationCount} visited',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],

                      const Spacer(),

                      // Trip type icon
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: trip.type == TripType.booked
                              ? AppColors.info.withValues(alpha: 0.1)
                              : AppColors.berryCrush.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              trip.type == TripType.booked
                                  ? Icons.business
                                  : Icons.person,
                              size: 12,
                              color: trip.type == TripType.booked
                                  ? AppColors.info
                                  : AppColors.berryCrush,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trip.type == TripType.booked ? 'Booked' : 'Personal',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: trip.type == TripType.booked
                                    ? AppColors.info
                                    : AppColors.berryCrush,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Action Buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    // Get cover image from first trip item with photo, or use default
    String? coverImageUrl;
    if (trip.items.isNotEmpty) {
      final itemWithPhoto = trip.items.firstWhere(
        (item) => item.coverPhotoUrl != null,
        orElse: () => trip.items.first,
      );
      coverImageUrl = itemWithPhoto.coverPhotoUrl;
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.large),
      ),
      child: Stack(
        children: [
          // Image
          coverImageUrl != null
              ? Image.network(
                  coverImageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultCover();
                  },
                )
              : _buildDefaultCover(),

          // Gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.berryCrush.withValues(alpha: 0.3),
            AppColors.beige.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          trip.type == TripType.booked ? Icons.business : Icons.explore,
          size: 48,
          color: AppColors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (trip.status) {
      case TripStatus.planning:
        backgroundColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        label = 'Planning';
        break;
      case TripStatus.upcoming:
        backgroundColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        label = 'Upcoming';
        break;
      case TripStatus.active:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        label = 'Active';
        break;
      case TripStatus.completed:
        backgroundColor = AppColors.textSecondary.withValues(alpha: 0.1);
        textColor = AppColors.textSecondary;
        label = 'Completed';
        break;
      case TripStatus.cancelled:
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  String _getDateRangeText() {
    if (trip.startDate != null && trip.endDate != null) {
      final start = trip.startDate!;
      final end = trip.endDate!;

      // Format: "Jan 15-20, 2024" or "Jan 15 - Feb 2, 2024"
      if (start.month == end.month && start.year == end.year) {
        return '${_monthName(start.month)} ${start.day}-${end.day}, ${start.year}';
      } else if (start.year == end.year) {
        return '${_monthName(start.month)} ${start.day} - ${_monthName(end.month)} ${end.day}, ${start.year}';
      } else {
        return '${_monthName(start.month)} ${start.day}, ${start.year} - ${_monthName(end.month)} ${end.day}, ${end.year}';
      }
    } else if (trip.startDate != null) {
      final start = trip.startDate!;
      return '${_monthName(start.month)} ${start.day}, ${start.year}';
    } else if (trip.endDate != null) {
      final end = trip.endDate!;
      return 'Until ${_monthName(end.month)} ${end.day}, ${end.year}';
    }
    return '';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildActionButtons() {
    switch (trip.status) {
      case TripStatus.planning:
        // Planning: Edit, Delete
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.greyLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        );

      case TripStatus.upcoming:
        // Upcoming: View Details, Start Trip
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text('View Details'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.greyLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onStartTrip,
                icon: const Icon(Icons.play_arrow, size: 16),
                label: const Text('Start'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.berryCrush,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        );

      case TripStatus.active:
        // Active: Resume Journey
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onResumeJourney,
            icon: const Icon(Icons.navigation, size: 18),
            label: const Text('Resume Journey'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        );

      case TripStatus.completed:
        // Completed: View Summary
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.summarize, size: 16),
            label: const Text('View Summary'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.greyLight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        );

      case TripStatus.cancelled:
        // Cancelled: No actions
        return const SizedBox.shrink();
    }
  }
}
