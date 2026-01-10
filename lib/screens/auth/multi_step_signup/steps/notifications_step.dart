import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class NotificationsStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const NotificationsStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<NotificationsStep> createState() => _NotificationsStepState();
}

class _NotificationsStepState extends State<NotificationsStep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.berryCrush.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active,
                  size: 50,
                  color: AppColors.berryCrush,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'enable notifications',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              const Text(
                'know when travelers want to meet up or message you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 48),

              // Benefits list
              _BenefitItem(
                icon: Icons.people,
                title: "Don't miss connections",
                description:
                    'Get notified when travelers want to meet up or message you',
              ),

              const SizedBox(height: 24),

              _BenefitItem(
                icon: Icons.location_on,
                title: 'Stay updated on nearby activities',
                description:
                    'Be informed about nearby meetups, get real-time updates on changes',
              ),

              const Spacer(),

              // Enable button
              SignupButton(
                text: 'continue',
                onPressed: () {
                  widget.signupData.notificationsEnabled = true;
                  widget.onNext();
                },
              ),

              const SizedBox(height: 16),

              // Skip button
              TextButton(
                onPressed: () {
                  widget.signupData.notificationsEnabled = false;
                  widget.onNext();
                },
                child: const Text(
                  'not now',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Helper text
              Text(
                'you can change notification settings anytime in device settings',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.berryCrush.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.berryCrush,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
