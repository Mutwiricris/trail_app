import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Streak widget - displays current streak
class StreakWidget extends StatelessWidget {
  final int streakDays;
  final VoidCallback? onTap;

  const StreakWidget({
    super.key,
    required this.streakDays,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.warning, AppColors.warning.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 20)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '$streakDays',
              style: AppTypography.headline(color: AppColors.white),
            ),
            const SizedBox(width: AppSpacing.xs / 2),
            Text(
              'day streak',
              style: AppTypography.bodyMedium(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// Streak detail modal
Future<void> showStreakDetailModal(BuildContext context, int streakDays) async {
  await showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flame icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.warning, AppColors.warning.withValues(alpha: 0.7)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🔥', style: TextStyle(fontSize: 50)),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Streak count
            Text(
              '$streakDays',
              style: AppTypography.displayLarge(color: AppColors.warning),
            ),
            Text(
              'DAY STREAK',
              style: AppTypography.overline(),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              'Keep exploring to maintain your streak!',
              style: AppTypography.bodyMedium(),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Weekly calendar
            _WeeklyCalendar(activeDay: DateTime.now().weekday - 1),

            const SizedBox(height: AppSpacing.lg),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _WeeklyCalendar extends StatelessWidget {
  final int activeDay;

  const _WeeklyCalendar({required this.activeDay});

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final isActive = index <= activeDay;
        return Column(
          children: [
            Text(
              days[index],
              style: AppTypography.caption(),
            ),
            const SizedBox(height: 4),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive ? AppColors.success : AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: isActive
                  ? const Icon(Icons.check, size: 16, color: AppColors.white)
                  : null,
            ),
          ],
        );
      }),
    );
  }
}
