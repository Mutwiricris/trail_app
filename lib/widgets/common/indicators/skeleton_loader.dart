import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Skeleton loader for loading states
/// Provides shimmering effect while content loads
class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  /// Circle skeleton (for avatars)
  const SkeletonLoader.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = const BorderRadius.all(Radius.circular(999));

  /// Rectangular skeleton (for images)
  const SkeletonLoader.rect({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
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
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? AppRadius.smallRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                AppColors.surface,
                AppColors.greyLight,
                AppColors.surface,
              ],
              stops: [
                _animation.value - 1,
                _animation.value,
                _animation.value + 1,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// Card skeleton for list loading states
class SkeletonCard extends StatelessWidget {
  final bool showImage;
  final int lineCount;

  const SkeletonCard({
    super.key,
    this.showImage = true,
    this.lineCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showImage) ...[
            const SkeletonLoader.rect(
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const SkeletonLoader(width: 120, height: 20),
          const SizedBox(height: AppSpacing.sm),
          ...List.generate(
            lineCount,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: SkeletonLoader(
                width: index == lineCount - 1 ? 200 : double.infinity,
                height: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Feed item skeleton
class SkeletonFeedItem extends StatelessWidget {
  const SkeletonFeedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const SkeletonLoader.circle(size: 40),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonLoader(width: 120, height: 16),
                    SizedBox(height: AppSpacing.xs),
                    SkeletonLoader(width: 80, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Content
          const SkeletonLoader(width: double.infinity, height: 14),
          const SizedBox(height: AppSpacing.sm),
          const SkeletonLoader(width: 200, height: 14),
          const SizedBox(height: AppSpacing.md),

          // Image
          const SkeletonLoader.rect(
            width: double.infinity,
            height: 200,
          ),
        ],
      ),
    );
  }
}

/// List of skeleton loaders
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;

  const SkeletonList({
    super.key,
    this.itemCount = 3,
    required this.itemBuilder,
  });

  const SkeletonList.cards({
    super.key,
    this.itemCount = 3,
  }) : itemBuilder = _defaultCardBuilder;

  const SkeletonList.feedItems({
    super.key,
    this.itemCount = 3,
  }) : itemBuilder = _defaultFeedBuilder;

  static Widget _defaultCardBuilder(int index) => const SkeletonCard();
  static Widget _defaultFeedBuilder(int index) => const SkeletonFeedItem();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }
}
