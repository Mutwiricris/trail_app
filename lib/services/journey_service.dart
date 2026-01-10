import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import '../models/journey.dart';
import 'location_service.dart';

/// Journey service for CRUD operations and journey management
class JourneyService extends ChangeNotifier {
  static const String _journeysBoxName = 'journeys';
  final LocationService _locationService = LocationService();
  final Uuid _uuid = const Uuid();

  Box<Journey>? _journeysBox;
  Journey? _activeJourney;
  Stream<Position>? _locationStream;

  /// Get all journeys
  List<Journey> get journeys {
    if (_journeysBox == null) return [];
    return _journeysBox!.values.toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  /// Get active journey
  Journey? get activeJourney => _activeJourney;

  /// Check if there's an active journey
  bool get hasActiveJourney => _activeJourney != null;

  /// Initialize Hive and boxes
  Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(JourneyAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WaypointAdapter());
    }

    // Open boxes with error handling
    try {
      // Check if box is already open
      if (Hive.isBoxOpen(_journeysBoxName)) {
        _journeysBox = Hive.box<Journey>(_journeysBoxName);
      } else {
        _journeysBox = await Hive.openBox<Journey>(_journeysBoxName);
      }

      // Check for existing active journey
      try {
        _activeJourney = journeys.firstWhere((j) => j.isActive);
      } catch (e) {
        _activeJourney = null;
      }
    } catch (e) {
      debugPrint('Error opening Hive box: $e');
      // Continue without persistence - app will work with in-memory state only
    }

    notifyListeners();
  }

  /// Start a new journey
  Future<Journey> startJourney({
    required String title,
    required JourneyType type,
  }) async {
    if (_activeJourney != null) {
      throw Exception('There is already an active journey');
    }

    // Get current position
    final position = await _locationService.getCurrentPosition();
    if (position == null) {
      throw Exception('Unable to get current location');
    }

    // Create first waypoint
    final firstWaypoint = Waypoint(
      id: _uuid.v4(),
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      altitude: position.altitude,
      name: 'Start',
    );

    // Create journey
    final journey = Journey(
      id: _uuid.v4(),
      title: title,
      type: type,
      startTime: DateTime.now(),
      waypoints: [firstWaypoint],
      isActive: true,
      createdAt: DateTime.now(),
    );

    // Save to database
    await _journeysBox?.put(journey.id, journey);

    _activeJourney = journey;

    // Start tracking location
    _startLocationTracking();

    notifyListeners();
    return journey;
  }

  /// Add a waypoint to active journey
  Future<void> addWaypoint({
    String? name,
    String? note,
    List<String>? photoUrls,
  }) async {
    if (_activeJourney == null) {
      throw Exception('No active journey');
    }

    final position = await _locationService.getCurrentPosition();
    if (position == null) {
      throw Exception('Unable to get current location');
    }

    final waypoint = Waypoint(
      id: _uuid.v4(),
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      name: name,
      note: note,
      photoUrls: photoUrls,
      altitude: position.altitude,
    );

    final updatedWaypoints = List<Waypoint>.from(_activeJourney!.waypoints)
      ..add(waypoint);

    // Calculate new distance
    double newDistance = _activeJourney!.distanceKm;
    if (_activeJourney!.waypoints.isNotEmpty) {
      final lastWaypoint = _activeJourney!.waypoints.last;
      newDistance += _locationService.calculateDistance(
        lastWaypoint.latitude,
        lastWaypoint.longitude,
        waypoint.latitude,
        waypoint.longitude,
      );
    }

    final updatedJourney = _activeJourney!.copyWith(
      waypoints: updatedWaypoints,
      distanceKm: newDistance,
    );

    await _journeysBox?.put(updatedJourney.id, updatedJourney);
    _activeJourney = updatedJourney;

    notifyListeners();
  }

  /// Pause active journey
  Future<void> pauseJourney() async {
    if (_activeJourney == null) return;

    _locationStream = null; // Stop tracking
    notifyListeners();
  }

  /// Resume active journey
  Future<void> resumeJourney() async {
    if (_activeJourney == null) return;

    _startLocationTracking();
    notifyListeners();
  }

  /// Finish active journey
  Future<Journey> finishJourney({String? description}) async {
    if (_activeJourney == null) {
      throw Exception('No active journey');
    }

    final updatedJourney = _activeJourney!.copyWith(
      endTime: DateTime.now(),
      isActive: false,
      description: description,
    );

    await _journeysBox?.put(updatedJourney.id, updatedJourney);

    _activeJourney = null;
    _locationStream = null;

    notifyListeners();
    return updatedJourney;
  }

  /// Delete a journey
  Future<void> deleteJourney(String journeyId) async {
    await _journeysBox?.delete(journeyId);
    if (_activeJourney?.id == journeyId) {
      _activeJourney = null;
      _locationStream = null;
    }
    notifyListeners();
  }

  /// Update journey details
  Future<void> updateJourney(Journey journey) async {
    await _journeysBox?.put(journey.id, journey);
    if (_activeJourney?.id == journey.id) {
      _activeJourney = journey;
    }
    notifyListeners();
  }

  /// Get journey by ID
  Journey? getJourney(String id) {
    return _journeysBox?.get(id);
  }

  /// Get recent journeys
  List<Journey> getRecentJourneys({int limit = 10}) {
    return journeys.take(limit).toList();
  }

  /// Get journeys by type
  List<Journey> getJourneysByType(JourneyType type) {
    return journeys.where((j) => j.type == type).toList();
  }

  /// Get total statistics
  Map<String, dynamic> getTotalStats() {
    final completedJourneys = journeys.where((j) => j.isCompleted).toList();

    double totalDistance = 0;
    int totalPlaces = 0;
    Duration totalDuration = Duration.zero;

    for (final journey in completedJourneys) {
      totalDistance += journey.distanceKm;
      totalPlaces += journey.placesCount;
      totalDuration += journey.duration;
    }

    return {
      'totalJourneys': completedJourneys.length,
      'totalDistance': totalDistance,
      'totalPlaces': totalPlaces,
      'totalDuration': totalDuration,
    };
  }

  /// Start location tracking for active journey
  void _startLocationTracking() {
    _locationStream = _locationService.trackLocation();
    _locationStream?.listen((position) {
      _updateJourneyDistance(position);
    });
  }

  /// Update journey distance based on new position
  void _updateJourneyDistance(Position position) async {
    if (_activeJourney == null || _activeJourney!.waypoints.isEmpty) return;

    final lastWaypoint = _activeJourney!.waypoints.last;
    final distance = _locationService.calculateDistance(
      lastWaypoint.latitude,
      lastWaypoint.longitude,
      position.latitude,
      position.longitude,
    );

    // Only update if moved more than 0.01 km (10 meters)
    if (distance > 0.01) {
      final newDistance = _activeJourney!.distanceKm + distance;
      final updatedJourney = _activeJourney!.copyWith(
        distanceKm: newDistance,
      );

      await _journeysBox?.put(updatedJourney.id, updatedJourney);
      _activeJourney = updatedJourney;
      notifyListeners();
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _journeysBox?.close();
    super.dispose();
  }
}
