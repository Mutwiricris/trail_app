import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Single stat item model
class StatItem {
  final String value;
  final String label;
  final IconData? icon;
  final Color? valueColor;
  final VoidCallback? onTap;

  StatItem({
    required this.value,
    required this.label,
    this.icon,
    this.valueColor,
    this.onTap,
  });
}

/// Stats grid widget - displays statistics in a grid layout
/// Used in profile, journey summary, and achievement screens
class StatsGrid extends StatelessWidget {
  final List<StatItem> stats;
  final int crossAxisCount;
  final double spacing;
  final double runSpacing;

  const StatsGrid({
    super.key,
    required this.stats,
    this.crossAxisCount = 3,
    this.spacing = AppSpacing.md,
    this.runSpacing = AppSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: 1.0,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return _StatCard(stat: stats[index]);
      },
    );
  }
}

/// Single stat card
class _StatCard extends StatelessWidget {
  final StatItem stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: stat.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.greyLight,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (stat.icon != null) ...[
                Icon(
                  stat.icon,
                  color: stat.valueColor ?? AppColors.berryCrush,
                  size: 24,
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              Text(
                stat.value,
                style: AppTypography.numberMedium(
                  color: stat.valueColor ?? AppColors.berryCrush,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs / 2),
              Text(
                stat.label,
                style: AppTypography.caption(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal stats row - for compact stat display
class StatsRow extends StatelessWidget {
  final List<StatItem> stats;
  final double spacing;

  const StatsRow({
    super.key,
    required this.stats,
    this.spacing = AppSpacing.lg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: stats.map((stat) {
        return Expanded(
          child: _StatColumn(stat: stat),
        );
      }).toList(),
    );
  }
}

/// Vertical stat column for horizontal row
class _StatColumn extends StatelessWidget {
  final StatItem stat;

  const _StatColumn({required this.stat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: stat.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (stat.icon != null) ...[
            Icon(
              stat.icon,
              color: stat.valueColor ?? AppColors.berryCrush,
              size: 20,
            ),
            const SizedBox(height: AppSpacing.xs / 2),
          ],
          Text(
            stat.value,
            style: AppTypography.numberMedium(
              color: stat.valueColor ?? AppColors.berryCrush,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs / 2),
          Text(
            stat.label,
            style: AppTypography.caption(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
