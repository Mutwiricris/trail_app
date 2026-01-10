import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zuritrails/utils/app_colors.dart';

class AnimatedNavigationButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLastPage;

  const AnimatedNavigationButton({
    super.key,
    required this.onPressed,
    required this.isLastPage,
  });

  @override
  State<AnimatedNavigationButton> createState() =>
      _AnimatedNavigationButtonState();
}

class _AnimatedNavigationButtonState extends State<AnimatedNavigationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    HapticFeedback.mediumImpact();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.berryCrush,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.berryCrush.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              widget.isLastPage ? Icons.check : Icons.arrow_forward,
              key: ValueKey<bool>(widget.isLastPage),
              color: AppColors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
