import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Modern tips and recommendations card
///
/// Features:
/// - Glassmorphism effect
/// - Icon-based tips
/// - Category grouping
/// - Modern visual design
class TipsCard extends StatelessWidget {
  final String title;
  final List<TipItem> tips;
  final IconData? headerIcon;
  final Color? accentColor;

  const TipsCard({
    super.key,
    required this.title,
    required this.tips,
    this.headerIcon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (tips.isEmpty) return const SizedBox.shrink();

    final color = accentColor ?? AppColors.info;

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
          Row(
            children: [
              if (headerIcon != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.2),
                        color.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Icon(
                    headerIcon,
                    size: 24,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...tips.map((tip) => _buildTipItem(tip, color)),
        ],
      ),
    );
  }

  Widget _buildTipItem(TipItem tip, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tip.isImportant
            ? color.withValues(alpha: 0.05)
            : AppColors.beige.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: tip.isImportant
            ? Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tip.isImportant
                  ? color.withValues(alpha: 0.15)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(
              tip.icon,
              size: 20,
              color: tip.isImportant ? color : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tip.isImportant ? color : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.description,
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
    );
  }
}

/// Data class for tip items
class TipItem {
  final String title;
  final String description;
  final IconData icon;
  final bool isImportant;

  const TipItem({
    required this.title,
    required this.description,
    required this.icon,
    this.isImportant = false,
  });
}

/// Getting There widget with transport options
class GettingThereCard extends StatelessWidget {
  final List<TransportOption> options;
  final String? parkingInfo;
  final String? publicTransportInfo;

  const GettingThereCard({
    super.key,
    required this.options,
    this.parkingInfo,
    this.publicTransportInfo,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.info.withValues(alpha: 0.2),
                      AppColors.info.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: const Icon(
                  Icons.directions_car,
                  size: 24,
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Getting There',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...options.map((option) => _buildTransportOption(option)),
          if (parkingInfo != null) ...[
            const SizedBox(height: 16),
            _buildInfoBox(
              Icons.local_parking,
              'Parking',
              parkingInfo!,
              AppColors.success,
            ),
          ],
          if (publicTransportInfo != null) ...[
            const SizedBox(height: 16),
            _buildInfoBox(
              Icons.directions_bus,
              'Public Transport',
              publicTransportInfo!,
              AppColors.warning,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransportOption(TransportOption option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: AppColors.greyLight.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: option.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(
              option.icon,
              size: 24,
              color: option.color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.method,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  option.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (option.duration != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        option.duration!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(
      IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
    );
  }
}

/// Transport option data class
class TransportOption {
  final String method;
  final String description;
  final IconData icon;
  final Color color;
  final String? duration;

  const TransportOption({
    required this.method,
    required this.description,
    required this.icon,
    this.color = AppColors.info,
    this.duration,
  });
}
