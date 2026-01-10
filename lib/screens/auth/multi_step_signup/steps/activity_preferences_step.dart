import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/selection_option.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class ActivityPreferencesStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const ActivityPreferencesStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<ActivityPreferencesStep> createState() =>
      _ActivityPreferencesStepState();
}

class _ActivityPreferencesStepState extends State<ActivityPreferencesStep> {
  final List<String> _selectedActivities = [];
  bool _allActivitiesSelected = false;

  final List<Map<String, String>> _activityTypes = [
    {'label': 'Safari & Wildlife', 'emoji': '🦁'},
    {'label': 'Food & Drinks', 'emoji': '🍽️'},
    {'label': 'Nightlife', 'emoji': '🎉'},
    {'label': 'Outdoor & Active', 'emoji': '🥾'},
    {'label': 'Sightseeing', 'emoji': '🗺️'},
    {'label': 'Culture & Arts', 'emoji': '🎨'},
    {'label': 'Beach & Water', 'emoji': '🏖️'},
    {'label': 'Wellness', 'emoji': '🧘'},
  ];

  void _toggleActivity(String activity) {
    setState(() {
      if (activity == 'All activities') {
        _allActivitiesSelected = !_allActivitiesSelected;
        if (_allActivitiesSelected) {
          _selectedActivities.clear();
        }
      } else {
        _allActivitiesSelected = false;
        if (_selectedActivities.contains(activity)) {
          _selectedActivities.remove(activity);
        } else {
          _selectedActivities.add(activity);
        }
      }

      widget.signupData.activityPreferences = _allActivitiesSelected
          ? ['All activities']
          : List.from(_selectedActivities);
    });
  }

  void _handleNext() {
    if (_allActivitiesSelected || _selectedActivities.isNotEmpty) {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.berryCrush.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tune,
                  color: AppColors.berryCrush,
                  size: 28,
                ),
              ),

              const SizedBox(height: 24),

              // Question
              const Text(
                'what activities interest you?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'we\'ll notify you when travelers nearby want to do these',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // All activities option
              SelectionOption(
                label: 'All activities',
                emoji: '✨',
                description: 'Get notified about everything',
                isSelected: _allActivitiesSelected,
                onTap: () => _toggleActivity('All activities'),
              ),

              const SizedBox(height: 16),

              // Divider text
              Center(
                child: Text(
                  'or pick specific types',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Activity types list
              Expanded(
                child: ListView.builder(
                  itemCount: _activityTypes.length,
                  itemBuilder: (context, index) {
                    final activity = _activityTypes[index];
                    return SelectionOption(
                      label: activity['label']!,
                      emoji: activity['emoji'],
                      isSelected: !_allActivitiesSelected &&
                          _selectedActivities.contains(activity['label']),
                      onTap: () => _toggleActivity(activity['label']!),
                    );
                  },
                ),
              ),

              // Helper text
              Text(
                'you can change this anytime in settings',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 16),

              // Continue button
              SignupButton(
                text: 'continue',
                onPressed: _handleNext,
                isEnabled: _allActivitiesSelected || _selectedActivities.isNotEmpty,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
