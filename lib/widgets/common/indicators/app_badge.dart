import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Badge types
enum BadgeType {
  primary,
  success,
  warning,
  error,
  info,
  neutral,
}

/// App badge for status indicators, counts, and labels
class AppBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final IconData? icon;
  final bool small;

  const AppBadge({
    super.key,
    required this.text,
    this.type = BadgeType.primary,
    this.icon,
    this.small = false,
  });

  Color get _backgroundColor {
    switch (type) {
      case BadgeType.primary:
        return AppColors.berryCrushLight;
      case BadgeType.success:
        return AppColors.success.withValues(alpha: 0.1);
      case BadgeType.warning:
        return AppColors.warning.withValues(alpha: 0.1);
      case BadgeType.error:
        return AppColors.error.withValues(alpha: 0.1);
      case BadgeType.info:
        return AppColors.info.withValues(alpha: 0.1);
      case BadgeType.neutral:
        return AppColors.surface;
    }
  }

  Color get _textColor {
    switch (type) {
      case BadgeType.primary:
        return AppColors.berryCrushDark;
      case BadgeType.success:
        return AppColors.success;
      case BadgeType.warning:
        return AppColors.warning;
      case BadgeType.error:
        return AppColors.error;
      case BadgeType.info:
        return AppColors.info;
      case BadgeType.neutral:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? AppSpacing.sm : AppSpacing.md,
        vertical: small ? AppSpacing.xs / 2 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(small ? 10 : 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: small ? 12 : 16,
              color: _textColor,
            ),
            SizedBox(width: small ? AppSpacing.xs / 2 : AppSpacing.xs),
          ],
          Text(
            text,
            style: small
                ? AppTypography.caption(
                    color: _textColor,
                    fontWeight: FontWeight.w600,
                  )
                : AppTypography.buttonMedium(color: _textColor),
          ),
        ],
      ),
    );
  }
}

/// Achievement badge with icon
class AchievementBadge extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final bool isLocked;
  final VoidCallback? onTap;

  const AchievementBadge({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    this.isLocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isLocked
              ? AppColors.surface
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLocked ? AppColors.greyLight : AppColors.berryCrushLight,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isLocked
                    ? AppColors.greyLight
                    : (iconColor ?? AppColors.berryCrush)
                        .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: isLocked
                    ? AppColors.grey
                    : (iconColor ?? AppColors.berryCrush),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTypography.caption(
                color: isLocked ? AppColors.textLight : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Notification badge (red dot)
class NotificationBadge extends StatelessWidget {
  final int? count;
  final bool showDot;

  const NotificationBadge({
    super.key,
    this.count,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    if (count == null && !showDot) return const SizedBox.shrink();

    return Container(
      padding: count != null
          ? const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            )
          : null,
      constraints: count != null
          ? const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            )
          : const BoxConstraints(
              minWidth: 8,
              minHeight: 8,
            ),
      decoration: const BoxDecoration(
        color: AppColors.error,
        shape: BoxShape.circle,
      ),
      child: count != null
          ? Center(
              child: Text(
                count! > 99 ? '99+' : count.toString(),
                style: AppTypography.caption(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }
}
