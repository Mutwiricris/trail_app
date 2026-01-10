import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/trip.dart';
import 'package:zuritrails/models/journey.dart';
import 'package:zuritrails/services/trip_service.dart';
import 'package:zuritrails/services/journey_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Trip details screen - shows comprehensive trip information
///
/// Sections:
/// - Header with cover image and title
/// - Overview (description, duration, destinations)
/// - Itinerary (trip items with visit status)
/// - Journey Progress (for active trips)
/// - Actions (Start, Add Items, Edit, Delete)
class TripDetailsScreen extends StatefulWidget {
  final Trip trip;

  const TripDetailsScreen({
    super.key,
    required this.trip,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late Trip _trip;

  @override
  void initState() {
    super.initState();
    _trip = widget.trip;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Cover Image
          _buildAppBar(),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(),

                const SizedBox(height: AppSpacing.sm),

                // Overview Section
                _buildOverviewSection(),

                const SizedBox(height: AppSpacing.sm),

                // Itinerary Section
                _buildItinerarySection(),

                const SizedBox(height: AppSpacing.sm),

                // Journey Progress (if active)
                if (_trip.status == TripStatus.active)
                  _buildJourneyProgressSection(),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildAppBar() {
    // Get cover image from first trip item with photo
    String? coverImageUrl;
    if (_trip.items.isNotEmpty) {
      final itemWithPhoto = _trip.items.firstWhere(
        (item) => item.coverPhotoUrl != null,
        orElse: () => _trip.items.first,
      );
      coverImageUrl = itemWithPhoto.coverPhotoUrl;
    }

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.berryCrush,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: AppColors.white),
          onPressed: _handleShare,
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: AppColors.white),
          onPressed: _handleEdit,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Cover Image
            coverImageUrl != null
                ? Image.network(
                    coverImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultCover();
                    },
                  )
                : _buildDefaultCover(),

            // Gradient Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.berryCrush,
            AppColors.berryCrush.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _trip.type == TripType.booked ? Icons.business : Icons.explore,
          size: 64,
          color: AppColors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _trip.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildStatusBadge(),
            ],
          ),

          const SizedBox(height: 16),

          // Date Range
          if (_trip.startDate != null || _trip.endDate != null)
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  _getDateRangeText(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 12),

          // Trip Type
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _trip.type == TripType.booked
                      ? AppColors.info.withValues(alpha: 0.1)
                      : AppColors.berryCrush.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _trip.type == TripType.booked
                          ? Icons.business
                          : Icons.person,
                      size: 16,
                      color: _trip.type == TripType.booked
                          ? AppColors.info
                          : AppColors.berryCrush,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _trip.type == TripType.booked
                          ? 'Booked Tour'
                          : 'Personal Trip',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _trip.type == TripType.booked
                            ? AppColors.info
                            : AppColors.berryCrush,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (_trip.status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.location_on,
                  label: 'Destinations',
                  value: '${_trip.destinationCount}',
                  color: AppColors.berryCrush,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  label: 'Visited',
                  value: '${_trip.visitedCount}',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.calendar_month,
                  label: 'Duration',
                  value: _trip.durationDays != null
                      ? '${_trip.durationDays} days'
                      : 'N/A',
                  color: AppColors.info,
                ),
              ),
            ],
          ),

          if (_trip.description != null && _trip.description!.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _trip.description!,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],

          // Operator Info (if booked trip)
          if (_trip.type == TripType.booked &&
              _trip.operatorBooking != null) ...[
            const SizedBox(height: 20),
            _buildOperatorInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOperatorInfo() {
    final operator = _trip.operatorBooking!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.beige.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.business,
                  size: 20,
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      operator.operatorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Tour Operator',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  Icons.confirmation_number,
                  'Booking #${operator.confirmationCode}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  Icons.payments,
                  'KSh ${operator.priceKES.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _buildInfoRow(
                  operator.isPaid ? Icons.check_circle : Icons.pending,
                  operator.isPaid ? 'Paid' : 'Pending',
                  color: operator.isPaid ? AppColors.success : AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color ?? AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildItinerarySection() {
    if (_trip.items.isEmpty) {
      return Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(
              Icons.add_location_alt_outlined,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'No Destinations Added',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Start building your itinerary',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _handleAddItems,
              icon: const Icon(Icons.add),
              label: const Text('Add Destinations'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.berryCrush,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Itinerary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: _handleAddItems,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Trip Items List
          ...List.generate(_trip.items.length, (index) {
            final item = _trip.items[index];
            return _buildTripItemCard(item, index);
          }),
        ],
      ),
    );
  }

  Widget _buildTripItemCard(TripItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isVisited
            ? AppColors.success.withValues(alpha: 0.05)
            : AppColors.beige.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: item.isVisited
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.greyLight.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: item.isVisited
                ? AppColors.success
                : AppColors.berryCrush.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: item.isVisited
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.white,
                    size: 24,
                  )
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.berryCrush,
                    ),
                  ),
          ),
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            decoration: item.isVisited ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: item.description != null
            ? Text(
                item.description!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTripItemTypeColor(item.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getTripItemTypeLabel(item.type),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _getTripItemTypeColor(item.type),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
        onTap: () => _handleViewTripItem(item),
      ),
    );
  }

  Color _getTripItemTypeColor(TripItemType type) {
    switch (type) {
      case TripItemType.gem:
        return AppColors.berryCrush;
      case TripItemType.safari:
        return AppColors.success;
      case TripItemType.route:
        return AppColors.info;
      case TripItemType.custom:
        return AppColors.warning;
    }
  }

  String _getTripItemTypeLabel(TripItemType type) {
    switch (type) {
      case TripItemType.gem:
        return 'Gem';
      case TripItemType.safari:
        return 'Safari';
      case TripItemType.route:
        return 'Route';
      case TripItemType.custom:
        return 'Custom';
    }
  }

  Widget _buildJourneyProgressSection() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.navigation,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Journey in Progress',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Stats
          Row(
            children: [
              Expanded(
                child: _buildProgressStat(
                  'Places Visited',
                  '${_trip.visitedCount}/${_trip.destinationCount}',
                  _trip.progressPercent / 100,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // View Journey Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _handleViewLiveJourney,
              icon: const Icon(Icons.map),
              label: const Text('View Live Journey'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.greyLight.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation(AppColors.success),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    // Different actions based on trip status
    Widget actionButton;

    switch (_trip.status) {
      case TripStatus.planning:
      case TripStatus.upcoming:
        actionButton = ElevatedButton.icon(
          onPressed: _handleStartTrip,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Trip'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.berryCrush,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            elevation: 0,
          ),
        );
        break;
      case TripStatus.active:
        actionButton = ElevatedButton.icon(
          onPressed: _handleCompleteTrip,
          icon: const Icon(Icons.check_circle),
          label: const Text('Complete Trip'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            elevation: 0,
          ),
        );
        break;
      case TripStatus.completed:
        actionButton = OutlinedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.check_circle),
          label: const Text('Trip Completed'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: AppColors.success.withValues(alpha: 0.5)),
            foregroundColor: AppColors.success,
          ),
        );
        break;
      case TripStatus.cancelled:
        return const SizedBox.shrink();
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Delete button (if not active or completed)
            if (_trip.status != TripStatus.active &&
                _trip.status != TripStatus.completed)
              IconButton(
                onPressed: _handleDelete,
                icon: const Icon(Icons.delete_outline),
                color: AppColors.error,
                iconSize: 24,
              ),
            const SizedBox(width: 8),

            // Main action button
            Expanded(child: actionButton),
          ],
        ),
      ),
    );
  }

  String _getDateRangeText() {
    if (_trip.startDate != null && _trip.endDate != null) {
      final start = _trip.startDate!;
      final end = _trip.endDate!;

      if (start.month == end.month && start.year == end.year) {
        return '${_monthName(start.month)} ${start.day}-${end.day}, ${start.year}';
      } else if (start.year == end.year) {
        return '${_monthName(start.month)} ${start.day} - ${_monthName(end.month)} ${end.day}, ${start.year}';
      } else {
        return '${_monthName(start.month)} ${start.day}, ${start.year} - ${_monthName(end.month)} ${end.day}, ${end.year}';
      }
    } else if (_trip.startDate != null) {
      final start = _trip.startDate!;
      return 'From ${_monthName(start.month)} ${start.day}, ${start.year}';
    } else if (_trip.endDate != null) {
      final end = _trip.endDate!;
      return 'Until ${_monthName(end.month)} ${end.day}, ${end.year}';
    }
    return 'No dates set';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  // Action Handlers
  void _handleShare() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share trip coming soon')),
    );
  }

  void _handleEdit() {
    // TODO: Navigate to edit trip screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit trip coming soon')),
    );
  }

  void _handleAddItems() {
    // TODO: Navigate to add items screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add items coming soon')),
    );
  }

  void _handleViewTripItem(TripItem item) {
    // TODO: Navigate to item details based on type
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View ${item.type.name}: ${item.name}')),
    );
  }

  void _handleViewLiveJourney() {
    // TODO: Navigate to active journey screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Live journey view coming soon')),
    );
  }

  Future<void> _handleStartTrip() async {
    try {
      await context.read<TripService>().startTrip(_trip.id);
      if (mounted) {
        // Refresh trip data
        final updatedTrip = context.read<TripService>().getTrip(_trip.id);
        if (updatedTrip != null) {
          setState(() {
            _trip = updatedTrip;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trip started! Journey tracking active.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting trip: $e')),
        );
      }
    }
  }

  Future<void> _handleCompleteTrip() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Trip'),
        content: const Text(
          'Are you sure you want to mark this trip as completed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<TripService>().completeTrip(_trip.id);
        if (mounted) {
          // Refresh trip data
          final updatedTrip = context.read<TripService>().getTrip(_trip.id);
          if (updatedTrip != null) {
            setState(() {
              _trip = updatedTrip;
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Trip completed! Great adventure!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error completing trip: $e')),
          );
        }
      }
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "${_trip.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<TripService>().deleteTrip(_trip.id);
        if (mounted) {
          Navigator.pop(context); // Go back to trips list
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trip deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting trip: $e')),
          );
        }
      }
    }
  }
}
