import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class ProfilePhotoStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const ProfilePhotoStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<ProfilePhotoStep> createState() => _ProfilePhotoStepState();
}

class _ProfilePhotoStepState extends State<ProfilePhotoStep> {
  String? _photoPath;

  void _addPhoto() {
    // TODO: Implement image picker
    // For now, just mark as selected
    setState(() {
      _photoPath = 'temp_path';
      widget.signupData.profilePhotoPath = _photoPath;
    });
  }

  void _handleComplete() {
    // Photo is optional, user can skip
    widget.onNext();
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
                'add a profile photo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'help others recognize you with a photo - make sure your face is visible!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              // Photo placeholder
              Center(
                child: GestureDetector(
                  onTap: _addPhoto,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.grey.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: _photoPath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 48,
                                color: AppColors.grey.withOpacity(0.6),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'tap to add photo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.grey.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : const Icon(
                            Icons.person,
                            size: 80,
                            color: AppColors.berryCrush,
                          ),
                  ),
                ),
              ),

              const Spacer(),

              // Tip
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.berryCrush.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text(
                      '💡',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'tip: if upload fails, try switching between WiFi and mobile data',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Continue button
              SignupButton(
                text: _photoPath != null ? 'continue' : 'skip for now',
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
