import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class SelectionOption extends StatelessWidget {
  final String label;
  final String? description;
  final IconData? icon;
  final String? emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionOption({
    super.key,
    required this.label,
    this.description,
    this.icon,
    this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.berryCrush : AppColors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (emoji != null)
              Text(
                emoji!,
                style: const TextStyle(fontSize: 24),
              )
            else if (icon != null)
              Icon(
                icon,
                color: isSelected ? AppColors.berryCrush : AppColors.grey,
                size: 24,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.black : AppColors.grey.withOpacity(0.8),
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey.withOpacity(0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.berryCrush,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
