import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'app_radius.dart';

/// ZuriTrails Design System - Theme Configuration
/// Complete Material 3 theme following design specifications
class AppTheme {
  /// Light theme - primary app theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // ==================== COLOR SCHEME ====================
      colorScheme: ColorScheme.light(
        primary: AppColors.berryCrush,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.berryCrushLight,
        onPrimaryContainer: AppColors.berryCrushDark,
        secondary: AppColors.berryCrushLight,
        onSecondary: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surface,
        outline: AppColors.greyLight,
      ),

      // ==================== SCAFFOLD ====================
      scaffoldBackgroundColor: AppColors.background,

      // ==================== APP BAR ====================
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headline(),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // ==================== TEXT THEME ====================
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge(),
        displayMedium: AppTypography.displayMedium(),
        displaySmall: AppTypography.displaySmall(),
        headlineMedium: AppTypography.headline(),
        bodyLarge: AppTypography.bodyLarge(),
        bodyMedium: AppTypography.bodyMedium(),
        labelLarge: AppTypography.buttonLarge(),
        labelMedium: AppTypography.label(),
        bodySmall: AppTypography.caption(),
      ),

      // ==================== ELEVATED BUTTON ====================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.berryCrush,
          foregroundColor: AppColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingH,
            vertical: AppSpacing.buttonPaddingV,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mediumRadius,
          ),
          textStyle: AppTypography.buttonLarge(),
        ),
      ),

      // ==================== OUTLINED BUTTON ====================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(
            color: AppColors.greyLight,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingH,
            vertical: AppSpacing.buttonPaddingV,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mediumRadius,
          ),
          textStyle: AppTypography.buttonLarge(color: AppColors.textPrimary),
        ),
      ),

      // ==================== TEXT BUTTON ====================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.berryCrush,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonMedium(color: AppColors.berryCrush),
        ),
      ),

      // ==================== FLOATING ACTION BUTTON ====================
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.berryCrush,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // ==================== INPUT DECORATION ====================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPaddingH,
          vertical: AppSpacing.inputPaddingV,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.greyLight,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.greyLight,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.berryCrush,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        labelStyle: AppTypography.label(),
        hintStyle: AppTypography.bodyMedium(color: AppColors.textLight),
        errorStyle: AppTypography.caption(color: AppColors.error),
      ),

      // ==================== CARD ====================
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mediumRadius,
          side: const BorderSide(
            color: AppColors.greyLight,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // ==================== CHIP ====================
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.berryCrushLight,
        disabledColor: AppColors.greyLight,
        labelStyle: AppTypography.buttonMedium(color: AppColors.textPrimary),
        secondaryLabelStyle: AppTypography.buttonMedium(color: AppColors.white),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.chipPaddingH,
          vertical: AppSpacing.chipPaddingV,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.circle),
        ),
        side: const BorderSide(color: AppColors.greyLight, width: 1),
      ),

      // ==================== BOTTOM SHEET ====================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.topOnly(AppRadius.xlarge),
        ),
        elevation: 8,
        modalBackgroundColor: AppColors.white,
        modalElevation: 8,
      ),

      // ==================== DIALOG ====================
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.largeRadius,
        ),
        titleTextStyle: AppTypography.headline(),
        contentTextStyle: AppTypography.bodyMedium(),
      ),

      // ==================== SNACK BAR ====================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTypography.bodyMedium(color: AppColors.white),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mediumRadius,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // ==================== BOTTOM NAVIGATION BAR ====================
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.berryCrush,
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: AppTypography.caption(
          color: AppColors.berryCrush,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.caption(color: AppColors.grey),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ==================== DIVIDER ====================
      dividerTheme: const DividerThemeData(
        color: AppColors.greyLight,
        thickness: 1,
        space: 1,
      ),

      // ==================== ICON ====================
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),

      // ==================== PROGRESS INDICATOR ====================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.berryCrush,
        linearTrackColor: AppColors.greyLight,
        circularTrackColor: AppColors.greyLight,
      ),

      // ==================== SWITCH ====================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.berryCrush;
          }
          return AppColors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.berryCrushLight;
          }
          return AppColors.greyLight;
        }),
      ),

      // ==================== CHECKBOX ====================
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.berryCrush;
          }
          return AppColors.white;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.small / 2),
        ),
      ),

      // ==================== RADIO ====================
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.berryCrush;
          }
          return AppColors.grey;
        }),
      ),
    );
  }

  /// System UI overlay style for light theme
  static SystemUiOverlayStyle get systemUiOverlayStyle {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }
}
