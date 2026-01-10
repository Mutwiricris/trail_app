import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class PrivacyStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onComplete;

  const PrivacyStep({
    super.key,
    required this.signupData,
    required this.onComplete,
  });

  @override
  State<PrivacyStep> createState() => _PrivacyStepState();
}

class _PrivacyStepState extends State<PrivacyStep> {
  bool _showDistance = true;

  @override
  void initState() {
    super.initState();
    _showDistance = widget.signupData.showDistanceAway;
  }

  void _handleComplete() {
    widget.signupData.showDistanceAway = _showDistance;
    widget.onComplete();
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
                  Icons.shield,
                  color: AppColors.berryCrush,
                  size: 28,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                'privacy settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'control how others can interact with you',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 40),

              // Show distance toggle
              Container(
                padding: const EdgeInsets.all(20),
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.berryCrush.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.visibility,
                        color: AppColors.berryCrush,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Show Distance Away',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Let others see how far away you are in km. Your exact location is never shared',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey.withOpacity(0.8),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                      value: _showDistance,
                      onChanged: (value) {
                        setState(() {
                          _showDistance = value;
                        });
                      },
                      activeColor: AppColors.berryCrush,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Privacy note
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.berryCrush.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.berryCrush.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.security,
                          color: AppColors.berryCrush,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Your privacy is our priority',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You can adjust these settings anytime in your profile settings. We\'ll never share your exact location or personal information without your permission.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Continue button
              SignupButton(
                text: 'create your account 🎉',
                onPressed: _handleComplete,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
