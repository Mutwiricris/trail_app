import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zuritrails/services/location_service.dart';
import 'package:zuritrails/services/routing_service.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Screen showing navigation route from user's location to a gem
class GemRouteScreen extends StatefulWidget {
  final Map<String, dynamic> gem;

  const GemRouteScreen({
    super.key,
    required this.gem,
  });

  @override
  State<GemRouteScreen> createState() => _GemRouteScreenState();
}

class _GemRouteScreenState extends State<GemRouteScreen> {
  final LocationService _locationService = LocationService();
  final RoutingService _routingService = RoutingService();
  final MapController _mapController = MapController();

  LatLng? _currentPosition;
  LatLng? _destinationPosition;
  LatLng? _customStartPosition;  // Custom starting point set by user
  RouteResult? _routeResult;  // Actual route from OSRM
  bool _isLoading = true;
  bool _isFetchingRoute = false;
  double? _distanceKm;
  String? _estimatedTime;
  bool _isSelectingStartPoint = false;
  String _selectedProfile = 'driving'; // driving, walking, cycling

  @override
  void initState() {
    super.initState();
    _initializeRoute();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeRoute() async {
    try {
      // Get current location
      final position = await _locationService.getCurrentPosition();

      // Get destination coordinates from gem data
      final destLat = widget.gem['latitude'] ?? -1.2921;
      final destLng = widget.gem['longitude'] ?? 36.8219;

      if (position != null && mounted) {
        final currentPos = LatLng(position.latitude, position.longitude);
        final destPos = LatLng(destLat, destLng);

        setState(() {
          _currentPosition = currentPos;
          _destinationPosition = destPos;
          _isLoading = false;
        });
        await _fetchRoute();
      } else if (mounted) {
        // Use default Nairobi location if GPS fails
        setState(() {
          _currentPosition = LatLng(-1.2921, 36.8219);
          _destinationPosition = LatLng(destLat, destLng);
          _isLoading = false;
        });
        await _fetchRoute();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchRoute() async {
    final startPos = _customStartPosition ?? _currentPosition;
    if (startPos == null || _destinationPosition == null) return;

    setState(() {
      _isFetchingRoute = true;
    });

    try {
      final route = await _routingService.getRoute(
        start: startPos,
        destination: _destinationPosition!,
        profile: _selectedProfile,
      );

      if (route != null && mounted) {
        setState(() {
          _routeResult = route;
          _distanceKm = route.distanceKm;
          _estimatedTime = route.formattedDuration;
          _isFetchingRoute = false;
        });
      } else if (mounted) {
        // Fallback to straight line if route fetch fails
        _calculateDistance();
        setState(() {
          _isFetchingRoute = false;
        });
      }
    } catch (e) {
      print('Error fetching route: $e');
      if (mounted) {
        // Fallback to straight line calculation
        _calculateDistance();
        setState(() {
          _isFetchingRoute = false;
        });
      }
    }
  }

  void _calculateDistance() {
    if (_destinationPosition == null) return;

    final startPos = _customStartPosition ?? _currentPosition;
    if (startPos == null) return;

    final distance = Geolocator.distanceBetween(
      startPos.latitude,
      startPos.longitude,
      _destinationPosition!.latitude,
      _destinationPosition!.longitude,
    ) / 1000; // Convert to km

    setState(() {
      _distanceKm = distance;
    });
  }

  void _handleMapTap(TapPosition tapPosition, LatLng point) {
    if (_isSelectingStartPoint) {
      setState(() {
        _customStartPosition = point;
        _isSelectingStartPoint = false;
      });
      _fetchRoute();
    }
  }

  void _resetToCurrentLocation() {
    setState(() {
      _customStartPosition = null;
      _isSelectingStartPoint = false;
    });
    _fetchRoute();
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Start location marker (custom or current)
    final startPos = _customStartPosition ?? _currentPosition;
    final isCustomStart = _customStartPosition != null;

    if (startPos != null) {
      markers.add(Marker(
        point: startPos,
        width: 60,
        height: 60,
        child: Container(
          decoration: BoxDecoration(
            color: isCustomStart ? AppColors.warning : AppColors.info,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: (isCustomStart ? AppColors.warning : AppColors.info).withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Icon(
            isCustomStart ? Icons.flag : Icons.my_location,
            color: AppColors.white,
            size: 28,
          ),
        ),
      ));
    }

    // Destination marker
    if (_destinationPosition != null) {
      markers.add(Marker(
        point: _destinationPosition!,
        width: 60,
        height: 60,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.berryCrush,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.berryCrush.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Icon(
            Icons.place,
            color: AppColors.white,
            size: 28,
          ),
        ),
      ));
    }

    return markers;
  }

  LatLng _getCenterPoint() {
    final startPos = _customStartPosition ?? _currentPosition;
    if (startPos != null && _destinationPosition != null) {
      return LatLng(
        (startPos.latitude + _destinationPosition!.latitude) / 2,
        (startPos.longitude + _destinationPosition!.longitude) / 2,
      );
    }
    return startPos ?? _destinationPosition ?? LatLng(-1.2921, 36.8219);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading Route...'),
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
        title: const Text('Route to Destination'),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _getCenterPoint(),
              initialZoom: 11.0,
              onTap: _handleMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.zuritrails.app',
                maxZoom: 19,
              ),
              // Route polyline - shows actual road route from OSRM
              if (_routeResult != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routeResult!.points,
                      strokeWidth: 5,
                      color: AppColors.berryCrush,
                      borderStrokeWidth: 2,
                      borderColor: AppColors.white,
                    ),
                  ],
                )
              else if ((_customStartPosition ?? _currentPosition) != null && _destinationPosition != null)
                // Fallback to straight line if route not available
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [_customStartPosition ?? _currentPosition!, _destinationPosition!],
                      strokeWidth: 3,
                      color: AppColors.berryCrush.withOpacity(0.5),
                      borderStrokeWidth: 1,
                      borderColor: AppColors.white.withOpacity(0.5),
                    ),
                  ],
                ),
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),

          // Selection mode banner
          if (_isSelectingStartPoint)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.touch_app,
                      color: AppColors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tap on the map to set your starting point',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.white),
                      onPressed: () {
                        setState(() {
                          _isSelectingStartPoint = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

          // Destination info card
          if (!_isSelectingStartPoint)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.berryCrush.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.place,
                          color: AppColors.berryCrush,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.gem['title'] ?? widget.gem['name'] ?? 'Destination',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.gem['location'] ?? 'Kenya',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_distanceKm != null || _estimatedTime != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (_distanceKm != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.straighten,
                                  size: 16,
                                  color: AppColors.info,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _routeResult?.formattedDistance ?? '${_distanceKm!.toStringAsFixed(1)} km',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_estimatedTime != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  size: 16,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _estimatedTime!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  // Loading indicator when fetching route
                  if (_isFetchingRoute) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.berryCrush),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Calculating route...',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Navigation buttons and controls
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Transport mode selector (Uber-style)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildTransportModeButton(
                        icon: Icons.directions_car,
                        label: 'Drive',
                        mode: 'driving',
                        isSelected: _selectedProfile == 'driving',
                      ),
                      const SizedBox(width: 6),
                      _buildTransportModeButton(
                        icon: Icons.directions_walk,
                        label: 'Walk',
                        mode: 'walking',
                        isSelected: _selectedProfile == 'walking',
                      ),
                      const SizedBox(width: 6),
                      _buildTransportModeButton(
                        icon: Icons.directions_bike,
                        label: 'Bike',
                        mode: 'cycling',
                        isSelected: _selectedProfile == 'cycling',
                      ),
                    ],
                  ),
                ),

                // Change start point / Reset location button
                if (_customStartPosition != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _resetToCurrentLocation,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.my_location,
                                color: AppColors.info,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Use My Current Location',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Main action row
                Row(
                  children: [
                    // Change start button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isSelectingStartPoint = true;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: const Icon(
                              Icons.edit_location,
                              color: AppColors.warning,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Recenter button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _mapController.move(_getCenterPoint(), 11.0);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: const Icon(
                              Icons.center_focus_strong,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Start navigation button
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.berryCrush,
                              AppColors.berryCrushLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.berryCrush.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              if (_destinationPosition == null) return;

                              final lat = _destinationPosition!.latitude;
                              final lng = _destinationPosition!.longitude;
                              final destName = widget.gem['name'] ?? 'Destination';

                              // Try to open in Google Maps
                              final googleMapsUrl = Uri.parse(
                                'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=${_selectedProfile == 'driving' ? 'driving' : _selectedProfile == 'walking' ? 'walking' : 'bicycling'}'
                              );

                              try {
                                if (await canLaunchUrl(googleMapsUrl)) {
                                  await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
                                } else {
                                  // Fallback to generic maps URL
                                  final fallbackUrl = Uri.parse('https://maps.google.com/?q=$lat,$lng');
                                  await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Could not open maps app: $e'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.navigation,
                                    color: AppColors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Navigate',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

  Widget _buildTransportModeButton({
    required IconData icon,
    required String label,
    required String mode,
    required bool isSelected,
  }) {
    return Expanded(
      child: Material(
        color: isSelected
            ? AppColors.berryCrush
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            if (_selectedProfile != mode) {
              setState(() {
                _selectedProfile = mode;
              });
              _fetchRoute();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
