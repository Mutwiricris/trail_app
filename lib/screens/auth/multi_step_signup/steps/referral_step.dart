import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/selection_option.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class ReferralStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const ReferralStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<ReferralStep> createState() => _ReferralStepState();
}

class _ReferralStepState extends State<ReferralStep> {
  String? _selectedSource;

  final List<Map<String, String>> _sources = [
    {'label': 'Instagram', 'emoji': '📷'},
    {'label': 'TikTok', 'emoji': '🎵'},
    {'label': 'YouTube', 'emoji': '▶️'},
    {'label': 'X (Twitter)', 'emoji': '𝕏'},
    {'label': 'Facebook', 'emoji': '👥'},
    {'label': 'A friend', 'emoji': '👫'},
    {'label': 'Google Search', 'emoji': '🔍'},
    {'label': 'Other', 'emoji': '🌐'},
  ];

  void _handleSelection(String source) {
    setState(() {
      _selectedSource = source;
      widget.signupData.referralSource = source;
    });
  }

  void _handleNext() {
    if (_selectedSource != null) {
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
                'how did you hear about us?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'help us understand how you found the app',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 32),

              // Options list
              Expanded(
                child: ListView.builder(
                  itemCount: _sources.length,
                  itemBuilder: (context, index) {
                    final source = _sources[index];
                    return SelectionOption(
                      label: source['label']!,
                      emoji: source['emoji'],
                      isSelected: _selectedSource == source['label'],
                      onTap: () => _handleSelection(source['label']!),
                    );
                  },
                ),
              ),

              // Next button
              SignupButton(
                text: 'next',
                onPressed: _handleNext,
                isEnabled: _selectedSource != null,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
