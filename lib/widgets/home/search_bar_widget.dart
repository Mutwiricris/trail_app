import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String? hintText;

  const SearchBarWidget({
    super.key,
    required this.onTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.beige.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.greyLight.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hintText ?? 'Search safaris, parks, destinations...',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.tune,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
