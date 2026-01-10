import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';

/// Enhanced image gallery with thumbnail navigation
///
/// Features:
/// - Main PageView carousel with auto-scroll (4 seconds)
/// - Horizontal thumbnail strip with active indicator
/// - Photo count badge
/// - Tap thumbnails to jump to images
/// - Gradient overlays for better text contrast
class EnhancedGallery extends StatefulWidget {
  /// List of image URLs to display
  final List<String> images;

  /// Height of the main image carousel (default: 400)
  final double height;

  /// Whether to enable auto-scrolling (default: true)
  final bool autoScroll;

  /// Auto-scroll interval in seconds (default: 4)
  final int autoScrollSeconds;

  /// Whether to show the thumbnail strip (default: true)
  final bool showThumbnails;

  /// Whether to show the photo count badge (default: true)
  final bool showPhotoCount;

  /// Whether to show gradient overlay (default: true)
  final bool showGradient;

  const EnhancedGallery({
    super.key,
    required this.images,
    this.height = 300,
    this.autoScroll = true,
    this.autoScrollSeconds = 4,
    this.showThumbnails = true,
    this.showPhotoCount = true,
    this.showGradient = true,
  });

  @override
  State<EnhancedGallery> createState() => _EnhancedGalleryState();
}

class _EnhancedGalleryState extends State<EnhancedGallery> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    if (widget.autoScroll && widget.images.length > 1) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(
      Duration(seconds: widget.autoScrollSeconds),
      (timer) {
        if (!mounted) return;

        final nextPage = (_currentIndex + 1) % widget.images.length;

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  void _jumpToImage(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no images, show placeholder
    if (widget.images.isEmpty) {
      return _buildPlaceholder();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available height for main image
        // Reserve space for thumbnail strip if shown
        final thumbnailHeight = (widget.showThumbnails && widget.images.length > 1) ? 50.0 : 0.0;
        final mainImageHeight = constraints.maxHeight - thumbnailHeight;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Image Carousel
            SizedBox(
              height: mainImageHeight.clamp(200.0, widget.height),
              child: Stack(
                fit: StackFit.expand,
                children: [
              // PageView for images
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return _buildImage(widget.images[index]);
                },
              ),

              // Gradient overlay
              if (widget.showGradient)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.black.withOpacity(0.3),
                          AppColors.black.withOpacity(0.7),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

              // Photo count badge
              if (widget.showPhotoCount && widget.images.length > 1)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(AppRadius.xlarge),
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${widget.images.length}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Page indicators (dots) - only show if no thumbnails
              if (!widget.showThumbnails && widget.images.length > 1)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: _buildDotIndicators(),
                ),
            ],
          ),
        ),

            // Thumbnail strip
            if (widget.showThumbnails && widget.images.length > 1)
              Container(
                height: 50,
                color: AppColors.black.withOpacity(0.05),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return _buildThumbnail(index);
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.beige.withOpacity(0.3),
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.berryCrush),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.berryCrush.withOpacity(0.3),
                AppColors.beige.withOpacity(0.5),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThumbnail(int index) {
    final isActive = index == _currentIndex;

    return GestureDetector(
      onTap: () => _jumpToImage(index),
      child: Container(
        width: 45,
        height: 45,
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive ? AppColors.berryCrush : AppColors.greyLight,
            width: isActive ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.small - 1),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.beige,
                    child: const Icon(
                      Icons.image_outlined,
                      size: 24,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
              if (!isActive)
                Container(
                  color: AppColors.white.withOpacity(0.4),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.images.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: _currentIndex == index
                ? LinearGradient(
                    colors: [
                      AppColors.berryCrush,
                      AppColors.berryCrushLight,
                    ],
                  )
                : null,
            color: _currentIndex == index ? null : AppColors.greyLight,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.berryCrush.withOpacity(0.2),
            AppColors.beige.withOpacity(0.4),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No images available',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
