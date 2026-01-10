import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:latlong2/latlong.dart';

/// Location service for GPS tracking
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Stream of position updates
  Stream<Position>? _positionStream;

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check and request location permission
  Future<bool> checkAndRequestPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check permission using permission_handler
    var status = await permission.Permission.location.status;

    if (status.isDenied) {
      status = await permission.Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      // Open app settings
      await permission.openAppSettings();
      return false;
    }

    return status.isGranted;
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  /// Start tracking location updates
  Stream<Position> trackLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    final locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
      timeLimit: const Duration(seconds: 10),
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );

    return _positionStream!;
  }

  /// Calculate distance between two positions in kilometers
  double calculateDistance(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) {
    return Geolocator.distanceBetween(
          startLat,
          startLon,
          endLat,
          endLon,
        ) /
        1000; // Convert to kilometers
  }

  /// Calculate distance between two LatLng points
  double calculateDistanceLatLng(LatLng start, LatLng end) {
    return calculateDistance(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  /// Calculate total distance from a list of positions
  double calculateTotalDistance(List<Position> positions) {
    if (positions.length < 2) return 0.0;

    double totalDistance = 0.0;
    for (int i = 0; i < positions.length - 1; i++) {
      totalDistance += calculateDistance(
        positions[i].latitude,
        positions[i].longitude,
        positions[i + 1].latitude,
        positions[i + 1].longitude,
      );
    }
    return totalDistance;
  }

  /// Get location settings for Android/iOS
  static LocationSettings get locationSettings {
    return const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
  }
}
