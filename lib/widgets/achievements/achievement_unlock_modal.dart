import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:zuritrails/models/achievement.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Modal that appears when an achievement is unlocked
class AchievementUnlockModal extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onDismiss;

  const AchievementUnlockModal({
    super.key,
    required this.achievement,
    this.onDismiss,
  });

  /// Show the achievement unlock modal
  static Future<void> show(
    BuildContext context,
    Achievement achievement,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AchievementUnlockModal(
        achievement: achievement,
      ),
    );
  }

  @override
  State<AchievementUnlockModal> createState() => _AchievementUnlockModalState();
}

class _AchievementUnlockModalState extends State<AchievementUnlockModal>
    with SingleTickerProviderStateMixin {
  late final ConfettiController _confettiController;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start animations
    _animationController.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    Navigator.of(context).pop();
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.2,
              shouldLoop: false,
              colors: const [
                AppColors.berryCrush,
                AppColors.success,
                AppColors.warning,
                AppColors.info,
              ],
            ),
          ),

          // Achievement Card
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      '🎉 Achievement Unlocked!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Achievement Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.achievement.rarityColor,
                            widget.achievement.rarityColor.withValues(alpha: 0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.achievement.rarityColor
                                .withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.achievement.icon,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Achievement Name
                    Text(
                      widget.achievement.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // Rarity Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.achievement.rarityColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.achievement.rarityColor,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        widget.achievement.rarity.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: widget.achievement.rarityColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Description
                    Text(
                      widget.achievement.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // XP Reward
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.berryCrush,
                            AppColors.berryCrushDark,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.stars,
                            color: AppColors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '+${widget.achievement.xpReward} XP',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _dismiss,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.berryCrush,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Awesome!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
