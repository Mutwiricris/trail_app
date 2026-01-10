import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Full-screen photo viewer with swipe navigation
class PhotoViewerScreen extends StatefulWidget {
  final List<String> photoPaths;
  final int initialIndex;

  const PhotoViewerScreen({
    super.key,
    required this.photoPaths,
    this.initialIndex = 0,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  Future<void> _sharePhoto() async {
    try {
      final currentPhoto = widget.photoPaths[_currentIndex];
      await Share.shareXFiles(
        [XFile(currentPhoto)],
        text: 'Check out my ZuriTrails photo!',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to share photo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      extendBodyBehindAppBar: true,
      appBar: _showControls
          ? AppBar(
              backgroundColor: AppColors.black.withValues(alpha: 0.5),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppColors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share, color: AppColors.white),
                  onPressed: _sharePhoto,
                ),
              ],
            )
          : null,
      body: Stack(
        children: [
          // Photo PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photoPaths.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _toggleControls,
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Center(
                    child: Image.file(
                      File(widget.photoPaths[index]),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                color: AppColors.white,
                                size: 64,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Failed to load photo',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),

          // Photo counter
          if (_showControls && widget.photoPaths.length > 1)
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.photoPaths.length}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

          // Photo indicators
          if (_showControls && widget.photoPaths.length > 1)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.photoPaths.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentIndex
                          ? AppColors.white
                          : AppColors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
