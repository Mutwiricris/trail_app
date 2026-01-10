import 'package:flutter/material.dart';

/// ZuriTrails Design System - Color Palette
/// Updated to align with Phase 1 implementation specs
class AppColors {
  // ==================== PRIMARY BRAND COLORS ====================
  /// Primary brand color - Used for buttons, highlights, badges, CTAs
  static const Color berryCrush = Color(0xFFD63384);

  /// Light variant of Berry Crush - Hover states, backgrounds
  static const Color berryCrushLight = Color(0xFFF5C6D6);

  /// Dark variant of Berry Crush - Pressed states, shadows
  static const Color berryCrushDark = Color(0xFFA52766);

  // ==================== NEUTRAL COLORS ====================
  /// Pure white - Cards, surfaces, text on dark backgrounds
  static const Color white = Color(0xFFFFFFFF);

  /// Beige background - Main app background
  static const Color beige = Color(0xFFFAF8F5);

  /// Light surface - Card backgrounds
  static const Color surface = Color(0xFFF5F5F5);

  /// Light grey - Borders, dividers
  static const Color greyLight = Color(0xFFE0E0E0);

  /// Medium grey - Icons, secondary elements
  static const Color grey = Color(0xFF9E9E9E);

  /// Dark grey - Disabled states
  static const Color greyDark = Color(0xFF757575);

  /// Black - Overlays, shadows
  static const Color black = Color(0xFF000000);

  // ==================== TEXT COLORS ====================
  /// Primary text color - Headings, body text
  static const Color textPrimary = Color(0xFF212121);

  /// Secondary text color - Subtitles, captions
  static const Color textSecondary = Color(0xFF757575);

  /// Light text - Hints, disabled text
  static const Color textLight = Color(0xFF9E9E9E);

  /// Text on accent backgrounds
  static const Color textOnAccent = white;

  // ==================== SEMANTIC COLORS ====================
  /// Success state - Completed, confirmed
  static const Color success = Color(0xFF4CAF50);

  /// Warning state - Caution, pending
  static const Color warning = Color(0xFFFF9800);

  /// Error state - Failed, danger
  static const Color error = Color(0xFFF44336);

  /// Info state - Information, tips
  static const Color info = Color(0xFF2196F3);

  // ==================== BACKGROUND COLORS ====================
  /// Main app background
  static const Color background = beige;

  /// Card and surface background
  static const Color surfaceWhite = white;

  // ==================== SHADOWS & OVERLAYS ====================
  /// Light shadow - Cards
  static Color shadowLight = black.withValues(alpha: 0.05);

  /// Medium shadow - Elevated elements
  static Color shadowMedium = black.withValues(alpha: 0.1);

  /// Dark shadow - Modals, dialogs
  static Color shadowDark = black.withValues(alpha: 0.15);

  /// Overlay - Behind modals
  static Color overlay = black.withValues(alpha: 0.4);

  /// Light overlay - Disabled states
  static Color overlayLight = black.withValues(alpha: 0.2);

  // ==================== SPECIAL PURPOSE COLORS ====================
  /// Streak flame color
  static const Color streakFlame = berryCrush;

  /// Achievement gold
  static const Color achievementGold = Color(0xFFFFD700);

  /// Verified badge blue
  static const Color verifiedBlue = Color(0xFF1DA1F2);

  /// Nature category green
  static const Color categoryNature = Color(0xFF66BB6A);

  /// Culture category purple
  static const Color categoryCulture = Color(0xFF9C27B0);

  /// Adventure category orange
  static const Color categoryAdventure = Color(0xFFFF7043);
}
