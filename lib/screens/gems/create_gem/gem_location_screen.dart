import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/hidden_gem_data.dart';
import 'package:zuritrails/services/location_service.dart';

class GemLocationScreen extends StatefulWidget {
  final HiddenGemData gemData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const GemLocationScreen({
    super.key,
    required this.gemData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<GemLocationScreen> createState() => _GemLocationScreenState();
}

class _GemLocationScreenState extends State<GemLocationScreen> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  LatLng? _selectedLocation;
  LatLng _currentPosition = const LatLng(-1.2921, 36.8219); // Nairobi default
  bool _isLoadingLocation = false;
  bool _locationConfirmed = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
    _getCurrentLocation();
  }

  void _loadExistingData() {
    if (widget.gemData.location != null) {
      _selectedLocation = widget.gemData.location;
      _locationConfirmed = true;
    }
    if (widget.gemData.locationName != null) {
      _locationNameController.text = widget.gemData.locationName!;
    }
    if (widget.gemData.address != null) {
      _addressController.text = widget.gemData.address!;
    }
    if (widget.gemData.city != null) {
      _cityController.text = widget.gemData.city!;
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await _locationService.getCurrentPosition();
      if (mounted && position != null) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          if (_selectedLocation == null) {
            _selectedLocation = _currentPosition;
          }
          _isLoadingLocation = false;
        });

        // Move map to current location
        _mapController.move(_currentPosition, 15.0);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedLocation = position;
      _locationConfirmed = false;
    });
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      setState(() {
        _locationConfirmed = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location confirmed! Please provide location details.'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _moveToCurrentLocation() {
    _mapController.move(_currentPosition, 15.0);
  }

  void _updateGemData() {
    widget.gemData.location = _selectedLocation;
    widget.gemData.locationName = _locationNameController.text.trim().isNotEmpty
        ? _locationNameController.text.trim()
        : null;
    widget.gemData.address = _addressController.text.trim().isNotEmpty
        ? _addressController.text.trim()
        : null;
    widget.gemData.city = _cityController.text.trim().isNotEmpty
        ? _cityController.text.trim()
        : null;
  }

  bool get _canProceed {
    return _selectedLocation != null &&
        _locationConfirmed &&
        _locationNameController.text.trim().isNotEmpty &&
        _cityController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _locationNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Set Location',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.berryCrush,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _locationConfirmed
                            ? 'Location confirmed! Add details below.'
                            : 'Tap on the map to pin the exact location',
                        style: TextStyle(
                          fontSize: 14,
                          color: _locationConfirmed
                              ? AppColors.success
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedLocation != null && !_locationConfirmed) ...[
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _confirmLocation,
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text('Confirm Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Map
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation ?? _currentPosition,
                    initialZoom: 15.0,
                    onTap: _onMapTap,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.zuritrails.app',
                    ),
                    MarkerLayer(
                      markers: [
                        // Current location marker
                        Marker(
                          point: _currentPosition,
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: AppColors.info,
                              size: 20,
                            ),
                          ),
                        ),
                        // Selected location marker
                        if (_selectedLocation != null)
                          Marker(
                            point: _selectedLocation!,
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.location_on,
                              color: _locationConfirmed
                                  ? AppColors.success
                                  : AppColors.berryCrush,
                              size: 50,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                // Current location button
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: AppColors.white,
                    onPressed: _moveToCurrentLocation,
                    child: const Icon(
                      Icons.my_location,
                      color: AppColors.berryCrush,
                    ),
                  ),
                ),
                if (_isLoadingLocation)
                  Container(
                    color: AppColors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Location Details Form
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _locationNameController,
                      label: 'Location Name *',
                      hint: 'e.g., Paradise Valley',
                      icon: Icons.place,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Address / Directions',
                      hint: 'e.g., Off Ngong Road, near the forest',
                      icon: Icons.location_city,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _cityController,
                      label: 'City / Region *',
                      hint: 'e.g., Nairobi',
                      icon: Icons.location_on_outlined,
                    ),
                    if (_selectedLocation != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coordinates',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, '
                              'Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'monospace',
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _canProceed
                    ? () {
                        _updateGemData();
                        widget.onNext();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.berryCrush,
                  disabledBackgroundColor: AppColors.greyLight,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.berryCrush),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.greyLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.greyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.berryCrush, width: 2),
        ),
        filled: true,
        fillColor: AppColors.background,
      ),
    );
  }
}
