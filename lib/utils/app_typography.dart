import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// ZuriTrails Design System - Typography
/// Text styles following the design spec hierarchy
class AppTypography {
  // Font family
  static String get _fontFamily => GoogleFonts.plusJakartaSans().fontFamily!;

  // ==================== DISPLAY STYLES ====================
  /// Display Large - 32px, Bold
  /// Usage: Page titles, hero headings
  static TextStyle displayLarge({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
        color: color ?? AppColors.textPrimary,
      );

  /// Display Medium - 28px, Bold
  /// Usage: Section headings, modal titles
  static TextStyle displayMedium({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.25,
        letterSpacing: -0.3,
        color: color ?? AppColors.textPrimary,
      );

  /// Display Small - 24px, Bold
  /// Usage: Card titles, sub-headings
  static TextStyle displaySmall({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
        letterSpacing: -0.2,
        color: color ?? AppColors.textPrimary,
      );

  // ==================== HEADLINE STYLES ====================
  /// Headline - 20px, SemiBold
  /// Usage: List titles, prominent labels
  static TextStyle headline({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color ?? AppColors.textPrimary,
      );

  // ==================== BODY STYLES ====================
  /// Body Large - 16px, Regular
  /// Usage: Primary body text, descriptions
  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w400,
        height: 1.5,
        color: color ?? AppColors.textPrimary,
      );

  /// Body Medium - 14px, Regular
  /// Usage: Secondary text, list items
  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w400,
        height: 1.5,
        color: color ?? AppColors.textSecondary,
      );

  // ==================== CAPTION STYLES ====================
  /// Caption - 12px, Regular
  /// Usage: Timestamps, hints, metadata
  static TextStyle caption({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.3,
        color: color ?? AppColors.textLight,
      );

  // ==================== BUTTON STYLES ====================
  /// Button Large - 16px, SemiBold
  /// Usage: Primary buttons, CTAs
  static TextStyle buttonLarge({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: color ?? AppColors.white,
      );

  /// Button Medium - 14px, SemiBold
  /// Usage: Secondary buttons, chips
  static TextStyle buttonMedium({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: color ?? AppColors.white,
      );

  // ==================== SPECIALIZED STYLES ====================
  /// Label - 14px, Medium
  /// Usage: Form labels, input labels
  static TextStyle label({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary,
      );

  /// Overline - 12px, SemiBold, Uppercase
  /// Usage: Category labels, badges
  static TextStyle overline({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: color ?? AppColors.textSecondary,
      ).copyWith(
        // Using copyWith to apply uppercase transformation
        fontFeatures: const [FontFeature.enable('smcp')],
      );

  /// Number Large - 32px, Bold
  /// Usage: Stats, counts, scores
  static TextStyle numberLarge({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1,
        letterSpacing: -0.5,
        color: color ?? AppColors.berryCrush,
      );

  /// Number Medium - 24px, Bold
  /// Usage: Secondary stats
  static TextStyle numberMedium({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1,
        letterSpacing: -0.3,
        color: color ?? AppColors.berryCrush,
      );
}
