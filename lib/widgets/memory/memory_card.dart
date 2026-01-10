import 'package:flutter/material.dart';
import 'package:zuritrails/models/memory.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Modern memory card with gradient overlay for "On This Day" feature
class MemoryCard extends StatelessWidget {
  final Memory memory;
  final VoidCallback? onTap;
  final VoidCallback? onShare;

  const MemoryCard({
    super.key,
    required this.memory,
    this.onTap,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay and time badge
            Stack(
              children: [
                // Main image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: memory.photoUrl != null
                      ? Image.network(
                          memory.photoUrl!,
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        )
                      : _buildPlaceholderImage(),
                ),

                // Gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.black.withValues(alpha: 0.6),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                ),

                // Time ago badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.berryCrush,
                          AppColors.berryCrushDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.berryCrush.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.history,
                          size: 16,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          memory.timeAgoText,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Share button
                if (onShare != null)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share_outlined),
                        iconSize: 20,
                        color: AppColors.textPrimary,
                        onPressed: onShare,
                      ),
                    ),
                  ),

                // Title at bottom of image
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memory.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(memory.originalDate),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (memory.description != null &&
                      memory.description!.isNotEmpty) ...[
                    Text(
                      memory.description!,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Stats row
                  _buildStatsRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.beige,
            AppColors.berryCrushLight.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.landscape,
          size: 64,
          color: AppColors.berryCrush.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = memory.stats;
    final items = <Widget>[];

    // Distance
    if (stats.containsKey('distance') && stats['distance'] != null) {
      items.add(_StatItem(
        icon: Icons.directions_walk,
        label: '${stats['distance'].toStringAsFixed(1)} km',
        color: AppColors.berryCrush,
      ));
    }

    // Duration
    if (stats.containsKey('duration') && stats['duration'] != null) {
      final minutes = stats['duration'] as int;
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      final durationText =
          hours > 0 ? '${hours}h ${mins}m' : '${mins}m';

      items.add(_StatItem(
        icon: Icons.timer_outlined,
        label: durationText,
        color: AppColors.success,
      ));
    }

    // Places
    if (stats.containsKey('places') && stats['places'] != null) {
      items.add(_StatItem(
        icon: Icons.location_on,
        label: '${stats['places']} places',
        color: AppColors.warning,
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items,
    );
  }

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Stat item chip
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
