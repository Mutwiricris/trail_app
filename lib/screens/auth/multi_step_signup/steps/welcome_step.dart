import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomeStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Logo
              Text(
                'ZuriTrails',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  letterSpacing: -0.5,
                ),
              ),

              const Spacer(),

              // Main heading
              Text(
                'discover Kenya and connect with travelers wherever you go',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 40),

              // Activity icons grid
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _ActivityIcon(emoji: '🦁', label: 'Safari'),
                  _ActivityIcon(emoji: '🏖️', label: 'Beach'),
                  _ActivityIcon(emoji: '🎨', label: 'Culture'),
                  _ActivityIcon(emoji: '🏔️', label: 'Adventure'),
                  _ActivityIcon(emoji: '☕', label: 'Local'),
                  _ActivityIcon(emoji: '📸', label: 'Tours'),
                ],
              ),

              const Spacer(),

              // CTA button
              SignupButton(
                text: "i'm in!",
                onPressed: onNext,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  final String emoji;
  final String label;

  const _ActivityIcon({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 36),
            ),
          ),
        ),
      ],
    );
  }
}
