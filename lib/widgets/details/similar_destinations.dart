import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Similar destinations/recommendations widget
///
/// Features:
/// - 2-column grid layout
/// - Image cards with overlays
/// - Rating and price display
/// - Compact information layout
/// - Tap to navigate
class SimilarDestinationsWidget extends StatelessWidget {
  /// Section title (default: "You might also like")
  final String title;

  /// List of similar destinations
  final List<SimilarDestination> destinations;

  /// Callback when a destination is tapped
  final Function(SimilarDestination)? onDestinationTap;

  /// Whether to show the section title (default: true)
  final bool showTitle;

  /// Number of columns (default: 2)
  final int crossAxisCount;

  const SimilarDestinationsWidget({
    super.key,
    this.title = 'You might also like',
    required this.destinations,
    this.onDestinationTap,
    this.showTitle = true,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24),
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              return _buildDestinationCard(destinations[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(SimilarDestination destination) {
    return GestureDetector(
      onTap: () => onDestinationTap?.call(destination),
      child: Container(
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
                destination.imageUrl,
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
                      Icons.image_outlined,
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
                        AppColors.black.withValues(alpha: 0.3),
                        AppColors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Rating badge (top-right)
              if (destination.rating != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
                          Icons.star,
                          size: 12,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          destination.rating!.toStringAsFixed(1),
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

              // Destination info (bottom)
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
                        destination.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (destination.location != null) ...[
                            const Icon(
                              Icons.location_on,
                              size: 12,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                destination.location!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      AppColors.white.withValues(alpha: 0.9),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (destination.price != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.berryCrush.withValues(alpha: 0.9),
                            borderRadius:
                                BorderRadius.circular(AppRadius.small),
                          ),
                          child: Text(
                            destination.price!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
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
}

/// Data class for similar destinations
class SimilarDestination {
  final String name;
  final String imageUrl;
  final String? location;
  final double? rating;
  final String? price;
  final String? type;
  final Map<String, dynamic>? data;

  const SimilarDestination({
    required this.name,
    required this.imageUrl,
    this.location,
    this.rating,
    this.price,
    this.type,
    this.data,
  });

  /// Create from Map
  factory SimilarDestination.fromMap(Map<String, dynamic> map) {
    return SimilarDestination(
      name: map['name'] ?? map['title'] ?? '',
      imageUrl: map['image'] ?? map['imageUrl'] ?? '',
      location: map['location'],
      rating: map['rating']?.toDouble(),
      price: map['price'],
      type: map['type'] ?? map['category'],
      data: map,
    );
  }
}
