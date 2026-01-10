import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ZuriTrails Design System - Elevation & Shadows
/// Consistent shadow depths for Material Design elevation
class AppElevation {
  // ==================== ELEVATION VALUES ====================
  /// No elevation
  static const double none = 0.0;

  /// Low elevation - 2dp
  /// Usage: Cards, resting state
  static const double low = 2.0;

  /// Medium elevation - 4dp
  /// Usage: Floating action buttons, raised buttons
  static const double medium = 4.0;

  /// High elevation - 8dp
  /// Usage: Modals, dialogs, navigation drawer
  static const double high = 8.0;

  /// Very high elevation - 16dp
  /// Usage: Overlays, tooltips
  static const double veryHigh = 16.0;

  // ==================== BOX SHADOW PRESETS ====================
  /// Low shadow - for cards and resting elements
  static List<BoxShadow> get lowShadow => [
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  /// Medium shadow - for floating elements
  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  /// High shadow - for modals and dialogs
  static List<BoxShadow> get highShadow => [
        BoxShadow(
          color: AppColors.shadowDark,
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  /// Very high shadow - for overlays
  static List<BoxShadow> get veryHighShadow => [
        BoxShadow(
          color: AppColors.shadowDark,
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  /// Subtle glow - for focused elements
  static List<BoxShadow> get subtleGlow => [
        BoxShadow(
          color: AppColors.berryCrush.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 0),
        ),
      ];

  /// Bottom-only shadow - for app bars and navigation
  static List<BoxShadow> get bottomShadow => [
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
}
