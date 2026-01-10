import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Interactive map widget for displaying journeys, gems, and routes
class InteractiveMap extends StatefulWidget {
  /// Initial center position of the map
  final LatLng center;

  /// Initial zoom level (1-18, where 18 is most zoomed in)
  final double zoom;

  /// Optional polyline to display (e.g., journey route)
  final List<LatLng>? polyline;

  /// Optional markers to display (e.g., gems, waypoints)
  final List<Marker>? markers;

  /// Whether user can interact with the map
  final bool interactive;

  /// Height of the map widget
  final double? height;

  /// Callback when map is tapped
  final void Function(LatLng position)? onTap;

  /// Polyline color
  final Color polylineColor;

  /// Polyline width
  final double polylineWidth;

  const InteractiveMap({
    super.key,
    required this.center,
    this.zoom = 13.0,
    this.polyline,
    this.markers,
    this.interactive = true,
    this.height,
    this.onTap,
    this.polylineColor = AppColors.berryCrush,
    this.polylineWidth = 4.0,
  });

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 400,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: widget.center,
            initialZoom: widget.zoom,
            interactionOptions: InteractionOptions(
              flags: widget.interactive
                  ? InteractiveFlag.all
                  : InteractiveFlag.none,
            ),
            onTap: widget.onTap != null
                ? (tapPosition, point) => widget.onTap!(point)
                : null,
          ),
          children: [
            // OpenStreetMap tile layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.zuritrails.app',
              maxZoom: 19,
            ),

            // Polyline layer (for journey routes)
            if (widget.polyline != null && widget.polyline!.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: widget.polyline!,
                    strokeWidth: widget.polylineWidth,
                    color: widget.polylineColor,
                    borderStrokeWidth: 2,
                    borderColor: Colors.white,
                  ),
                ],
              ),

            // Marker layer (for gems, waypoints, etc.)
            if (widget.markers != null && widget.markers!.isNotEmpty)
              MarkerLayer(markers: widget.markers!),
          ],
        ),
      ),
    );
  }
}

/// Helper class to create common markers
class MapMarkers {
  /// Create a marker for the user's current location
  static Marker currentLocation(LatLng position) {
    return Marker(
      point: position,
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.info,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.info.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.navigation,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  /// Create a marker for a waypoint/stop
  static Marker waypoint(LatLng position, {String? label, VoidCallback? onTap}) {
    return Marker(
      point: position,
      width: 36,
      height: 36,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.berryCrush,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              label ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Create a marker for a hidden gem
  static Marker gem(LatLng position, {VoidCallback? onTap}) {
    return Marker(
      point: position,
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.berryCrush, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.diamond,
            color: AppColors.berryCrush,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// Create a marker for journey start
  static Marker journeyStart(LatLng position) {
    return Marker(
      point: position,
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: const Icon(
          Icons.flag,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  /// Create a marker for journey end
  static Marker journeyEnd(LatLng position) {
    return Marker(
      point: position,
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.error,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: const Icon(
          Icons.flag_outlined,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
