import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:zuritrails/models/route.dart' as app_route;
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/widgets/map/interactive_map.dart';
import 'package:zuritrails/widgets/details/info_card.dart';
import 'package:zuritrails/widgets/details/tab_section.dart';
import 'package:zuritrails/widgets/details/highlights_grid.dart';
import 'package:zuritrails/widgets/details/tips_card.dart';
import 'package:zuritrails/widgets/common/save_bottom_sheet.dart';

/// Detail screen for a specific route
class RouteDetailScreen extends StatefulWidget {
  final app_route.Route route;

  const RouteDetailScreen({
    super.key,
    required this.route,
  });

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.berryCrush,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: AppColors.white),
                onPressed: () {
                  // TODO: Share route
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: AppColors.white),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => SaveBottomSheet(
                      itemId: widget.route.id,
                      itemName: widget.route.name,
                      itemType: SaveItemType.route,
                      itemData: widget.route,
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Map
                  InteractiveMap(
                    center: widget.route.startPoint,
                    zoom: 11,
                    polyline: widget.route.waypoints,
                    markers: _buildMarkers(),
                    interactive: true,
                    height: 300,
                  ),

                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.berryCrush.withValues(alpha: 0.9),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.route.type.icon,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.route.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.route.region,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Stats Grid (using new InfoCardGrid)
                      InfoCardGrid(
                        cards: [
                          InfoCardData(
                            icon: Icons.route,
                            label: 'Distance',
                            value: widget.route.formattedDistance,
                          ),
                          InfoCardData(
                            icon: Icons.access_time,
                            label: 'Duration',
                            value: widget.route.formattedDuration,
                          ),
                          if (widget.route.formattedElevation != null)
                            InfoCardData(
                              icon: Icons.trending_up,
                              label: 'Elevation',
                              value: widget.route.formattedElevation!,
                            ),
                          // Add more stats
                          InfoCardData(
                            icon: Icons.terrain,
                            label: 'Difficulty',
                            value: widget.route.difficulty.displayName,
                            iconColor: _difficultyColor,
                            iconBackgroundColor: _difficultyColor.withValues(alpha: 0.1),
                          ),
                        ],
                        crossAxisCount: 2,
                        spacing: 12,
                        compact: false,
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Rating badge (keeping rating separate from stats)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.route.rating.toStringAsFixed(1)} (${widget.route.completedCount} completed)',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Quick Stats Card
                QuickStatsCard(
                  stats: [
                    StatItem(
                      value: widget.route.completedCount.toString(),
                      label: 'Completed',
                      icon: Icons.check_circle,
                    ),
                    StatItem(
                      value: '${widget.route.segments.length}',
                      label: 'Segments',
                      icon: Icons.diamond,
                    ),
                    StatItem(
                      value: widget.route.rating.toStringAsFixed(1),
                      label: 'Rating',
                      icon: Icons.star,
                    ),
                  ],
                  accentColor: AppColors.berryCrush,
                ),

                const SizedBox(height: AppSpacing.sm),

                // Highlights Grid (replacing old list)
                if (widget.route.highlights.isNotEmpty)
                  HighlightsGrid(
                    title: 'What to Expect',
                    highlights: widget.route.highlights
                        .map((h) => HighlightItem.fromString(h))
                        .toList(),
                  ),

                const SizedBox(height: AppSpacing.sm),

                // Tabbed Information Section
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: FixedHeightTabSection(
                    contentHeight: 300,
                    tabs: const ['Overview', 'What to Expect', 'Safety'],
                    children: [
                      // Tab 1: Overview
                      SingleChildScrollView(
                        child: Text(
                          widget.route.description,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),

                      // Tab 2: What to Expect (Highlights)
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.route.highlights.map((highlight) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 20,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      highlight,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: AppColors.textSecondary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // Tab 3: Safety Info
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSafetyItem(
                              Icons.warning_amber,
                              'Trail Conditions',
                              'Check current trail status before departing. Conditions may vary with weather.',
                            ),
                            const SizedBox(height: 16),
                            _buildSafetyItem(
                              Icons.water_drop,
                              'Water Sources',
                              'Bring sufficient water. Limited water sources along the route.',
                            ),
                            const SizedBox(height: 16),
                            _buildSafetyItem(
                              Icons.phone_android,
                              'Mobile Coverage',
                              'Intermittent mobile coverage. Download offline maps before starting.',
                            ),
                            const SizedBox(height: 16),
                            _buildSafetyItem(
                              Icons.local_hospital,
                              'Emergency',
                              'In case of emergency, contact park rangers or call 999.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Tips and Preparation
                TipsCard(
                  title: 'Tips & Preparation',
                  headerIcon: Icons.lightbulb_outline,
                  accentColor: AppColors.warning,
                  tips: const [
                    TipItem(
                      title: 'Start Early',
                      description: 'Begin your journey in the morning to avoid afternoon heat and crowds.',
                      icon: Icons.wb_sunny,
                      isImportant: true,
                    ),
                    TipItem(
                      title: 'Bring Plenty of Water',
                      description: 'Carry at least 2L of water per person. Refill points are limited.',
                      icon: Icons.water_drop,
                    ),
                    TipItem(
                      title: 'Wear Proper Footwear',
                      description: 'Sturdy hiking boots with good ankle support are recommended.',
                      icon: Icons.hiking,
                    ),
                    TipItem(
                      title: 'Download Offline Maps',
                      description: 'Mobile coverage can be spotty. Save offline maps before you go.',
                      icon: Icons.map,
                      isImportant: true,
                    ),
                    TipItem(
                      title: 'Check Weather Forecast',
                      description: 'Weather conditions can change quickly. Plan accordingly.',
                      icon: Icons.cloud,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.sm),

                // Getting There
                GettingThereCard(
                  options: const [
                    TransportOption(
                      method: 'By Car',
                      description: 'Most convenient option with ample parking at the trailhead.',
                      icon: Icons.directions_car,
                      color: AppColors.info,
                      duration: '1.5 hours from Nairobi',
                    ),
                    TransportOption(
                      method: 'Public Matatu',
                      description: 'Regular matatus run from town to the starting point.',
                      icon: Icons.directions_bus,
                      color: AppColors.warning,
                      duration: '2 hours',
                    ),
                  ],
                  parkingInfo: 'Free parking available at the trailhead. Secure parking with attendant on duty 6am-6pm.',
                  publicTransportInfo: 'Matatus depart every 30 minutes from main bus station. Last return trip at 5pm.',
                ),

                const SizedBox(height: AppSpacing.sm),

                // Hidden Segments
                if (widget.route.hasSegments) ...[
                  Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.diamond,
                              color: AppColors.info,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Hidden Segments',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...widget.route.segments.map((segment) {
                          return _buildSegmentCard(segment);
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ],
            ),
          ),
        ],
      ),

      // Start Route Button
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              // TODO: Start route navigation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Route navigation coming soon!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.berryCrush,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Start Route',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color get _difficultyColor {
    switch (widget.route.difficulty) {
      case app_route.RouteDifficulty.easy:
        return AppColors.success;
      case app_route.RouteDifficulty.moderate:
        return AppColors.warning;
      case app_route.RouteDifficulty.challenging:
      case app_route.RouteDifficulty.difficult:
        return AppColors.error;
    }
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Start marker
    markers.add(MapMarkers.journeyStart(widget.route.startPoint));

    // End marker
    markers.add(MapMarkers.journeyEnd(widget.route.endPoint));

    // Segment markers
    for (int i = 0; i < widget.route.segments.length; i++) {
      markers.add(MapMarkers.gem(widget.route.segments[i].startPoint));
    }

    return markers;
  }

  Widget _buildSafetyItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
    );
  }

  Widget _buildSegmentCard(app_route.RouteSegment segment) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              segment.type.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  segment.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  segment.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${segment.discoveredByCount} discovered',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '+${segment.pointsReward} pts',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
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
}
