import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/trip.dart';
import '../models/hidden_gem.dart';
import '../models/route.dart';
import '../models/journey.dart';
import 'journey_service.dart';

/// Trip service for managing trips and itineraries
///
/// Handles both personal trips (user-created itineraries) and
/// booked tours (operator packages with booking details).
class TripService extends ChangeNotifier {
  static const String _tripsBoxName = 'trips';
  final Uuid _uuid = const Uuid();

  Box<Trip>? _tripsBox;
  JourneyService? _journeyService;

  /// Get all trips
  List<Trip> get trips {
    if (_tripsBox == null) return [];
    return _tripsBox!.values
        .where((trip) => !trip.isArchived)
        .toList()
      ..sort((a, b) => (b.startDate ?? b.createdAt)
          .compareTo(a.startDate ?? a.createdAt));
  }

  /// Initialize Hive and boxes
  Future<void> initialize({JourneyService? journeyService}) async {
    _journeyService = journeyService;

    await Hive.initFlutter();

    // Register adapters (typeId 6, 7, 8)
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(TripAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(TripItemAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(OperatorBookingAdapter());
    }

    // Open boxes
    try {
      if (Hive.isBoxOpen(_tripsBoxName)) {
        _tripsBox = Hive.box<Trip>(_tripsBoxName);
      } else {
        _tripsBox = await Hive.openBox<Trip>(_tripsBoxName);
      }

      debugPrint('TripService initialized with ${trips.length} trips');
    } catch (e) {
      debugPrint('Error opening trips box: $e');
      rethrow;
    }
  }

  // ==================== CRUD Operations ====================

  /// Create a new trip
  Future<Trip> createTrip({
    required String title,
    required TripType type,
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    OperatorBooking? operatorBooking,
  }) async {
    if (_tripsBox == null) {
      throw Exception('TripService not initialized');
    }

    final trip = Trip(
      title: title,
      type: type,
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      description: description,
      operatorBooking: operatorBooking,
    );

    await _tripsBox!.put(trip.id, trip);
    notifyListeners();

    debugPrint('Created trip: ${trip.title}');
    return trip;
  }

  /// Update existing trip
  Future<void> updateTrip(Trip trip) async {
    if (_tripsBox == null) {
      throw Exception('TripService not initialized');
    }

    final updatedTrip = trip.copyWith(updatedAt: DateTime.now());
    await _tripsBox!.put(trip.id, updatedTrip);
    notifyListeners();

    debugPrint('Updated trip: ${trip.title}');
  }

  /// Delete trip
  Future<void> deleteTrip(String tripId) async {
    if (_tripsBox == null) {
      throw Exception('TripService not initialized');
    }

    await _tripsBox!.delete(tripId);
    notifyListeners();

    debugPrint('Deleted trip: $tripId');
  }

  /// Get trip by ID
  Trip? getTrip(String tripId) {
    if (_tripsBox == null) return null;
    return _tripsBox!.get(tripId);
  }

  // ==================== Queries ====================

  /// Get upcoming trips (status: planning, upcoming, active)
  List<Trip> getUpcomingTrips() {
    return trips
        .where((trip) =>
            trip.status == TripStatus.planning ||
            trip.status == TripStatus.upcoming ||
            trip.status == TripStatus.active)
        .toList();
  }

  /// Get past trips (status: completed)
  List<Trip> getPastTrips() {
    return trips.where((trip) => trip.status == TripStatus.completed).toList();
  }

  /// Get active trip (currently happening)
  Trip? getActiveTrip() {
    try {
      return trips.firstWhere((trip) => trip.status == TripStatus.active);
    } catch (e) {
      return null;
    }
  }

  /// Get trips by status
  List<Trip> getTripsByStatus(TripStatus status) {
    return trips.where((trip) => trip.status == status).toList();
  }

  // ==================== Trip Items ====================

  /// Add item to trip
  Future<void> addItemToTrip(String tripId, TripItem item) async {
    final trip = getTrip(tripId);
    if (trip == null) {
      throw Exception('Trip not found: $tripId');
    }

    trip.items.add(item);
    await updateTrip(trip);

    debugPrint('Added item "${item.name}" to trip "${trip.title}"');
  }

  /// Remove item from trip
  Future<void> removeItemFromTrip(String tripId, String itemId) async {
    final trip = getTrip(tripId);
    if (trip == null) {
      throw Exception('Trip not found: $tripId');
    }

    trip.items.removeWhere((item) => item.id == itemId);
    await updateTrip(trip);

    debugPrint('Removed item from trip "${trip.title}"');
  }

  /// Reorder trip items
  Future<void> reorderTripItems(String tripId, List<TripItem> items) async {
    final trip = getTrip(tripId);
    if (trip == null) {
      throw Exception('Trip not found: $tripId');
    }

    // Update order indices
    for (int i = 0; i < items.length; i++) {
      items[i].orderIndex = i;
    }

    final updatedTrip = trip.copyWith(items: items);
    await updateTrip(updatedTrip);

    debugPrint('Reordered ${items.length} items in trip "${trip.title}"');
  }

  /// Update a specific trip item
  Future<void> updateTripItem(String tripId, TripItem updatedItem) async {
    final trip = getTrip(tripId);
    if (trip == null) {
      throw Exception('Trip not found: $tripId');
    }

    final index = trip.items.indexWhere((item) => item.id == updatedItem.id);
    if (index == -1) {
      throw Exception('Trip item not found: ${updatedItem.id}');
    }

    trip.items[index] = updatedItem;
    await updateTrip(trip);

    debugPrint('Updated item "${updatedItem.name}" in trip "${trip.title}"');
  }

  // ==================== Quick Add Methods ====================

  /// Add hidden gem to trip
  Future<void> addGemToTrip(String tripId, HiddenGem gem) async {
    final tripItem = TripItem(
      type: TripItemType.gem,
      referenceId: gem.id,
      name: gem.name,
      description: gem.description,
      latitude: gem.latitude,
      longitude: gem.longitude,
      coverPhotoUrl: gem.photoUrls.isNotEmpty ? gem.photoUrls.first : null,
    );

    await addItemToTrip(tripId, tripItem);
  }

  /// Add safari/tour to trip
  Future<void> addSafariToTrip(
      String tripId, Map<String, dynamic> safari) async {
    final tripItem = TripItem(
      type: TripItemType.safari,
      referenceId: safari['id'] ?? _uuid.v4(),
      name: safari['name'] ?? 'Safari',
      description: safari['description'],
      latitude: double.tryParse(safari['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(safari['longitude']?.toString() ?? '0') ?? 0.0,
      coverPhotoUrl: safari['images']?.isNotEmpty == true
          ? safari['images'][0]
          : null,
    );

    await addItemToTrip(tripId, tripItem);
  }

  /// Add route to trip
  Future<void> addRouteToTrip(String tripId, Route route) async {
    final tripItem = TripItem(
      type: TripItemType.route,
      referenceId: route.id,
      name: route.name,
      description: route.description,
      latitude: route.startPoint.latitude,
      longitude: route.startPoint.longitude,
    );

    await addItemToTrip(tripId, tripItem);
  }

  // ==================== Trip Lifecycle ====================

  /// Start a trip (creates associated Journey for GPS tracking)
  Future<void> startTrip(String tripId) async {
    final trip = getTrip(tripId);
    if (trip == null) {
      throw Exception('Trip not found: $tripId');
    }

    if (_journeyService == null) {
      throw Exception('JourneyService not available');
    }

    // Create Journey for tracking
    final journey = await _journeyService!.startJourney(
      title: trip.title,
      type: JourneyType.other, // Generic type for trips
    );

    // Link Journey to Trip
    final updatedTrip = trip.copyWith(
      status: TripStatus.active,
      activeJourneyId: journey.id,
    );

    await updateTrip(updatedTrip);

    debugPrint('Started trip "${trip.title}" with journey ${journey.id}');
  }

  /// Complete a trip
  Future<void> completeTrip(String tripId) async {
    final trip = getTrip(tripId);
    if (trip == null) {
      throw Exception('Trip not found: $tripId');
    }

    // Finish active journey if exists
    if (trip.activeJourneyId != null && _journeyService != null) {
      await _journeyService!.finishJourney(description: 'Trip completed');

      // Add to completed journeys
      trip.completedJourneyIds.add(trip.activeJourneyId!);
    }

    // Update trip status
    final updatedTrip = trip.copyWith(
      status: TripStatus.completed,
      activeJourneyId: null,
    );

    await updateTrip(updatedTrip);

    debugPrint('Completed trip "${trip.title}"');
  }

  /// Cancel a trip
  Future<void> cancelTrip(String tripId) async {
    final trip = getTrip(tripId);
    if (trip == null) {
      throw Exception('Trip not found: $tripId');
    }

    // Cancel active journey if exists
    if (trip.activeJourneyId != null && _journeyService != null) {
      await _journeyService!.finishJourney(description: 'Trip cancelled');
    }

    final updatedTrip = trip.copyWith(
      status: TripStatus.cancelled,
      activeJourneyId: null,
    );

    await updateTrip(updatedTrip);

    debugPrint('Cancelled trip "${trip.title}"');
  }

  /// Archive a trip
  Future<void> archiveTrip(String tripId) async {
    final trip = getTrip(tripId);
    if (trip == null) {
      throw Exception('Trip not found: $tripId');
    }

    final updatedTrip = trip.copyWith(isArchived: true);
    await updateTrip(updatedTrip);

    debugPrint('Archived trip "${trip.title}"');
  }

  // ==================== Journey Integration ====================

  /// Link journey to trip
  Future<void> linkJourneyToTrip(String tripId, String journeyId) async {
    final trip = getTrip(tripId);
    if (trip == null) {
      throw Exception('Trip not found: $tripId');
    }

    final updatedTrip = trip.copyWith(activeJourneyId: journeyId);
    await updateTrip(updatedTrip);

    debugPrint('Linked journey $journeyId to trip "${trip.title}"');
  }

  // ==================== Statistics ====================

  /// Get trip statistics
  Map<String, int> getTripStatistics() {
    final allTrips = _tripsBox?.values.toList() ?? [];

    return {
      'total': allTrips.length,
      'planning': allTrips.where((t) => t.status == TripStatus.planning).length,
      'upcoming': allTrips.where((t) => t.status == TripStatus.upcoming).length,
      'active': allTrips.where((t) => t.status == TripStatus.active).length,
      'completed':
          allTrips.where((t) => t.status == TripStatus.completed).length,
      'cancelled':
          allTrips.where((t) => t.status == TripStatus.cancelled).length,
      'personalTrips':
          allTrips.where((t) => t.type == TripType.personal).length,
      'bookedTours': allTrips.where((t) => t.type == TripType.booked).length,
    };
  }

  /// Dispose
  @override
  void dispose() {
    // Note: Don't close Hive boxes in dispose
    // They are shared across the app
    super.dispose();
  }
}
