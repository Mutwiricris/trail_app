import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/widgets/common/stacked_avatars.dart';

class HiddenGemsCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> gems;
  final double height;
  final Function(Map<String, dynamic>)? onGemTap;

  const HiddenGemsCarousel({
    super.key,
    required this.gems,
    this.height = 340,
    this.onGemTap,
  });

  @override
  State<HiddenGemsCarousel> createState() => _HiddenGemsCarouselState();
}

class _HiddenGemsCarouselState extends State<HiddenGemsCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.88,
      initialPage: 0,
    );
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!_isPaused && mounted) {
        if (_currentPage < widget.gems.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  void _pauseAutoScroll() {
    setState(() {
      _isPaused = true;
    });

    // Resume after 10 seconds of inactivity
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isPaused = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        // Carousel
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.gems.length,
            itemBuilder: (context, index) {
              final gem = widget.gems[index];
              return _buildGemCard(gem, index);
            },
          ),
        ),

        const SizedBox(height: 16),

        // Diamond-shaped indicators
        _buildDiamondIndicators(),
      ],
    );
  }

  Widget _buildGemCard(Map<String, dynamic> gem, int index) {
    final isActive = _currentPage == index;

    return AnimatedScale(
      scale: isActive ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: GestureDetector(
          onTap: () {
            _pauseAutoScroll();
            widget.onGemTap?.call(gem);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.network(
                    gem['image'] ?? gem['imageUrl'] ?? '',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.warning.withOpacity(0.2),
                              AppColors.beige.withOpacity(0.4),
                            ],
                          ),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: AppColors.warning,
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.warning.withOpacity(0.3),
                              AppColors.beige.withOpacity(0.5),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.diamond_outlined,
                                size: 80,
                                color: AppColors.warning.withOpacity(0.6),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Hidden Gem',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Subtle gradient overlay at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Favorite button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  // Content
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Location
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  gem['location'] ?? 'Kenya',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Title
                          Text(
                            gem['title'] ?? gem['name'] ?? 'Hidden Treasure',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Rating, visitors, and operator badge
                          Row(
                            children: [
                              // Visitors with stacked avatars
                              if (gem['visitors'] != null && gem['visitors'] > 0) ...[
                                StackedAvatars(
                                  totalCount: gem['visitors'],
                                  size: 20,
                                  overlap: 8,
                                  maxVisible: 3,
                                ),
                                const SizedBox(width: 8),
                              ],
                              if (gem['rating'] != null) ...[
                                Icon(
                                  Icons.star,
                                  size: 14,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${gem['rating']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                                if (gem['reviewCount'] != null) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${gem['reviewCount']})',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ],
                              if (gem['operator'] != null && gem['operator']['verified'] == true) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '·',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.white.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    gem['operator']['badge'] ?? 'Verified',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiamondIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.gems.length,
        (index) {
          final isActive = _currentPage == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.textPrimary
                  : AppColors.textPrimary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}
