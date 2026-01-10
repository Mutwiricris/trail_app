import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class CircularProgressRing extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;
  final Widget? child;
  final bool animate;
  final Duration animationDuration;

  const CircularProgressRing({
    super.key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 8,
    this.color = AppColors.berryCrush,
    Color? backgroundColor,
    this.child,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 800),
  }) : backgroundColor = backgroundColor ?? AppColors.greyLight;

  @override
  State<CircularProgressRing> createState() => _CircularProgressRingState();
}

class _CircularProgressRingState extends State<CircularProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CircularProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated progress ring
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _CircularProgressPainter(
                  progress: widget.animate ? _animation.value : widget.progress,
                  strokeWidth: widget.strokeWidth,
                  color: widget.color,
                  backgroundColor: widget.backgroundColor,
                ),
              );
            },
          ),

          // Child widget (typically text showing percentage)
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc with gradient
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);

      final progressPaint = Paint()
        ..shader = LinearGradient(
            colors: [
              color,
              color.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2; // Start from top
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );

      // Glow effect at progress end
      if (progress < 1.0) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

        final angle = startAngle + sweepAngle;
        final glowX = center.dx + radius * math.cos(angle);
        final glowY = center.dy + radius * math.sin(angle);

        canvas.drawCircle(
          Offset(glowX, glowY),
          strokeWidth / 2,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

// Helper widget for progress ring with percentage text
class ProgressRingWithPercentage extends StatelessWidget {
  final double progress;
  final double size;
  final Color color;
  final String? label;

  const ProgressRingWithPercentage({
    super.key,
    required this.progress,
    this.size = 100,
    this.color = AppColors.berryCrush,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return CircularProgressRing(
      progress: progress,
      size: size,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (label != null) ...[
            SizedBox(height: size * 0.02),
            Text(
              label!,
              style: TextStyle(
                fontSize: size * 0.12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
