import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/screens/auth/auth_entry_screen.dart';
import 'package:zuritrails/widgets/onboarding/animated_onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      imageUrl: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
      title: 'Explore Kenya\'s best destinations',
      description: 'From safaris to hidden gems, discover verified experiences hosted by local experts and trusted operators.',
    ),
    OnboardingPageData(
      imageUrl: 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
      title: 'Book unique stays and adventures',
      description: 'Find lodges, cottages, and beach resorts. Read reviews from real travelers and reserve with confidence.',
    ),
    OnboardingPageData(
      imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
      title: 'Travel with peace of mind',
      description: 'Every listing is verified. Get instant confirmations, flexible dates, and support whenever you need it.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    HapticFeedback.lightImpact();
  }

  void _navigateToAuth() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthEntryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // PageView with animated pages
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return AnimatedOnboardingPage(
                  data: _pages[index],
                  pageController: _pageController,
                  index: index,
                );
              },
            ),

            // Bottom controls
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.white
                                : AppColors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action buttons
                    Row(
                      children: [
                        // Skip/Sign in button
                        Expanded(
                          child: TextButton(
                            onPressed: _navigateToAuth,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: AppColors.white.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Next/Get Started button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (isLastPage) {
                                _navigateToAuth();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOutCubic,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.berryCrush,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              isLastPage ? 'Get started' : 'Next',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

