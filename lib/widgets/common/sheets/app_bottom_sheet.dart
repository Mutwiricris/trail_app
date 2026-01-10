import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/utils/app_radius.dart';

/// Custom bottom sheet with consistent styling
class AppBottomSheet {
  /// Show a simple bottom sheet with title and content
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadius.topOnly(AppRadius.xlarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.md),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  title,
                  style: AppTypography.headline(),
                ),
              ),
              const Divider(height: 1),
            ],

            // Content
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show a list bottom sheet
  static Future<T?> showList<T>({
    required BuildContext context,
    String? title,
    required List<AppBottomSheetItem<T>> items,
  }) {
    return show<T>(
      context: context,
      title: title,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: item.icon != null
                ? Icon(item.icon, color: item.iconColor ?? AppColors.textPrimary)
                : null,
            title: Text(
              item.title,
              style: AppTypography.bodyLarge(),
            ),
            subtitle: item.subtitle != null
                ? Text(
                    item.subtitle!,
                    style: AppTypography.caption(),
                  )
                : null,
            trailing: item.trailing,
            onTap: () {
              Navigator.pop(context, item.value);
              item.onTap?.call();
            },
          );
        },
      ),
    );
  }

  /// Show a confirmation bottom sheet
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    IconData? icon,
  }) {
    return show<bool>(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 48,
              color: confirmColor ?? AppColors.berryCrush,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            title,
            style: AppTypography.headline(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTypography.bodyMedium(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(cancelText),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: confirmColor != null
                      ? ElevatedButton.styleFrom(
                          backgroundColor: confirmColor,
                        )
                      : null,
                  child: Text(confirmText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet list item model
class AppBottomSheetItem<T> {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final T value;
  final VoidCallback? onTap;

  AppBottomSheetItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
    required this.value,
    this.onTap,
  });
}
