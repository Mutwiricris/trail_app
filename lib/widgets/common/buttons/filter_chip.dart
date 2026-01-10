import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Custom filter chip for category selection
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.berryCrush : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.berryCrush : AppColors.greyLight,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTypography.buttonMedium(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable filter chips
class FilterChipList extends StatelessWidget {
  final List<FilterChipItem> items;
  final String? selectedValue;
  final ValueChanged<String> onChanged;
  final EdgeInsets? padding;

  const FilterChipList({
    super.key,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: items.map((item) {
          final isSelected = selectedValue == item.value;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: AppFilterChip(
              label: item.label,
              icon: item.icon,
              isSelected: isSelected,
              onTap: () => onChanged(item.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Filter chip item model
class FilterChipItem {
  final String label;
  final String value;
  final IconData? icon;

  FilterChipItem({
    required this.label,
    required this.value,
    this.icon,
  });
}
