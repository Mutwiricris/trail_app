import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Weather information card widget
///
/// Features:
/// - Current weather display
/// - Monthly temperature chart
/// - Best season badges
/// - Rainfall information
/// - Mock data support
class WeatherCard extends StatelessWidget {
  /// Section title (default: "Weather & Best Time to Visit")
  final String title;

  /// Current temperature (e.g., "24°C")
  final String? currentTemp;

  /// Weather condition (e.g., "Partly Cloudy")
  final String? condition;

  /// Best months to visit
  final List<String>? bestMonths;

  /// Monthly average temperatures (12 values for each month)
  final List<int>? monthlyTemp;

  /// Rainfall information text
  final String? rainfallInfo;

  /// Whether to show mock data if no data provided (default: true)
  final bool useMockData;

  const WeatherCard({
    super.key,
    this.title = 'Weather & Best Time to Visit',
    this.currentTemp,
    this.condition,
    this.bestMonths,
    this.monthlyTemp,
    this.rainfallInfo,
    this.useMockData = true,
  });

  @override
  Widget build(BuildContext context) {
    // Use mock data if enabled and no data provided
    final temp = currentTemp ?? (useMockData ? '24°C' : null);
    final cond = condition ?? (useMockData ? 'Partly Cloudy' : null);
    final months = bestMonths ??
        (useMockData
            ? ['June', 'July', 'August', 'September']
            : <String>[]);
    final temps = monthlyTemp ??
        (useMockData
            ? [22, 23, 24, 25, 26, 27, 28, 27, 26, 24, 23, 22]
            : <int>[]);
    final rainfall = rainfallInfo ??
        (useMockData ? 'Low rainfall Jun-Sept, High Apr-May' : null);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // Current weather (if available)
          if (temp != null || cond != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.beige.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Row(
                children: [
                  Icon(
                    _getWeatherIcon(cond),
                    size: 44,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (temp != null)
                          Text(
                            temp,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        if (cond != null)
                          Text(
                            cond,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Monthly temperature chart
          if (temps.isNotEmpty) ...[
            const Text(
              'Average Monthly Temperature',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildTemperatureChart(temps),
            const SizedBox(height: 24),
          ],

          // Best months badges
          if (months.isNotEmpty) ...[
            const Text(
              'Best Months to Visit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: months.map((month) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.xlarge),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    month,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Rainfall info
          if (rainfall != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    size: 20,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rainfall',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rainfall,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTemperatureChart(List<int> temps) {
    if (temps.length != 12) {
      return const Text(
        'Invalid temperature data',
        style: TextStyle(color: AppColors.error),
      );
    }

    final monthLabels = [
      'J',
      'F',
      'M',
      'A',
      'M',
      'J',
      'J',
      'A',
      'S',
      'O',
      'N',
      'D'
    ];
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final range = maxTemp - minTemp;

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(12, (index) {
          final temp = temps[index];
          final normalizedHeight =
              range > 0 ? ((temp - minTemp) / range) * 60 + 15 : 40.0;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Temperature value
                  Text(
                    '${temp}°',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Bar
                  Container(
                    height: normalizedHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.warning,
                          AppColors.warning.withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Month label
                  Text(
                    monthLabels[index],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return Icons.wb_sunny;

    final cond = condition.toLowerCase();
    if (cond.contains('sunny') || cond.contains('clear')) {
      return Icons.wb_sunny;
    } else if (cond.contains('cloud')) {
      return Icons.wb_cloudy;
    } else if (cond.contains('rain')) {
      return Icons.water_drop;
    } else if (cond.contains('storm')) {
      return Icons.thunderstorm;
    } else {
      return Icons.wb_sunny;
    }
  }
}
