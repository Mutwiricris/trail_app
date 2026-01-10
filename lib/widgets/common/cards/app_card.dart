import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_elevation.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Base card component for consistent card styling
/// Supports different elevation levels and custom content
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final bool showBorder;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.onTap,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: borderRadius ?? AppRadius.mediumRadius,
        boxShadow: boxShadow ?? AppElevation.lowShadow,
        border: border ??
            (showBorder
                ? Border.all(color: AppColors.greyLight, width: 1)
                : null),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? AppRadius.mediumRadius,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Elevated card with medium shadow
class AppElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const AppElevatedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      boxShadow: AppElevation.mediumShadow,
      showBorder: false,
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }
}

/// Card with image header
class AppImageCard extends StatelessWidget {
  final String? imageUrl;
  final Widget? imageWidget;
  final Widget child;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onTap;
  final double imageHeight;
  final BoxFit imageFit;

  const AppImageCard({
    super.key,
    this.imageUrl,
    this.imageWidget,
    required this.child,
    this.contentPadding,
    this.onTap,
    this.imageHeight = 200,
    this.imageFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.medium),
              topRight: Radius.circular(AppRadius.medium),
            ),
            child: SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: imageWidget ??
                  (imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: imageFit,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.surface,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: AppColors.grey,
                                  size: 48,
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: AppColors.surface,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: AppColors.grey,
                              size: 48,
                            ),
                          ),
                        )),
            ),
          ),

          // Content
          Padding(
            padding: contentPadding ?? const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ],
      ),
    );
  }
}
