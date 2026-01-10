import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/hidden_gem.dart';
import 'package:zuritrails/models/journey.dart';
import 'package:zuritrails/services/location_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/widgets/map/interactive_map.dart';

/// Full-screen map view for exploring gems and journeys
class MapViewScreen extends StatefulWidget {
  /// Optional list of gems to display
  final List<HiddenGem>? gems;

  /// Optional journey to display
  final Journey? journey;

  /// Initial center (if not provided, uses current location)
  final LatLng? initialCenter;

  const MapViewScreen({
    super.key,
    this.gems,
    this.journey,
    this.initialCenter,
  });

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final LocationService _locationService = LocationService();
  LatLng? _currentPosition;
  HiddenGem? _selectedGem;
  bool _isLoading = true;
  bool _showCurrentLocation = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      if (widget.initialCenter != null) {
        setState(() {
          _currentPosition = widget.initialCenter;
          _isLoading = false;
        });
        return;
      }

      final position = await _locationService.getCurrentPosition();
      if (mounted && position != null) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Default to Nairobi if location fails
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(-1.2921, 36.8219);
          _isLoading = false;
        });
      }
    }
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Add current location marker
    if (_showCurrentLocation && _currentPosition != null && widget.journey == null) {
      markers.add(MapMarkers.currentLocation(_currentPosition!));
    }

    // Add journey markers
    if (widget.journey != null) {
      final waypoints = widget.journey!.waypoints;
      if (waypoints.isNotEmpty) {
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
      }
    }

    // Add gem markers
    if (widget.gems != null) {
      for (final gem in widget.gems!) {
        markers.add(MapMarkers.gem(
          gem.location,
          onTap: () {
            setState(() {
              _selectedGem = gem;
            });
          },
        ));
      }
    }

    return markers;
  }

  List<LatLng>? _buildPolyline() {
    if (widget.journey == null) return null;

    return widget.journey!.waypoints
        .map((w) => LatLng(w.latitude, w.longitude))
        .toList();
  }

  LatLng _getMapCenter() {
    if (widget.journey != null && widget.journey!.waypoints.isNotEmpty) {
      final waypoints = widget.journey!.waypoints;
      return LatLng(waypoints.first.latitude, waypoints.first.longitude);
    }

    if (widget.gems != null && widget.gems!.isNotEmpty) {
      return widget.gems!.first.location;
    }

    return _currentPosition ?? LatLng(-1.2921, 36.8219);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Map'),
          backgroundColor: AppColors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.berryCrush),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.journey != null ? 'Journey Map' : 'Explore Map'),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (widget.journey == null)
            IconButton(
              icon: Icon(
                _showCurrentLocation ? Icons.my_location : Icons.location_disabled,
                color: AppColors.berryCrush,
              ),
              onPressed: () {
                setState(() {
                  _showCurrentLocation = !_showCurrentLocation;
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          InteractiveMap(
            center: _getMapCenter(),
            zoom: widget.journey != null ? 12.0 : 13.0,
            polyline: _buildPolyline(),
            markers: _buildMarkers(),
            height: MediaQuery.of(context).size.height,
            interactive: true,
            onTap: (_) {
              // Close gem details when tapping map
              if (_selectedGem != null) {
                setState(() {
                  _selectedGem = null;
                });
              }
            },
          ),

          // Gem details bottom sheet
          if (_selectedGem != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildGemDetailsSheet(_selectedGem!),
            ),

          // Journey stats overlay
          if (widget.journey != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildJourneyStatsCard(widget.journey!),
            ),
        ],
      ),
    );
  }

  Widget _buildGemDetailsSheet(HiddenGem gem) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: gem.categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  gem.categoryIcon,
                  color: gem.categoryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gem.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          gem.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${gem.discoveryCount} discovered',
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
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedGem = null;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            gem.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Get directions
                  },
                  icon: const Icon(Icons.directions, size: 20),
                  label: const Text('Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.berryCrush,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: View details
                  },
                  icon: const Icon(Icons.info_outline, size: 20),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.berryCrush,
                    side: const BorderSide(color: AppColors.berryCrush),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyStatsCard(Journey journey) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.route,
            '${journey.distanceKm.toStringAsFixed(1)} km',
            'Distance',
          ),
          _buildStatItem(
            Icons.access_time,
            _formatDuration(journey.duration),
            'Duration',
          ),
          _buildStatItem(
            Icons.place,
            '${journey.waypoints.length}',
            'Stops',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.berryCrush, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
