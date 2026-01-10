import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuritrails/utils/app_colors.dart';

class StoryAvatar extends StatefulWidget {
  final String username;
  final String avatarUrl;
  final String location;
  final bool hasStory;
  final bool viewed;
  final double progress; // 0.0 to 1.0
  final VoidCallback onTap;

  const StoryAvatar({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.location,
    this.hasStory = false,
    this.viewed = false,
    this.progress = 0.0,
    required this.onTap,
  });

  @override
  State<StoryAvatar> createState() => _StoryAvatarState();
}

class _StoryAvatarState extends State<StoryAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar with progress ring
            SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated pulse effect for new stories
                  if (widget.hasStory && !widget.viewed)
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.berryCrush.withValues(alpha: 0.3),
                                  AppColors.berryCrushLight.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  // Progress ring
                  if (widget.hasStory)
                    CustomPaint(
                      size: const Size(70, 70),
                      painter: _ProgressRingPainter(
                        progress: widget.progress,
                        viewed: widget.viewed,
                      ),
                    ),

                  // Avatar
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        widget.avatarUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColors.beige.withValues(alpha: 0.5),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: AppColors.berryCrush,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.beige,
                            child: Icon(
                              Icons.person,
                              color: AppColors.textSecondary,
                              size: 32,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Live indicator for active stories
                  if (widget.hasStory && !widget.viewed && widget.progress == 0.0)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withValues(alpha: 0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // Username
            SizedBox(
              width: 70,
              child: Text(
                widget.username,
                style: TextStyle(
                  fontSize: 10,
                  color: widget.viewed ? AppColors.textSecondary : AppColors.textPrimary,
                  fontWeight: widget.viewed ? FontWeight.w500 : FontWeight.w600,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Location (if provided)
            if (widget.location.isNotEmpty) ...[
              const SizedBox(height: 1),
              SizedBox(
                width: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 8,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 1),
                    Flexible(
                      child: Text(
                        widget.location,
                        style: TextStyle(
                          fontSize: 8,
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final bool viewed;

  _ProgressRingPainter({
    required this.progress,
    required this.viewed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 3.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = viewed
          ? AppColors.greyLight
          : AppColors.beige.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = viewed
            ? null
            : LinearGradient(
                colors: [
                  AppColors.berryCrush,
                  AppColors.berryCrushLight,
                ],
              ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..color = viewed ? AppColors.textSecondary : Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2; // Start from top
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.viewed != viewed;
  }
}
