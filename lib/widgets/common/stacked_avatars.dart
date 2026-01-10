import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Displays stacked circular avatars showing visitors/users
/// Similar to social media "liked by" patterns
class StackedAvatars extends StatelessWidget {
  final List<String>? avatarUrls;
  final int totalCount;
  final double size;
  final double overlap;
  final int maxVisible;

  const StackedAvatars({
    super.key,
    this.avatarUrls,
    required this.totalCount,
    this.size = 28,
    this.overlap = 12,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (totalCount == 0) {
      return const SizedBox.shrink();
    }

    // Use provided URLs or generate mock ones
    final urls = avatarUrls ?? _generateMockAvatars();
    final displayCount = urls.length > maxVisible ? maxVisible : urls.length;
    final remaining = totalCount - displayCount;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: (size * displayCount) - (overlap * (displayCount - 1)),
          height: size,
          child: Stack(
            children: [
              // Display avatar images
              for (int i = 0; i < displayCount; i++)
                Positioned(
                  left: i * (size - overlap),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        urls[i],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.berryCrush.withOpacity(0.7),
                            child: Icon(
                              Icons.person,
                              size: size * 0.6,
                              color: AppColors.white,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColors.beige.withOpacity(0.5),
                            child: Center(
                              child: SizedBox(
                                width: size * 0.4,
                                height: size * 0.4,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.berryCrush,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (remaining > 0) ...[
          const SizedBox(width: 6),
          Text(
            '+$remaining',
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  /// Generate mock avatar URLs for demonstration
  List<String> _generateMockAvatars() {
    // Use a variety of placeholder avatar images
    final mockUrls = [
      'https://i.pravatar.cc/150?img=1',
      'https://i.pravatar.cc/150?img=2',
      'https://i.pravatar.cc/150?img=3',
      'https://i.pravatar.cc/150?img=4',
      'https://i.pravatar.cc/150?img=5',
      'https://i.pravatar.cc/150?img=6',
      'https://i.pravatar.cc/150?img=7',
      'https://i.pravatar.cc/150?img=8',
    ];

    // Shuffle and return random avatars up to maxVisible
    mockUrls.shuffle();
    return mockUrls.take(maxVisible).toList();
  }
}

/// Compact version with text label
class StackedAvatarsWithLabel extends StatelessWidget {
  final List<String>? avatarUrls;
  final int totalCount;
  final String label;
  final double size;

  const StackedAvatarsWithLabel({
    super.key,
    this.avatarUrls,
    required this.totalCount,
    this.label = 'visited',
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StackedAvatars(
            avatarUrls: avatarUrls,
            totalCount: totalCount,
            size: size,
            overlap: 10,
            maxVisible: 3,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
