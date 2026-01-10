import 'package:flutter/material.dart';

/// ZuriTrails Design System - Border Radius
/// Consistent corner rounding throughout the app
class AppRadius {
  // ==================== RADIUS VALUES ====================
  /// Small radius - 8px
  /// Usage: Small buttons, chips
  static const double small = 8.0;

  /// Medium radius - 12px
  /// Usage: Cards, buttons, inputs (default)
  static const double medium = 12.0;

  /// Large radius - 16px
  /// Usage: Large cards, bottom sheets
  static const double large = 16.0;

  /// Extra large radius - 20px
  /// Usage: Modals, special containers
  static const double xlarge = 20.0;

  /// Circle - 999px (effectively circular)
  /// Usage: Avatars, circular buttons
  static const double circle = 999.0;

  // ==================== BORDER RADIUS OBJECTS ====================
  /// Small BorderRadius
  static BorderRadius get smallRadius => BorderRadius.circular(small);

  /// Medium BorderRadius (default for most components)
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);

  /// Large BorderRadius
  static BorderRadius get largeRadius => BorderRadius.circular(large);

  /// Extra Large BorderRadius
  static BorderRadius get xlargeRadius => BorderRadius.circular(xlarge);

  /// Circular BorderRadius
  static BorderRadius get circularRadius => BorderRadius.circular(circle);

  // ==================== SPECIALIZED RADIUS ====================
  /// Top-only radius for bottom sheets
  static BorderRadius topOnly(double radius) => BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );

  /// Bottom-only radius
  static BorderRadius bottomOnly(double radius) => BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );

  /// Left-only radius
  static BorderRadius leftOnly(double radius) => BorderRadius.only(
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      );

  /// Right-only radius
  static BorderRadius rightOnly(double radius) => BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
}
