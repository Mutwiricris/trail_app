import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_elevation.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Elevated info card with icon, label, and value
///
/// Features:
/// - Elevated card with shadow
/// - Icon in colored circle background
/// - Label and value layout
/// - Optional tap action
/// - Consistent styling across detail pages
class InfoCard extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Label text (e.g., "Duration", "Difficulty")
  final String label;

  /// Value text (e.g., "3-4 hours", "Moderate")
  final String value;

  /// Icon color (default: berryCrush)
  final Color? iconColor;

  /// Icon background color (default: berryCrush with 10% opacity)
  final Color? iconBackgroundColor;

  /// Optional tap callback
  final VoidCallback? onTap;

  /// Card background color (default: white)
  final Color? backgroundColor;

  /// Whether to use compact layout (smaller padding)
  final bool compact;

  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.iconBackgroundColor,
    this.onTap,
    this.backgroundColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.berryCrush;
    final effectiveIconBgColor =
        iconBackgroundColor ?? AppColors.berryCrush.withOpacity(0.1);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppElevation.lowShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Padding(
            padding: compact
                ? const EdgeInsets.all(AppSpacing.sm)
                : const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: compact ? 32 : 32,
                  height: compact ? 32 : 32,
                  decoration: BoxDecoration(
                    color: effectiveIconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: compact ? 16 : 16,
                    color: effectiveIconColor,
                  ),
                ),

                SizedBox(height: compact ? 6 : 4),

                // Value (main text)
                Text(
                  value,
                  style: TextStyle(
                    fontSize: compact ? 14 : 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                // Label (secondary text)
                Text(
                  label,
                  style: TextStyle(
                    fontSize: compact ? 10 : 11,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal info card layout (icon on left, text on right)
///
/// Alternative layout for when you need a horizontal orientation
class InfoCardHorizontal extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Label text
  final String label;

  /// Value text
  final String value;

  /// Icon color (default: berryCrush)
  final Color? iconColor;

  /// Icon background color (default: berryCrush with 10% opacity)
  final Color? iconBackgroundColor;

  /// Optional tap callback
  final VoidCallback? onTap;

  /// Card background color (default: white)
  final Color? backgroundColor;

  const InfoCardHorizontal({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.iconBackgroundColor,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.berryCrush;
    final effectiveIconBgColor =
        iconBackgroundColor ?? AppColors.berryCrush.withOpacity(0.1);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppElevation.lowShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
                    color: effectiveIconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: effectiveIconColor,
                  ),
                ),

                const SizedBox(width: 16),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid of info cards
///
/// Convenience widget to display info cards in a responsive grid
class InfoCardGrid extends StatelessWidget {
  /// List of info card data
  final List<InfoCardData> cards;

  /// Number of columns (default: 2)
  final int crossAxisCount;

  /// Spacing between cards (default: 12)
  final double spacing;

  /// Whether to use compact card layout
  final bool compact;

  const InfoCardGrid({
    super.key,
    required this.cards,
    this.crossAxisCount = 2,
    this.spacing = 12,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: compact ? 2.8 : 1.2,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final data = cards[index];
        return InfoCard(
          icon: data.icon,
          label: data.label,
          value: data.value,
          iconColor: data.iconColor,
          iconBackgroundColor: data.iconBackgroundColor,
          onTap: data.onTap,
          compact: compact,
        );
      },
    );
  }
}

/// Data class for info cards
class InfoCardData {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final VoidCallback? onTap;

  const InfoCardData({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.iconBackgroundColor,
    this.onTap,
  });
}
