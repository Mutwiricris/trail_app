import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class InterestChip extends StatelessWidget {
  final String label;
  final String? emoji;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const InterestChip({
    super.key,
    required this.label,
    this.emoji,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.berryCrush : AppColors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null)
              Text(
                emoji!,
                style: const TextStyle(fontSize: 20),
              )
            else if (icon != null)
              Icon(
                icon,
                color: isSelected ? AppColors.berryCrush : AppColors.grey,
                size: 20,
              ),
            if (emoji != null || icon != null) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.berryCrush : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
