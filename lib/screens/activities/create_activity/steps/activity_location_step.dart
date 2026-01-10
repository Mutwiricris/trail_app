import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:zuritrails/models/activity_data.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Step 4: Choose location (general area or specific location)
class ActivityLocationStep extends StatefulWidget {
  final ActivityData activityData;
  final VoidCallback onNext;

  const ActivityLocationStep({
    super.key,
    required this.activityData,
    required this.onNext,
  });

  @override
  State<ActivityLocationStep> createState() => _ActivityLocationStepState();
}

class _ActivityLocationStepState extends State<ActivityLocationStep> {
  String _locationType = 'general'; // 'general' or 'specific'
  LatLng _selectedLocation = const LatLng(-1.2921, 36.8219); // Nairobi default
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    if (widget.activityData.locationType != null) {
      _locationType = widget.activityData.locationType!;
    }
    if (widget.activityData.latitude != null &&
        widget.activityData.longitude != null) {
      _selectedLocation = LatLng(
        widget.activityData.latitude!,
        widget.activityData.longitude!,
      );
    }
  }

  void _setLocation() {
    widget.activityData.locationType = _locationType;
    widget.activityData.latitude = _selectedLocation.latitude;
    widget.activityData.longitude = _selectedLocation.longitude;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            // Map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selectedLocation,
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  if (_locationType == 'specific') {
                    setState(() {
                      _selectedLocation = point;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.zuritrails.app',
                ),
                if (_locationType == 'specific')
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.location_pin,
                          color: AppColors.berryCrush,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                if (_locationType == 'general')
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: _selectedLocation,
                        radius: 2000, // 2km radius
                        color: AppColors.berryCrush.withOpacity(0.2),
                        borderColor: AppColors.berryCrush,
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
              ],
            ),

            // Top overlay with location type selector
            Positioned(
              top: 16,
              left: 16,
              right: 60,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _locationType = 'general';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _locationType == 'general'
                                ? AppColors.berryCrush.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: _locationType == 'general'
                                    ? AppColors.berryCrush
                                    : AppColors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'General',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _locationType == 'general'
                                      ? AppColors.berryCrush
                                      : AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _locationType = 'specific';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _locationType == 'specific'
                                ? AppColors.berryCrush.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.push_pin,
                                color: _locationType == 'specific'
                                    ? AppColors.berryCrush
                                    : AppColors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Specific',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _locationType == 'specific'
                                      ? AppColors.berryCrush
                                      : AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.black),
                ),
              ),
            ),

            // Instruction card
            Positioned(
              top: 80,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: AppColors.berryCrush,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _locationType == 'general'
                            ? 'Choose a general area\nIf you\'re not sure about the exact location'
                            : 'Tap on the map to set exact location',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom button
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _setLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.berryCrush,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.berryCrush.withOpacity(0.4),
                  ),
                  child: const Text(
                    'Set Activity Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
