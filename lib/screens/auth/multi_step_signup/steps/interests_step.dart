import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/interest_chip.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class InterestsStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const InterestsStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<InterestsStep> createState() => _InterestsStepState();
}

class _InterestsStepState extends State<InterestsStep> {
  final List<String> _selectedInterests = [];

  final Map<String, List<Map<String, String>>> _interestCategories = {
    'wildlife & safari': [
      {'label': 'Game Drives', 'emoji': '🚙'},
      {'label': 'Wildlife Photography', 'emoji': '📷'},
      {'label': 'Bird Watching', 'emoji': '🦅'},
      {'label': 'Conservation', 'emoji': '🌿'},
    ],
    'culture & arts': [
      {'label': 'Art & Museums', 'emoji': '🎨'},
      {'label': 'Local Culture', 'emoji': '🌍'},
      {'label': 'History', 'emoji': '🏛️'},
      {'label': 'Music & Dance', 'emoji': '🎵'},
      {'label': 'Food Tours', 'emoji': '🍽️'},
      {'label': 'Local Markets', 'emoji': '🛍️'},
    ],
    'outdoor & adventure': [
      {'label': 'Hiking', 'emoji': '🥾'},
      {'label': 'Cycling', 'emoji': '🚴'},
      {'label': 'Running', 'emoji': '🏃'},
      {'label': 'Climbing', 'emoji': '🧗'},
      {'label': 'Camping', 'emoji': '⛺'},
      {'label': 'Water Sports', 'emoji': '🏄'},
      {'label': 'Diving', 'emoji': '🤿'},
    ],
    'beach & coastal': [
      {'label': 'Beach', 'emoji': '🏖️'},
      {'label': 'Snorkeling', 'emoji': '🤿'},
      {'label': 'Sailing', 'emoji': '⛵'},
      {'label': 'Surfing', 'emoji': '🏄'},
    ],
    'wellness & fitness': [
      {'label': 'Yoga', 'emoji': '🧘'},
      {'label': 'Meditation', 'emoji': '🧘‍♀️'},
      {'label': 'Fitness', 'emoji': '💪'},
      {'label': 'Spa', 'emoji': '💆'},
    ],
    'food & social': [
      {'label': 'Coffee Tours', 'emoji': '☕'},
      {'label': 'Local Cuisine', 'emoji': '🍲'},
      {'label': 'Wine Tasting', 'emoji': '🍷'},
      {'label': 'Nightlife', 'emoji': '🎉'},
    ],
    'values & beliefs': [
      {'label': 'Sustainability', 'emoji': '♻️'},
      {'label': 'Volunteering', 'emoji': '🤝'},
      {'label': 'Community Tourism', 'emoji': '👥'},
    ],
  };

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length < 10) {
          _selectedInterests.add(interest);
        }
      }
      widget.signupData.interests = List.from(_selectedInterests);
    });
  }

  void _handleNext() {
    if (_selectedInterests.isNotEmpty) {
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

              // Question
              const Text(
                'what do you like to do?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: 'pick up to 10 interests for your profile. ',
                    ),
                    TextSpan(
                      text: 'we\'ll also use these to generate nearby activity suggestions for you',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Interests grid
              Expanded(
                child: ListView(
                  children: _interestCategories.entries.map((category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category title
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            category.key,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),

                        // Interest chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: category.value.map((interest) {
                            return InterestChip(
                              label: interest['label']!,
                              emoji: interest['emoji'],
                              isSelected:
                                  _selectedInterests.contains(interest['label']),
                              onTap: () => _toggleInterest(interest['label']!),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),

              // Selection counter and next button
              Row(
                children: [
                  Text(
                    '${_selectedInterests.length}/10 selected',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 12),

              SignupButton(
                text: 'next',
                onPressed: _handleNext,
                isEnabled: _selectedInterests.isNotEmpty,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
