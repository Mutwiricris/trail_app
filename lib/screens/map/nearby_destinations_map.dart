import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:zuritrails/models/hidden_gem.dart';
import 'package:zuritrails/screens/routes/route_browser_screen.dart';
import 'package:zuritrails/services/location_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Map showing nearby destinations and hidden gems
class NearbyDestinationsMap extends StatefulWidget {
  const NearbyDestinationsMap({super.key});

  @override
  State<NearbyDestinationsMap> createState() => _NearbyDestinationsMapState();
}

class _NearbyDestinationsMapState extends State<NearbyDestinationsMap> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();

  LatLng? _currentPosition;
  HiddenGem? _selectedGem;
  bool _isLoading = true;
  List<HiddenGem> _nearbyGems = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      // Get current location
      final position = await _locationService.getCurrentPosition();

      if (position != null && mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _nearbyGems = _findNearbyGems(position);
          _isLoading = false;
        });
      } else if (mounted) {
        // Position is null, use default
        setState(() {
          _currentPosition = LatLng(-1.2921, 36.8219);
          _nearbyGems = MockGemsData.getMockGems();
          _isLoading = false;
        });
      }
    } catch (e) {
      // Default to Nairobi if location fails
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(-1.2921, 36.8219);
          _nearbyGems = MockGemsData.getMockGems();
          _isLoading = false;
        });
      }
    }
  }

  List<HiddenGem> _findNearbyGems(Position userPosition) {
    // Get all gems and calculate distances
    final allGems = MockGemsData.getMockGems();

    // Calculate distance and filter within 50km
    final gemsWithDistance = allGems.map((gem) {
      final distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        gem.location.latitude,
        gem.location.longitude,
      ) / 1000; // Convert to km

      return {'gem': gem, 'distance': distance};
    }).where((item) => item['distance'] as double < 50).toList();

    // Sort by distance
    gemsWithDistance.sort((a, b) =>
      (a['distance'] as double).compareTo(b['distance'] as double));

    return gemsWithDistance.map((item) => item['gem'] as HiddenGem).toList();
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Add current location marker
    if (_currentPosition != null) {
      markers.add(Marker(
        point: _currentPosition!,
        width: 50,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.info,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.info.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Icon(
            Icons.my_location,
            color: Colors.white,
            size: 24,
          ),
        ),
      ));
    }

    // Add gem markers (Airbnb-style)
    for (final gem in _nearbyGems) {
      final isSelected = _selectedGem?.id == gem.id;
      markers.add(Marker(
        point: gem.location,
        width: 80,
        height: 40,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedGem = gem;
            });
            // Animate map to gem location
            _mapController.move(gem.location, 14.0);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.textPrimary : AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? AppColors.textPrimary : AppColors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: isSelected ? AppColors.white : AppColors.warning,
                ),
                const SizedBox(width: 4),
                Text(
                  gem.rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return markers;
  }

  void _recenterMap() {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 13.0);
      setState(() {
        _selectedGem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scanning Surroundings...'),
          backgroundColor: AppColors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.berryCrush),
              SizedBox(height: 16),
              Text(
                'Finding nearby destinations...',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nearby Destinations'),
            Text(
              '${_nearbyGems.length} gems within 50km',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.berryCrush),
            onPressed: () {
              // TODO: Show category filters
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition ?? LatLng(-1.2921, 36.8219),
              initialZoom: 13.0,
              onTap: (_, __) {
                // Close gem preview when tapping map
                if (_selectedGem != null) {
                  setState(() {
                    _selectedGem = null;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.zuritrails.app',
                maxZoom: 19,
              ),
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),

          // Recenter button
          Positioned(
            bottom: _selectedGem != null ? 320 : 24,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(50),
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
                  onTap: _recenterMap,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    child: const Icon(
                      Icons.my_location,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Gem count badge
          Positioned(
            top: 20,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.berryCrush.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.place,
                      color: AppColors.berryCrush,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_nearbyGems.length} places',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Selected gem preview
          if (_selectedGem != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildGemPreview(_selectedGem!),
            ),
        ],
      ),
    );
  }

  Widget _buildGemPreview(HiddenGem gem) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RouteBrowserScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with gradient overlay
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      gem.categoryColor.withValues(alpha: 0.15),
                      gem.categoryColor.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Large background icon
                    Positioned.fill(
                      child: Center(
                        child: Icon(
                          gem.categoryIcon,
                          size: 80,
                          color: gem.categoryColor.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    // Category badge
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              gem.categoryIcon,
                              size: 16,
                              color: gem.categoryColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              gem.category.displayName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: gem.categoryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          gem.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Rating and stats
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
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
                              gem.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '·',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${gem.discoveryCount} explorers',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    gem.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RouteBrowserScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textPrimary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
