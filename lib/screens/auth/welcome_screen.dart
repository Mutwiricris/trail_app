import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Welcome screen shown after successful signup
/// Features confetti animation and introduction to the app
class WelcomeScreen extends StatefulWidget {
  final String? userName;

  const WelcomeScreen({
    super.key,
    this.userName,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize confetti controller
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Start animations
    _animationController.forward();

    // Start confetti after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // down
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.berryCrush,
                AppColors.warning,
                AppColors.achievementGold,
                AppColors.info,
                AppColors.categoryNature,
              ],
              numberOfParticles: 30,
              gravity: 0.3,
              emissionFrequency: 0.05,
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // Welcome icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.berryCrush.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.celebration,
                          size: 60,
                          color: AppColors.berryCrush,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Welcome text
                      Text(
                        widget.userName != null
                            ? 'Welcome, ${widget.userName}!'
                            : 'Welcome to ZuriTrails!',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Your adventure begins now',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.berryCrush,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 48),

                      // Feature highlights
                      _buildFeatureItem(
                        Icons.explore,
                        'Discover Hidden Gems',
                        'Find secret spots and local favorites',
                      ),

                      const SizedBox(height: 24),

                      _buildFeatureItem(
                        Icons.route,
                        'Track Your Journeys',
                        'Record every adventure and create memories',
                      ),

                      const SizedBox(height: 24),

                      _buildFeatureItem(
                        Icons.photo_camera,
                        'Capture Moments',
                        'Share your experiences with the community',
                      ),

                      const SizedBox(height: 24),

                      _buildFeatureItem(
                        Icons.emoji_events,
                        'Earn Achievements',
                        'Unlock badges as you explore more',
                      ),

                      const Spacer(),

                      // Motivational quote
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.beige.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              '"The world is a book, and those who do not travel read only one page."',
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '- Saint Augustine',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Explore button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            context.go('/explore');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.berryCrush,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: AppColors.berryCrush.withOpacity(0.4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Start Exploring',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.berryCrush.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
