import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zuritrails/models/journey.dart';
import 'package:zuritrails/screens/splash_screen.dart';
import 'package:zuritrails/screens/onboarding/onboarding_screen.dart';
import 'package:zuritrails/screens/auth/auth_entry_screen.dart';
import 'package:zuritrails/screens/main_navigation.dart';
import 'package:zuritrails/screens/journey/journey_summary_screen.dart';
import 'package:zuritrails/screens/gems/gem_details_screen.dart';
import 'package:zuritrails/screens/safaris/safari_details_screen.dart';

/// App router configuration
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthEntryScreen(),
      ),

      // Main app with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MainNavigation(initialIndex: 0),
            ),
          ),
          GoRoute(
            path: '/browse',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MainNavigation(initialIndex: 1),
            ),
          ),
          GoRoute(
            path: '/explore',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MainNavigation(initialIndex: 2),
            ),
          ),
          GoRoute(
            path: '/trips',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MainNavigation(initialIndex: 3),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MainNavigation(initialIndex: 4),
            ),
          ),
        ],
      ),

      // Journey Summary
      GoRoute(
        path: '/journey/:id',
        builder: (context, state) {
          final journey = state.extra as Journey;
          return JourneySummaryScreen(journey: journey);
        },
      ),

      // Gem Details
      GoRoute(
        path: '/gem/:id',
        builder: (context, state) {
          final gemData = state.extra as Map<String, dynamic>? ?? {
            'name': 'Hidden Gem',
            'description': 'Explore this amazing place',
            'rating': 4.5,
          };
          return GemDetailsScreen(gem: gemData);
        },
      ),

      // Safari Details
      GoRoute(
        path: '/safari/:id',
        builder: (context, state) {
          final safariData = state.extra as Map<String, dynamic>? ?? {
            'name': 'Safari Adventure',
            'description': 'Experience wildlife',
            'price': 150.0,
          };
          return SafariDetailsScreen(safari: safariData);
        },
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
