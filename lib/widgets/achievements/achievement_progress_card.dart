import 'package:flutter/material.dart';
import 'package:zuritrails/models/achievement.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Card showing achievement progress
class AchievementProgressCard extends StatelessWidget {
  final Achievement achievement;
  final int currentProgress;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const AchievementProgressCard({
    super.key,
    required this.achievement,
    required this.currentProgress,
    required this.isUnlocked,
    this.onTap,
  });

  double get progress {
    if (isUnlocked) return 1.0;
    if (achievement.requiredCount == 0) return 0.0;
    return (currentProgress / achievement.requiredCount).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isUnlocked
              ? AppColors.white
              : AppColors.greyLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? achievement.rarityColor.withValues(alpha: 0.3)
                : AppColors.greyLight,
            width: 1.5,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: achievement.rarityColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: isUnlocked
                    ? LinearGradient(
                        colors: [
                          achievement.rarityColor,
                          achievement.rarityColor.withValues(alpha: 0.6),
                        ],
                      )
                    : null,
                color: isUnlocked ? null : AppColors.greyLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: TextStyle(
                    fontSize: 30,
                    color: isUnlocked ? null : AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnlocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: achievement.rarityColor
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+${achievement.xpReward}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: achievement.rarityColor,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    achievement.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (!isUnlocked) ...[
                    const SizedBox(height: AppSpacing.sm),

                    // Progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: AppColors.greyLight.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation(
                              achievement.rarityColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$currentProgress / ${achievement.requiredCount}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            if (isUnlocked)
              Icon(
                Icons.check_circle,
                color: achievement.rarityColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Compact achievement badge for display in lists
class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final double size;
  final bool showTooltip;

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.size = 48,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            achievement.rarityColor,
            achievement.rarityColor.withValues(alpha: 0.7),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: achievement.rarityColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          achievement.icon,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );

    if (!showTooltip) return badge;

    return Tooltip(
      message: achievement.name,
      child: badge,
    );
  }
}
