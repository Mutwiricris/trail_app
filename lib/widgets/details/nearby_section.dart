import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Nearby attractions widget showing horizontal scrollable list
///
/// Features:
/// - Horizontal ListView with snap scrolling
/// - Distance badges
/// - Category icons
/// - Tap to navigate
/// - Compact card layout
class NearbySectionWidget extends StatelessWidget {
  /// Section title (default: "Nearby Attractions")
  final String title;

  /// List of nearby places
  final List<NearbyPlace> places;

  /// Callback when a place is tapped
  final Function(NearbyPlace)? onPlaceTap;

  /// Whether to show the section title (default: true)
  final bool showTitle;

  const NearbySectionWidget({
    super.key,
    this.title = 'Nearby Attractions',
    required this.places,
    this.onPlaceTap,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: places.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildPlaceCard(context, places[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(BuildContext context, NearbyPlace place) {
    return GestureDetector(
      onTap: () => onPlaceTap?.call(place),
      child: Container(
        width: 200,
        margin: EdgeInsets.only(
          right: AppSpacing.md,
          left: place == places.first ? 0 : 0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.network(
                place.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.berryCrush.withValues(alpha: 0.3),
                          AppColors.beige.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                    child: Icon(
                      place.categoryIcon ?? Icons.place,
                      size: 48,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.beige.withValues(alpha: 0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.berryCrush),
                      ),
                    ),
                  );
                },
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.black.withValues(alpha: 0.4),
                        AppColors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Distance badge (top-right)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(AppRadius.xlarge),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.navigation,
                        size: 12,
                        color: AppColors.berryCrush,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.distance,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Category icon (top-left)
              if (place.categoryIcon != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(place.category)
                          .withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      place.categoryIcon,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),

              // Place info (bottom)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (place.category != null)
                        Text(
                          place.category!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
  }

  Color _getCategoryColor(String? category) {
    if (category == null) return AppColors.berryCrush;

    switch (category.toLowerCase()) {
      case 'nature':
      case 'viewpoint':
        return AppColors.success;
      case 'culture':
      case 'cultural':
        return AppColors.info;
      case 'food':
      case 'restaurant':
        return AppColors.warning;
      case 'adventure':
      case 'activity':
        return AppColors.error;
      default:
        return AppColors.berryCrush;
    }
  }
}

/// Data class for nearby places
class NearbyPlace {
  final String name;
  final String distance;
  final String imageUrl;
  final String? category;
  final IconData? categoryIcon;
  final Map<String, dynamic>? data;

  const NearbyPlace({
    required this.name,
    required this.distance,
    required this.imageUrl,
    this.category,
    this.categoryIcon,
    this.data,
  });

  /// Create from Map
  factory NearbyPlace.fromMap(Map<String, dynamic> map) {
    return NearbyPlace(
      name: map['name'] ?? '',
      distance: map['distance'] ?? '',
      imageUrl: map['image'] ?? map['imageUrl'] ?? '',
      category: map['category'] ?? map['type'],
      categoryIcon: _getIconFromCategory(map['category'] ?? map['type']),
      data: map,
    );
  }

  static IconData? _getIconFromCategory(String? category) {
    if (category == null) return Icons.place;

    switch (category.toLowerCase()) {
      case 'nature':
        return Icons.nature;
      case 'viewpoint':
        return Icons.landscape;
      case 'culture':
      case 'cultural':
        return Icons.museum;
      case 'food':
      case 'restaurant':
        return Icons.restaurant;
      case 'adventure':
      case 'activity':
        return Icons.hiking;
      default:
        return Icons.place;
    }
  }
}
