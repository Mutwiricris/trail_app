import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/trip.dart';
import 'package:zuritrails/models/wishlist_item.dart';
import 'package:zuritrails/services/trip_service.dart';
import 'package:zuritrails/services/wishlist_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/widgets/trips/trip_card.dart';
import 'package:zuritrails/widgets/trips/create_trip_dialog.dart';
import 'package:zuritrails/screens/trips/trip_details_screen.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Trips',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleCreateTrip,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.beige.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.berryCrush,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.beige.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.berryCrush,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Past'),
                    Tab(text: 'Wishlist'),
                  ],
                ),
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildUpcomingTab(),
                  _buildPastTab(),
                  _buildWishlistTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTab() {
    return Consumer<TripService>(
      builder: (context, tripService, _) {
        final upcomingTrips = tripService.getUpcomingTrips();

        if (upcomingTrips.isEmpty) {
          return _buildEmptyState(
            icon: Icons.luggage,
            title: 'No Upcoming Trips',
            message: 'Start planning your next adventure!',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          itemCount: upcomingTrips.length,
          itemBuilder: (context, index) {
            final trip = upcomingTrips[index];
            return TripCard(
              trip: trip,
              onTap: () => _handleViewTripDetails(trip),
              onEdit: () => _handleEditTrip(trip),
              onDelete: () => _handleDeleteTrip(trip),
              onStartTrip: () => _handleStartTrip(trip),
              onResumeJourney: () => _handleResumeJourney(trip),
            );
          },
        );
      },
    );
  }

  Widget _buildPastTab() {
    return Consumer<TripService>(
      builder: (context, tripService, _) {
        final pastTrips = tripService.getPastTrips();

        if (pastTrips.isEmpty) {
          return _buildEmptyState(
            icon: Icons.history,
            title: 'No Past Trips',
            message: 'Your travel history will appear here',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          itemCount: pastTrips.length,
          itemBuilder: (context, index) {
            final trip = pastTrips[index];
            return TripCard(
              trip: trip,
              onTap: () => _handleViewTripDetails(trip),
            );
          },
        );
      },
    );
  }

  Widget _buildWishlistTab() {
    return Consumer<WishlistService>(
      builder: (context, wishlistService, _) {
        final wishlistItems = wishlistService.getAllWishlistItems();

        if (wishlistItems.isEmpty) {
          return _buildEmptyState(
            icon: Icons.favorite_border,
            title: 'Your Wishlist is Empty',
            message: 'Save places you want to visit later',
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemCount: wishlistItems.length,
          itemBuilder: (context, index) {
            final item = wishlistItems[index];
            return _buildWishlistCard(item);
          },
        );
      },
    );
  }

  // Wishlist Card Widget
  Widget _buildWishlistCard(WishlistItem item) {
    return GestureDetector(
      onTap: () => _handleViewWishlistItem(item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.medium),
                ),
                child: item.coverPhotoUrl != null
                    ? Image.network(
                        item.coverPhotoUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultWishlistImage(item.type);
                        },
                      )
                    : _buildDefaultWishlistImage(item.type),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getWishlistTypeColor(item.type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getWishlistTypeLabel(item.type),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getWishlistTypeColor(item.type),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Name
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Rating
                  if (item.rating != null && item.rating! > 0)
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 12,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
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
    );
  }

  Widget _buildDefaultWishlistImage(WishlistItemType type) {
    IconData icon;
    switch (type) {
      case WishlistItemType.gem:
        icon = Icons.diamond;
        break;
      case WishlistItemType.safari:
        icon = Icons.landscape;
        break;
      case WishlistItemType.route:
        icon = Icons.route;
        break;
    }

    return Container(
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
          icon,
          size: 32,
          color: AppColors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Color _getWishlistTypeColor(WishlistItemType type) {
    switch (type) {
      case WishlistItemType.gem:
        return AppColors.berryCrush;
      case WishlistItemType.safari:
        return AppColors.success;
      case WishlistItemType.route:
        return AppColors.info;
    }
  }

  String _getWishlistTypeLabel(WishlistItemType type) {
    switch (type) {
      case WishlistItemType.gem:
        return 'Gem';
      case WishlistItemType.safari:
        return 'Safari';
      case WishlistItemType.route:
        return 'Route';
    }
  }

  // Action Handlers
  Future<void> _handleCreateTrip() async {
    await showDialog(
      context: context,
      builder: (context) => const CreateTripDialog(),
    );
  }

  void _handleViewTripDetails(Trip trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsScreen(trip: trip),
      ),
    );
  }

  void _handleEditTrip(Trip trip) {
    // TODO: Navigate to edit trip screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit trip: ${trip.title}')),
    );
  }

  Future<void> _handleDeleteTrip(Trip trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "${trip.title}"?'),
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
        await context.read<TripService>().deleteTrip(trip.id);
        if (mounted) {
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

  Future<void> _handleStartTrip(Trip trip) async {
    try {
      await context.read<TripService>().startTrip(trip.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Started trip: ${trip.title}')),
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

  void _handleResumeJourney(Trip trip) {
    // TODO: Navigate to active journey screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resume journey: ${trip.title}')),
    );
  }

  void _handleViewWishlistItem(WishlistItem item) {
    // TODO: Navigate to gem/safari/route details based on type
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View ${item.type.name}: ${item.name}')),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.beige.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text('Explore Safaris'),
            ),
          ],
        ),
      ),
    );
  }
}
