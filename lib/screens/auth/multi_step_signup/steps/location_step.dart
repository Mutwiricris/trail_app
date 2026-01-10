import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class LocationStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const LocationStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
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
                  Icons.explore,
                  size: 50,
                  color: AppColors.berryCrush,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'connect with nearby travelers',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              const Text(
                'enable location to discover nearby activities and let other travelers see you\'re in the area',
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
                icon: Icons.location_on,
                title: 'Discover nearby activities',
                description:
                    'Find and join spontaneous meetups and activities happening near you',
              ),

              const SizedBox(height: 24),

              _BenefitItem(
                icon: Icons.people,
                title: 'Appear to nearby travelers',
                description:
                    'Other travelers in your area can see you\'re nearby and reach out to connect',
              ),

              const SizedBox(height: 24),

              _BenefitItem(
                icon: Icons.security,
                title: 'Your privacy is protected',
                description:
                    'Your exact location is never shown—only your approximate area',
              ),

              const Spacer(),

              // Enable button
              SignupButton(
                text: 'enable & continue',
                onPressed: () {
                  widget.signupData.locationEnabled = true;
                  widget.onNext();
                },
              ),

              const SizedBox(height: 16),

              // Not now button with outline style
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    widget.signupData.locationEnabled = false;
                    widget.onNext();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.grey,
                    side: BorderSide(
                      color: AppColors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'not now',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Helper text
              Text(
                'you can still use some features if you choose "not now". you can change this anytime in settings',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                  height: 1.4,
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
