import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/utils/app_elevation.dart';

/// Modern highlights grid widget
///
/// Features:
/// - 2-column grid layout
/// - Icon-based highlights
/// - Elevated cards with shadows
/// - Category-based colors
class HighlightsGrid extends StatelessWidget {
  final String title;
  final List<HighlightItem> highlights;
  final bool showTitle;

  const HighlightsGrid({
    super.key,
    this.title = 'Highlights',
    required this.highlights,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) return const SizedBox.shrink();

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
            const SizedBox(height: 20),
          ],
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: highlights.length,
            itemBuilder: (context, index) {
              return _buildHighlightCard(highlights[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard(HighlightItem highlight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppElevation.lowShadow,
        border: Border.all(
          color: highlight.color.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  highlight.color.withValues(alpha: 0.2),
                  highlight.color.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(
              highlight.icon,
              size: 28,
              color: highlight.color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            highlight.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (highlight.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              highlight.subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Highlight item data class
class HighlightItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const HighlightItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.color = AppColors.berryCrush,
  });

  factory HighlightItem.fromString(String text) {
    // Auto-detect icon and color based on keywords
    final lowerText = text.toLowerCase();

    IconData icon;
    Color color;

    if (lowerText.contains('wildlife') || lowerText.contains('animal')) {
      icon = Icons.pets;
      color = AppColors.success;
    } else if (lowerText.contains('view') || lowerText.contains('scenery')) {
      icon = Icons.landscape;
      color = AppColors.info;
    } else if (lowerText.contains('photo') || lowerText.contains('camera')) {
      icon = Icons.camera_alt;
      color = AppColors.warning;
    } else if (lowerText.contains('guide') || lowerText.contains('expert')) {
      icon = Icons.person;
      color = AppColors.berryCrush;
    } else if (lowerText.contains('luxury') || lowerText.contains('comfort')) {
      icon = Icons.hotel;
      color = AppColors.warning;
    } else if (lowerText.contains('adventure') || lowerText.contains('thrill')) {
      icon = Icons.terrain;
      color = AppColors.error;
    } else if (lowerText.contains('culture') || lowerText.contains('traditional')) {
      icon = Icons.museum;
      color = AppColors.info;
    } else if (lowerText.contains('food') || lowerText.contains('meal')) {
      icon = Icons.restaurant;
      color = AppColors.warning;
    } else {
      icon = Icons.check_circle;
      color = AppColors.success;
    }

    return HighlightItem(
      title: text,
      icon: icon,
      color: color,
    );
  }
}

/// Quick Stats widget for showing key metrics
class QuickStatsCard extends StatelessWidget {
  final List<StatItem> stats;
  final Color? accentColor;

  const QuickStatsCard({
    super.key,
    required this.stats,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) return const SizedBox.shrink();

    final color = accentColor ?? AppColors.berryCrush;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((stat) => _buildStat(stat, color)).toList(),
      ),
    );
  }

  Widget _buildStat(StatItem stat, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            stat.icon,
            size: 28,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Stat item data class
class StatItem {
  final String value;
  final String label;
  final IconData icon;

  const StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });
}
