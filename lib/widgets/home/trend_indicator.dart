import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class TrendIndicator extends StatefulWidget {
  final String trend; // e.g., "+24%", "-5%"
  final bool isRising;

  const TrendIndicator({
    super.key,
    required this.trend,
    required this.isRising,
  });

  @override
  State<TrendIndicator> createState() => _TrendIndicatorState();
}

class _TrendIndicatorState extends State<TrendIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -8.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -8.0, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.forward();

    // Repeat animation every 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isRising ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated arrow
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: Icon(
                  widget.isRising ? Icons.trending_up : Icons.trending_down,
                  size: 14,
                  color: AppColors.white,
                ),
              );
            },
          ),
          const SizedBox(width: 4),
          // Trend percentage
          Text(
            widget.trend,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Animated flame icon for hot/trending items
class FlameIndicator extends StatefulWidget {
  final double size;

  const FlameIndicator({
    super.key,
    this.size = 20,
  });

  @override
  State<FlameIndicator> createState() => _FlameIndicatorState();
}

class _FlameIndicatorState extends State<FlameIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              Icons.local_fire_department,
              size: widget.size,
              color: AppColors.error,
            ),
          ),
        );
      },
    );
  }
}
