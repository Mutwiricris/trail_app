import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/visit_record.dart';
import '../models/trip.dart';
import 'journey_service.dart';
import 'trip_service.dart';

/// Visit tracking service for GPS-based visit detection
///
/// Handles:
/// - Automatic GPS-based visit detection (geofencing)
/// - Manual visit marking
/// - Visit history and statistics
/// - Integration with Journey Service
class VisitTrackingService extends ChangeNotifier {
  static const String _visitsBoxName = 'visit_records';
  static const double _visitRadiusMeters = 50.0; // Detection radius

  Box<VisitRecord>? _visitsBox;
  JourneyService? _journeyService;
  TripService? _tripService;

  // Geofencing
  final Map<String, _Geofence> _geofences = {};
  bool _isTracking = false;

  /// Get all visit records
  List<VisitRecord> get visitRecords {
    if (_visitsBox == null) return [];
    return _visitsBox!.values.toList()
      ..sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
  }

  /// Whether visit tracking is active
  bool get isTracking => _isTracking;

  /// Initialize Hive and boxes
  Future<void> initialize({
    JourneyService? journeyService,
    TripService? tripService,
  }) async {
    _journeyService = journeyService;
    _tripService = tripService;

    await Hive.initFlutter();

    // Register adapter (typeId 10)
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(VisitRecordAdapter());
    }

    // Open boxes
    try {
      if (Hive.isBoxOpen(_visitsBoxName)) {
        _visitsBox = Hive.box<VisitRecord>(_visitsBoxName);
      } else {
        _visitsBox = await Hive.openBox<VisitRecord>(_visitsBoxName);
      }

      debugPrint(
          'VisitTrackingService initialized with ${visitRecords.length} visits');
    } catch (e) {
      debugPrint('Error opening visits box: $e');
      rethrow;
    }

    // Subscribe to journey updates for auto-detection
    _subscribeToJourneyUpdates();
  }

  // ==================== Visit Detection ====================

  /// Start visit tracking
  Future<void> startVisitTracking() async {
    if (_isTracking) {
      debugPrint('Visit tracking already active');
      return;
    }

    _isTracking = true;
    debugPrint('Started visit tracking');
    notifyListeners();
  }

  /// Stop visit tracking
  void stopVisitTracking() {
    _isTracking = false;
    _geofences.clear();
    debugPrint('Stopped visit tracking');
    notifyListeners();
  }

  /// Check proximity to places based on current position
  Future<void> checkProximityToPlaces(Position position) async {
    if (!_isTracking) return;

    // Get active trip
    final activeTrip = _tripService?.getActiveTrip();
    if (activeTrip == null) return;

    // Check each unvisited trip item
    for (final item in activeTrip.items.where((i) => !i.isVisited)) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        item.latitude,
        item.longitude,
      );

      // If within detection radius
      if (distance <= _visitRadiusMeters) {
        debugPrint(
            'Detected proximity to ${item.name} (${distance.toStringAsFixed(1)}m)');

        // This would trigger a visit confirmation dialog in the UI
        // For now, we'll just log it
        // The actual recording happens when user confirms
      }
    }
  }

  // ==================== Visit Recording ====================

  /// Record a visit
  Future<VisitRecord> recordVisit({
    required String placeId,
    required String placeType,
    required String placeName,
    required String userId,
    required VisitType visitType,
    Position? position,
    String? notes,
    List<String>? photoUrls,
    double? userRating,
  }) async {
    if (_visitsBox == null) {
      throw Exception('VisitTrackingService not initialized');
    }

    // Get current position if not provided
    final visitPosition = position ?? await Geolocator.getCurrentPosition();

    // Get active journey info if available
    String? journeyId;
    String? waypointId;
    if (_journeyService?.hasActiveJourney == true) {
      final activeJourney = _journeyService!.activeJourney!;
      journeyId = activeJourney.id;
      if (activeJourney.waypoints.isNotEmpty) {
        waypointId = activeJourney.waypoints.last.id;
      }
    }

    // Create visit record
    final visitRecord = VisitRecord(
      placeId: placeId,
      placeType: placeType,
      placeName: placeName,
      visitType: visitType,
      visitLatitude: visitPosition.latitude,
      visitLongitude: visitPosition.longitude,
      userId: userId,
      journeyId: journeyId,
      waypointId: waypointId,
      notes: notes,
      photoUrls: photoUrls,
      userRating: userRating,
    );

    await _visitsBox!.put(visitRecord.id, visitRecord);
    notifyListeners();

    debugPrint('Recorded ${visitType.name} visit to $placeName');
    return visitRecord;
  }

  /// Mark place as visited (manual)
  Future<VisitRecord> markAsVisited({
    required String placeId,
    required String placeType,
    required String placeName,
    required String userId,
    String? notes,
    List<String>? photoUrls,
    double? userRating,
  }) async {
    // Try to get current position, but don't fail if unavailable
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('Could not get position for manual visit: $e');
      // Use a default position if GPS unavailable
      position = Position(
        latitude: 0,
        longitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }

    return await recordVisit(
      placeId: placeId,
      placeType: placeType,
      placeName: placeName,
      userId: userId,
      visitType: VisitType.manual,
      position: position,
      notes: notes,
      photoUrls: photoUrls,
      userRating: userRating,
    );
  }

  // ==================== Queries ====================

  /// Get all visits
  List<VisitRecord> getAllVisits() {
    return visitRecords;
  }

  /// Get visits by type (gem, safari, route)
  List<VisitRecord> getVisitsByType(String placeType) {
    return visitRecords.where((visit) => visit.placeType == placeType).toList();
  }

  /// Get recent visits
  List<VisitRecord> getRecentVisits({int limit = 10}) {
    return visitRecords.take(limit).toList();
  }

  /// Check if user has visited a place
  bool hasVisited(String placeId, String placeType) {
    return visitRecords.any(
        (visit) => visit.placeId == placeId && visit.placeType == placeType);
  }

  /// Get visit record for a place
  VisitRecord? getVisitRecord(String placeId, String placeType) {
    try {
      return visitRecords.firstWhere(
          (visit) => visit.placeId == placeId && visit.placeType == placeType);
    } catch (e) {
      return null;
    }
  }

  /// Get visits for a journey
  List<VisitRecord> getVisitsForJourney(String journeyId) {
    return visitRecords
        .where((visit) => visit.journeyId == journeyId)
        .toList();
  }

  // ==================== Geofencing ====================

  /// Add geofence for place
  void addGeofence(
    String placeId,
    double latitude,
    double longitude,
    double radiusMeters,
  ) {
    _geofences[placeId] = _Geofence(
      placeId: placeId,
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
    );

    debugPrint('Added geofence for $placeId (radius: ${radiusMeters}m)');
  }

  /// Remove geofence
  void removeGeofence(String placeId) {
    _geofences.remove(placeId);
    debugPrint('Removed geofence for $placeId');
  }

  /// Clear all geofences
  void clearAllGeofences() {
    _geofences.clear();
    debugPrint('Cleared all geofences');
  }

  // ==================== Journey Integration ====================

  /// Subscribe to journey updates for auto-detection
  void _subscribeToJourneyUpdates() {
    _journeyService?.addListener(_onJourneyUpdate);
  }

  /// Handle journey updates
  void _onJourneyUpdate() async {
    if (!_isTracking) return;
    if (_journeyService?.hasActiveJourney != true) return;

    final journey = _journeyService!.activeJourney!;
    if (journey.waypoints.isEmpty) return;

    // Get latest waypoint
    final latestWaypoint = journey.waypoints.last;
    final position = Position(
      latitude: latestWaypoint.latitude,
      longitude: latestWaypoint.longitude,
      timestamp: latestWaypoint.timestamp,
      accuracy: 0,
      altitude: latestWaypoint.altitude ?? 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

    // Check proximity to places
    await checkProximityToPlaces(position);
  }

  /// Link visit to journey
  Future<void> linkVisitToJourney(String visitId, String journeyId) async {
    final visit = _visitsBox?.get(visitId);
    if (visit == null) {
      throw Exception('Visit record not found: $visitId');
    }

    final updatedVisit = visit.copyWith(journeyId: journeyId);
    await _visitsBox!.put(visitId, updatedVisit);
    notifyListeners();

    debugPrint('Linked visit to journey $journeyId');
  }

  // ==================== Statistics ====================

  /// Get visit statistics
  Map<String, int> getVisitStatistics() {
    final visits = visitRecords;

    return {
      'total': visits.length,
      'autoDetected':
          visits.where((v) => v.visitType == VisitType.autoDetected).length,
      'manual': visits.where((v) => v.visitType == VisitType.manual).length,
      'gems': visits.where((v) => v.placeType == 'gem').length,
      'safaris': visits.where((v) => v.placeType == 'safari').length,
      'routes': visits.where((v) => v.placeType == 'route').length,
      'withJourney': visits.where((v) => v.journeyId != null).length,
      'rated': visits.where((v) => v.userRating != null).length,
    };
  }

  /// Get count of discovered gems
  int getGemsDiscoveredCount() {
    return visitRecords.where((v) => v.placeType == 'gem').length;
  }

  /// Get count of completed safaris
  int getSafarisCompletedCount() {
    return visitRecords.where((v) => v.placeType == 'safari').length;
  }

  /// Get count of completed routes
  int getRoutesCompletedCount() {
    return visitRecords.where((v) => v.placeType == 'route').length;
  }

  /// Dispose
  @override
  void dispose() {
    _journeyService?.removeListener(_onJourneyUpdate);
    _geofences.clear();
    super.dispose();
  }
}

/// Internal geofence class
class _Geofence {
  final String placeId;
  final double latitude;
  final double longitude;
  final double radiusMeters;

  _Geofence({
    required this.placeId,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
  });
}
