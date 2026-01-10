import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/selection_option.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class GenderStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const GenderStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<GenderStep> createState() => _GenderStepState();
}

class _GenderStepState extends State<GenderStep> {
  String? _selectedGender;

  final List<Map<String, dynamic>> _genders = [
    {'label': 'Male', 'icon': Icons.male},
    {'label': 'Female', 'icon': Icons.female},
    {'label': 'Non-binary', 'icon': Icons.transgender},
  ];

  void _handleSelection(String gender) {
    setState(() {
      _selectedGender = gender;
      widget.signupData.gender = gender;
    });
  }

  void _handleNext() {
    if (_selectedGender != null) {
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
                "what's your gender?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'for your profile',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 40),

              // Options
              ...List.generate(_genders.length, (index) {
                final gender = _genders[index];
                return SelectionOption(
                  label: gender['label'],
                  icon: gender['icon'],
                  isSelected: _selectedGender == gender['label'],
                  onTap: () => _handleSelection(gender['label']),
                );
              }),

              const Spacer(),

              // Next button
              SignupButton(
                text: 'next',
                onPressed: _handleNext,
                isEnabled: _selectedGender != null,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
