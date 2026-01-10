import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:zuritrails/models/journey.dart';
import 'package:zuritrails/screens/map/map_view_screen.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/widgets/common/stats_grid.dart';
import 'package:zuritrails/widgets/map/interactive_map.dart';
import 'package:intl/intl.dart';

/// Journey summary screen - shows completed journey details
class JourneySummaryScreen extends StatelessWidget {
  final Journey journey;

  const JourneySummaryScreen({
    super.key,
    required this.journey,
  });

  List<Marker> _buildMapMarkers() {
    final markers = <Marker>[];
    final waypoints = journey.waypoints;

    if (waypoints.isEmpty) return markers;

    // Start marker
    markers.add(MapMarkers.journeyStart(
      LatLng(waypoints.first.latitude, waypoints.first.longitude),
    ));

    // End marker
    if (waypoints.length > 1) {
      markers.add(MapMarkers.journeyEnd(
        LatLng(waypoints.last.latitude, waypoints.last.longitude),
      ));
    }

    // Waypoint markers
    for (int i = 1; i < waypoints.length - 1; i++) {
      markers.add(MapMarkers.waypoint(
        LatLng(waypoints[i].latitude, waypoints[i].longitude),
        label: (i).toString(),
      ));
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.berryCrush,
                    AppColors.berryCrushDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    journey.type.icon,
                    style: const TextStyle(fontSize: 60),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    journey.title,
                    style: AppTypography.displaySmall(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormat('MMMM d, y').format(journey.startTime),
                    style: AppTypography.bodyMedium(color: AppColors.white),
                  ),
                ],
              ),
            ),

            // Stats
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: StatsGrid(
                stats: [
                  StatItem(
                    value: journey.formattedDistance,
                    label: 'Distance',
                    icon: Icons.route,
                  ),
                  StatItem(
                    value: journey.formattedDuration,
                    label: 'Duration',
                    icon: Icons.access_time,
                  ),
                  StatItem(
                    value: journey.placesCount.toString(),
                    label: 'Places',
                    icon: Icons.place,
                  ),
                ],
              ),
            ),

            // Map Preview
            if (journey.waypoints.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Route Map',
                      style: AppTypography.headline(),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MapViewScreen(
                              journey: journey,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.fullscreen, size: 18),
                      label: const Text('Full Map'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.berryCrush,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MapViewScreen(
                          journey: journey,
                        ),
                      ),
                    );
                  },
                  child: InteractiveMap(
                    center: LatLng(
                      journey.waypoints.first.latitude,
                      journey.waypoints.first.longitude,
                    ),
                    zoom: 12.0,
                    polyline: journey.waypoints
                        .map((w) => LatLng(w.latitude, w.longitude))
                        .toList(),
                    markers: _buildMapMarkers(),
                    interactive: false,
                    height: 250,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Waypoints
            if (journey.waypoints.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Waypoints',
                  style: AppTypography.headline(),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: journey.waypoints.length,
                itemBuilder: (context, index) {
                  final waypoint = journey.waypoints[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.berryCrushLight,
                      child: Text(
                        '${index + 1}',
                        style: AppTypography.buttonMedium(
                          color: AppColors.berryCrushDark,
                        ),
                      ),
                    ),
                    title: Text(
                      waypoint.name ?? 'Waypoint ${index + 1}',
                      style: AppTypography.bodyLarge(),
                    ),
                    subtitle: Text(
                      DateFormat('HH:mm').format(waypoint.timestamp),
                      style: AppTypography.caption(),
                    ),
                    trailing: waypoint.photoUrls?.isNotEmpty == true
                        ? const Icon(Icons.photo, color: AppColors.berryCrush)
                        : null,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
