import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/selection_option.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class TravelStyleStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const TravelStyleStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<TravelStyleStep> createState() => _TravelStyleStepState();
}

class _TravelStyleStepState extends State<TravelStyleStep> {
  final List<String> _selectedStyles = [];

  final List<Map<String, String>> _travelStyles = [
    {
      'label': 'Safari Enthusiast',
      'description': 'Exploring wildlife and national parks',
      'emoji': '🦁',
    },
    {
      'label': 'Beach Lover',
      'description': 'Relaxing by the coast and ocean activities',
      'emoji': '🏖️',
    },
    {
      'label': 'Cultural Explorer',
      'description': 'Discovering local culture and heritage',
      'emoji': '🎨',
    },
    {
      'label': 'Adventure Seeker',
      'description': 'Hiking, climbing, and outdoor activities',
      'emoji': '🏔️',
    },
    {
      'label': 'Business Traveler',
      'description': 'Working while traveling in Kenya',
      'emoji': '💼',
    },
    {
      'label': 'Local Host',
      'description': 'Local who wants to meet travelers',
      'emoji': '🏠',
    },
  ];

  void _toggleStyle(String style) {
    setState(() {
      if (_selectedStyles.contains(style)) {
        _selectedStyles.remove(style);
      } else {
        if (_selectedStyles.length < 2) {
          _selectedStyles.add(style);
        }
      }
      widget.signupData.travelStyles = List.from(_selectedStyles);
    });
  }

  void _handleNext() {
    if (_selectedStyles.isNotEmpty) {
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
                "what's your travel style?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'select up to 2 that best describe you',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 32),

              // Options list
              Expanded(
                child: ListView.builder(
                  itemCount: _travelStyles.length,
                  itemBuilder: (context, index) {
                    final style = _travelStyles[index];
                    return SelectionOption(
                      label: style['label']!,
                      description: style['description'],
                      emoji: style['emoji'],
                      isSelected: _selectedStyles.contains(style['label']),
                      onTap: () => _toggleStyle(style['label']!),
                    );
                  },
                ),
              ),

              // Next button
              SignupButton(
                text: 'next',
                onPressed: _handleNext,
                isEnabled: _selectedStyles.isNotEmpty,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
