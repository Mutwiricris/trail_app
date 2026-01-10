import 'package:flutter/material.dart';
import 'package:zuritrails/models/activity_data.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Step 2: Choose specific activity type
class ActivityTypeStep extends StatefulWidget {
  final ActivityData activityData;
  final VoidCallback onNext;

  const ActivityTypeStep({
    super.key,
    required this.activityData,
    required this.onNext,
  });

  @override
  State<ActivityTypeStep> createState() => _ActivityTypeStepState();
}

class _ActivityTypeStepState extends State<ActivityTypeStep> {
  String? _selectedType;

  final List<Map<String, dynamic>> _types = [
    {
      'id': 'food_drinks',
      'name': 'Food & Drinks',
      'emoji': '🍴',
      'description': 'Restaurants, cafes, bars',
    },
    {
      'id': 'nightlife',
      'name': 'Nightlife',
      'emoji': '🎉',
      'description': 'Clubs, parties, events',
    },
    {
      'id': 'outdoor',
      'name': 'Outdoor & Active',
      'emoji': '🥾',
      'description': 'Hiking, sports, fitness',
    },
    {
      'id': 'sightseeing',
      'name': 'Sightseeing',
      'emoji': '🗺️',
      'description': 'Tours, landmarks, exploring',
    },
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
  ];

  void _selectType(String typeId) {
    setState(() {
      _selectedType = typeId;
    });
    widget.activityData.type = typeId;
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

            // Close button and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.black),
                  ),
                  const Expanded(
                    child: Text(
                      'What type?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Types grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _types.length,
                  itemBuilder: (context, index) {
                    final type = _types[index];
                    final isSelected = _selectedType == type['id'];

                    return GestureDetector(
                      onTap: () => _selectType(type['id']),
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
                              type['emoji'],
                              style: const TextStyle(fontSize: 40),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              type['name'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.berryCrush
                                    : AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                type['description'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
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

            // Next button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedType != null ? widget.onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.berryCrush,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
