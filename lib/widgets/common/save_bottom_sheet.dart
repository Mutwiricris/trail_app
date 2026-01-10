import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/wishlist_item.dart';
import 'package:zuritrails/models/hidden_gem.dart';
import 'package:zuritrails/models/route.dart' as app_route;
import 'package:zuritrails/services/wishlist_service.dart';
import 'package:zuritrails/services/trip_service.dart';
import 'package:zuritrails/services/offline_save_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import '../trips/create_trip_dialog.dart';

/// Type of item being saved
enum SaveItemType { gem, safari, route }

/// Save bottom sheet - shows 3 save options
///
/// Options:
/// 1. Add to Wishlist - Quick bookmark
/// 2. Add to Trip - Add to existing/new trip
/// 3. Save for Offline - Download for offline access
class SaveBottomSheet extends StatefulWidget {
  final String itemId;
  final String itemName;
  final SaveItemType itemType;
  final dynamic itemData; // HiddenGem, Map (safari), or Route

  const SaveBottomSheet({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.itemType,
    required this.itemData,
  });

  @override
  State<SaveBottomSheet> createState() => _SaveBottomSheetState();
}

class _SaveBottomSheetState extends State<SaveBottomSheet> {
  String? _selectedTripId;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final wishlistService = context.watch<WishlistService>();
    final tripService = context.watch<TripService>();
    final offlineService = context.watch<OfflineSaveService>();

    // Check current status
    final isInWishlist = _checkIfInWishlist(wishlistService);
    final isOffline = _checkIfOffline(offlineService);
    final upcomingTrips = tripService.getUpcomingTrips();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Save ${widget.itemName}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Choose how you want to save this',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Option 1: Add to Wishlist
                _buildSaveOption(
                  icon: Icons.bookmark_border,
                  activeIcon: Icons.bookmark,
                  title: 'Add to Wishlist',
                  subtitle: 'Quick bookmark for later',
                  isActive: isInWishlist,
                  activeText: 'Already in wishlist',
                  onTap: () => _handleWishlistToggle(wishlistService, isInWishlist),
                ),

                const SizedBox(height: AppSpacing.md),

                // Option 2: Add to Trip
                _buildTripOption(
                  upcomingTrips: upcomingTrips,
                  tripService: tripService,
                ),

                const SizedBox(height: AppSpacing.md),

                // Option 3: Save for Offline
                _buildSaveOption(
                  icon: Icons.cloud_download_outlined,
                  activeIcon: Icons.offline_pin,
                  title: 'Save for Offline',
                  subtitle: 'Download for offline access',
                  isActive: isOffline,
                  activeText: 'Available offline',
                  trailing: isOffline
                      ? null
                      : Text(
                          _estimateSize(),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                  onTap: () => _handleOfflineSave(offlineService, isOffline),
                ),

                if (_isLoading) ...[
                  const SizedBox(height: AppSpacing.md),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveOption({
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required String subtitle,
    required bool isActive,
    required String activeText,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isActive
          ? AppColors.success.withValues(alpha: 0.1)
          : AppColors.beige.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.success
                      : AppColors.berryCrush.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? AppColors.white : AppColors.berryCrush,
                  size: 24,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isActive ? activeText : subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isActive
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing
              if (trailing != null) trailing,
              if (isActive)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripOption({
    required List upcomingTrips,
    required TripService tripService,
  }) {
    final hasTrips = upcomingTrips.isNotEmpty;

    return Material(
      color: AppColors.beige.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.berryCrush.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: AppColors.berryCrush,
                    size: 24,
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add to Trip',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasTrips
                            ? 'Select a trip or create new'
                            : 'Create a new trip',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (hasTrips) ...[
              const SizedBox(height: AppSpacing.md),

              // Trip selection dropdown
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                  border: Border.all(color: AppColors.greyLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTripId,
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Select trip'),
                    ),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    items: upcomingTrips.map((trip) {
                      return DropdownMenuItem<String>(
                        value: trip.id,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            trip.title,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (tripId) {
                      setState(() {
                        _selectedTripId = tripId;
                      });
                    },
                  ),
                ),
              ),

              if (_selectedTripId != null) ...[
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _handleAddToTrip(tripService),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.berryCrush,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                    ),
                    child: const Text('Add to Selected Trip'),
                  ),
                ),
              ],
            ],

            const SizedBox(height: AppSpacing.sm),

            // Create new trip button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _handleCreateNewTrip,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create New Trip'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.berryCrush,
                  side: const BorderSide(color: AppColors.berryCrush),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Helper Methods ====================

  bool _checkIfInWishlist(WishlistService service) {
    final type = _mapToWishlistType();
    return service.isInWishlist(widget.itemId, type);
  }

  bool _checkIfOffline(OfflineSaveService service) {
    return service.isAvailableOffline(
      widget.itemId,
      widget.itemType.name,
    );
  }

  WishlistItemType _mapToWishlistType() {
    switch (widget.itemType) {
      case SaveItemType.gem:
        return WishlistItemType.gem;
      case SaveItemType.safari:
        return WishlistItemType.safari;
      case SaveItemType.route:
        return WishlistItemType.route;
    }
  }

  String _estimateSize() {
    // Simple size estimation
    switch (widget.itemType) {
      case SaveItemType.gem:
        return '~2.5 MB';
      case SaveItemType.safari:
        return '~5.0 MB';
      case SaveItemType.route:
        return '~1.5 MB';
    }
  }

  // ==================== Action Handlers ====================

  Future<void> _handleWishlistToggle(
    WishlistService service,
    bool isInWishlist,
  ) async {
    if (isInWishlist) {
      // Remove from wishlist
      final item = service.getWishlistItem(
        widget.itemId,
        _mapToWishlistType(),
      );
      if (item != null) {
        await service.removeFromWishlist(item.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Removed from wishlist')),
          );
        }
      }
    } else {
      // Add to wishlist
      setState(() => _isLoading = true);
      try {
        await _addToWishlist(service);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to wishlist')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addToWishlist(WishlistService service) async {
    final type = _mapToWishlistType();

    if (widget.itemType == SaveItemType.gem && widget.itemData is HiddenGem) {
      final gem = widget.itemData as HiddenGem;
      await service.addToWishlist(
        referenceId: gem.id,
        type: type,
        name: gem.name,
        userId: 'current_user', // TODO: Get from auth service
        description: gem.description,
        latitude: gem.latitude,
        longitude: gem.longitude,
        coverPhotoUrl: gem.photoUrls.isNotEmpty ? gem.photoUrls.first : null,
        rating: gem.rating,
      );
    } else if (widget.itemType == SaveItemType.safari &&
        widget.itemData is Map) {
      final safari = widget.itemData as Map<String, dynamic>;
      await service.addToWishlist(
        referenceId: safari['id'] ?? widget.itemId,
        type: type,
        name: safari['name'] ?? widget.itemName,
        userId: 'current_user',
        description: safari['description'],
        latitude: double.tryParse(safari['latitude']?.toString() ?? '0') ?? 0.0,
        longitude:
            double.tryParse(safari['longitude']?.toString() ?? '0') ?? 0.0,
        coverPhotoUrl:
            safari['images']?.isNotEmpty == true ? safari['images'][0] : null,
        rating: double.tryParse(safari['rating']?.toString() ?? '0') ?? 0.0,
      );
    } else if (widget.itemType == SaveItemType.route &&
        widget.itemData is app_route.Route) {
      final route = widget.itemData as app_route.Route;
      await service.addToWishlist(
        referenceId: route.id,
        type: type,
        name: route.name,
        userId: 'current_user',
        description: route.description,
        latitude: route.startPoint.latitude,
        longitude: route.startPoint.longitude,
        rating: route.rating,
      );
    }
  }

  Future<void> _handleAddToTrip(TripService service) async {
    if (_selectedTripId == null) return;

    setState(() => _isLoading = true);
    try {
      if (widget.itemType == SaveItemType.gem &&
          widget.itemData is HiddenGem) {
        await service.addGemToTrip(_selectedTripId!, widget.itemData);
      } else if (widget.itemType == SaveItemType.safari &&
          widget.itemData is Map) {
        await service.addSafariToTrip(_selectedTripId!, widget.itemData);
      } else if (widget.itemType == SaveItemType.route &&
          widget.itemData is app_route.Route) {
        await service.addRouteToTrip(_selectedTripId!, widget.itemData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to trip')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCreateNewTrip() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateTripDialog(),
    );

    if (result != null && mounted) {
      // Trip created, now add item to it
      final tripId = result['tripId'] as String;
      _selectedTripId = tripId;
      await _handleAddToTrip(context.read<TripService>());
    }
  }

  Future<void> _handleOfflineSave(
    OfflineSaveService service,
    bool isOffline,
  ) async {
    if (isOffline) {
      // Remove from offline
      await service.removeOfflineItem(widget.itemId, widget.itemType.name);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from offline storage')),
        );
      }
    } else {
      // Save for offline
      setState(() => _isLoading = true);
      try {
        if (widget.itemType == SaveItemType.gem &&
            widget.itemData is HiddenGem) {
          await service.saveGemForOffline(widget.itemData);
        } else if (widget.itemType == SaveItemType.safari &&
            widget.itemData is Map) {
          await service.saveSafariForOffline(widget.itemData);
        } else if (widget.itemType == SaveItemType.route &&
            widget.itemData is app_route.Route) {
          await service.saveRouteForOffline(widget.itemData);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saved for offline access')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
