import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Fullscreen story viewer with Instagram-like UI
class StoryViewerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> stories;
  final int initialIndex;

  const StoryViewerScreen({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentStoryIndex;
  late AnimationController _progressController;
  Timer? _storyTimer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentStoryIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentStoryIndex);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _startStoryProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _storyTimer?.cancel();
    super.dispose();
  }

  void _startStoryProgress() {
    _progressController.reset();
    _progressController.forward();

    _storyTimer?.cancel();
    _storyTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !_isPaused) {
        _nextStory();
      }
    });
  }

  void _pauseStory() {
    setState(() => _isPaused = true);
    _progressController.stop();
    _storyTimer?.cancel();
  }

  void _resumeStory() {
    setState(() => _isPaused = false);
    _progressController.forward();

    final remaining = (1 - _progressController.value) * 5000;
    _storyTimer?.cancel();
    _storyTimer = Timer(Duration(milliseconds: remaining.toInt()), () {
      if (mounted && !_isPaused) {
        _nextStory();
      }
    });
  }

  void _nextStory() {
    if (_currentStoryIndex < widget.stories.length - 1) {
      setState(() => _currentStoryIndex++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryProgress();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() => _currentStoryIndex--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 2) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        onLongPressStart: (_) => _pauseStory(),
        onLongPressEnd: (_) => _resumeStory(),
        child: Stack(
          children: [
            // Story content
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              onPageChanged: (index) {
                setState(() => _currentStoryIndex = index);
              },
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                return _buildStoryContent(story);
              },
            ),

            // Progress bars
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 8,
              right: 8,
              child: Row(
                children: List.generate(
                  widget.stories.length,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: index == _currentStoryIndex
                            ? _progressController.value
                            : index < _currentStoryIndex
                                ? 1.0
                                : 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Top gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // User info
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.berryCrush,
                    child: Text(
                      (widget.stories[_currentStoryIndex]['username'] ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stories[_currentStoryIndex]['username'] ?? 'Unknown',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.stories[_currentStoryIndex]['timestamp'] ?? '1h ago',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Bottom gradient and caption
            if (widget.stories[_currentStoryIndex]['caption'] != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    40,
                    20,
                    MediaQuery.of(context).padding.bottom + 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Text(
                    widget.stories[_currentStoryIndex]['caption'] ?? '',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryContent(Map<String, dynamic> story) {
    if (story['type'] == 'image' || story['image'] != null) {
      return Image.network(
        story['image'] ?? 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.textPrimary,
            child: Center(
              child: Icon(
                Icons.broken_image,
                size: 80,
                color: AppColors.white.withValues(alpha: 0.5),
              ),
            ),
          );
        },
      );
    }

    return Container(
      color: AppColors.textPrimary,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            story['text'] ?? story['caption'] ?? 'Story',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
