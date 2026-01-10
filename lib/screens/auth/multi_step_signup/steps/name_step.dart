import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class NameStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const NameStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<NameStep> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.signupData.firstName != null) {
      _nameController.text = widget.signupData.firstName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_nameController.text.trim().isNotEmpty) {
      widget.signupData.firstName = _nameController.text.trim();
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
                "what's your name?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                "let's get to know each other",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 8),

              // Helper text
              Text(
                'this will appear on your profile and can\'t be changed later',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 40),

              // Name input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Your name',
                    hintStyle: TextStyle(color: AppColors.grey),
                  ),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _handleNext();
                    }
                  },
                ),
              ),

              const Spacer(),

              // Next button
              SignupButton(
                text: 'next',
                onPressed: _handleNext,
                isEnabled: _nameController.text.trim().isNotEmpty,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
