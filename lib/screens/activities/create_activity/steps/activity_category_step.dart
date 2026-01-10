import 'package:flutter/material.dart';
import 'package:zuritrails/models/activity_data.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Step 1: Choose activity category
class ActivityCategoryStep extends StatefulWidget {
  final ActivityData activityData;
  final VoidCallback onNext;

  const ActivityCategoryStep({
    super.key,
    required this.activityData,
    required this.onNext,
  });

  @override
  State<ActivityCategoryStep> createState() => _ActivityCategoryStepState();
}

class _ActivityCategoryStepState extends State<ActivityCategoryStep> {
  String? _selectedCategory;

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'entertainment',
      'name': 'Entertainment',
      'emoji': '🎭',
      'description': 'Movies, shows, museums',
    },
    {
      'id': 'shopping',
      'name': 'Shopping',
      'emoji': '🛍️',
      'description': 'Markets, malls, boutiques',
    },
    {
      'id': 'wellness',
      'name': 'Wellness',
      'emoji': '🧘',
      'description': 'Yoga, spa, meditation',
    },
    {
      'id': 'rideshare',
      'name': 'Rideshare',
      'emoji': '🚗',
      'description': 'Split rides, carpools',
    },
    {
      'id': 'social',
      'name': 'Social',
      'emoji': '💬',
      'description': 'Hangout, chat, meet up',
    },
    {
      'id': 'other',
      'name': 'Other',
      'emoji': '✨',
      'description': 'Something else',
    },
  ];

  void _selectCategory(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
    });
    widget.activityData.category = categoryId;

    // Auto-advance after selection
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        widget.onNext();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header with drag handle
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: AppColors.black),
              ),
            ),

            // Category grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category['id'];

                    return GestureDetector(
                      onTap: () => _selectCategory(category['id']),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.berryCrush.withOpacity(0.1)
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.berryCrush
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category['emoji'],
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              category['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.berryCrush
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                category['description'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
