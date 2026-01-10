import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/journey.dart';
import 'package:zuritrails/services/journey_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/widgets/common/cards/app_card.dart';

/// Active journey tracking card
/// Shows live journey stats and controls
class ActiveJourneyCard extends StatelessWidget {
  final Journey journey;
  final VoidCallback? onViewDetails;

  const ActiveJourneyCard({
    super.key,
    required this.journey,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final journeyService = Provider.of<JourneyService>(context);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.berryCrushLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.medium),
                topRight: Radius.circular(AppRadius.medium),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.berryCrush,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      journey.type.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        journey.title,
                        style: AppTypography.headline(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Active Journey',
                            style: AppTypography.caption(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // Time and distance row
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        icon: Icons.access_time,
                        label: 'Duration',
                        value: journey.formattedDuration,
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.route,
                        label: 'Distance',
                        value: journey.formattedDistance,
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.place,
                        label: 'Places',
                        value: journey.placesCount.toString(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final confirmed = await _showFinishDialog(context);
                          if (confirmed == true) {
                            await journeyService.finishJourney();
                          }
                        },
                        icon: const Icon(Icons.stop, size: 18),
                        label: const Text('Finish'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await journeyService.addWaypoint();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Waypoint added'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.add_location, size: 18),
                        label: const Text('Add Stop'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (onViewDetails != null)
                      IconButton(
                        onPressed: onViewDetails,
                        icon: const Icon(Icons.fullscreen),
                        tooltip: 'View Details',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showFinishDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finish Journey'),
        content: const Text(
          'Are you sure you want to finish this journey? '
          'You can\'t resume it after finishing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.berryCrush),
        const SizedBox(height: AppSpacing.xs / 2),
        Text(
          value,
          style: AppTypography.headline(color: AppColors.berryCrush),
        ),
        Text(
          label,
          style: AppTypography.caption(),
        ),
      ],
    );
  }
}
