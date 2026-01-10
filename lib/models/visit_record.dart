import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'visit_record.g.dart';

/// Type of visit detection
enum VisitType {
  @HiveField(0)
  autoDetected, // GPS-based automatic detection
  @HiveField(1)
  manual // User manually marked as visited
}

/// Visit record - tracks when a user visited a place
///
/// Can be created either:
/// - Automatically via GPS geofencing when user arrives at location
/// - Manually when user marks a place as visited
///
/// Visit records are used for:
/// - User's visit history
/// - Achievement tracking
/// - Trip completion progress
/// - Personal statistics
@HiveType(typeId: 10)
class VisitRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String placeId; // ID of gem/safari/route

  @HiveField(2)
  final String placeType; // 'gem', 'safari', 'route'

  @HiveField(3)
  String placeName;

  // Visit details
  @HiveField(4)
  final DateTime visitedAt;

  @HiveField(5)
  final VisitType visitType;

  // Location data at time of visit
  @HiveField(6)
  final double visitLatitude;

  @HiveField(7)
  final double visitLongitude;

  @HiveField(8)
  double? distanceFromPlaceMeters; // Distance from actual place location

  // Associated journey (if visit happened during active journey)
  @HiveField(9)
  String? journeyId;

  @HiveField(10)
  String? waypointId;

  // User data
  @HiveField(11)
  final String userId;

  @HiveField(12)
  List<String>? photoUrls;

  @HiveField(13)
  String? notes;

  @HiveField(14)
  double? userRating; // 1.0 to 5.0

  // Metadata
  @HiveField(15)
  final DateTime createdAt;

  VisitRecord({
    String? id,
    required this.placeId,
    required this.placeType,
    required this.placeName,
    DateTime? visitedAt,
    required this.visitType,
    required this.visitLatitude,
    required this.visitLongitude,
    this.distanceFromPlaceMeters,
    this.journeyId,
    this.waypointId,
    required this.userId,
    this.photoUrls,
    this.notes,
    this.userRating,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        visitedAt = visitedAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  /// Whether visit was detected automatically via GPS
  bool get wasAutoDetected => visitType == VisitType.autoDetected;

  /// Whether visit was manually marked by user
  bool get wasManual => visitType == VisitType.manual;

  /// Whether visit is linked to a journey
  bool get hasJourney => journeyId != null;

  /// Whether user has rated this visit
  bool get hasRating => userRating != null;

  /// Get visit accuracy description
  String get accuracyDescription {
    if (distanceFromPlaceMeters == null) return 'Unknown';
    if (distanceFromPlaceMeters! < 20) return 'Very accurate';
    if (distanceFromPlaceMeters! < 50) return 'Accurate';
    if (distanceFromPlaceMeters! < 100) return 'Approximate';
    return 'Far from location';
  }

  /// Copy with method
  VisitRecord copyWith({
    String? id,
    String? placeId,
    String? placeType,
    String? placeName,
    DateTime? visitedAt,
    VisitType? visitType,
    double? visitLatitude,
    double? visitLongitude,
    double? distanceFromPlaceMeters,
    String? journeyId,
    String? waypointId,
    String? userId,
    List<String>? photoUrls,
    String? notes,
    double? userRating,
    DateTime? createdAt,
  }) {
    return VisitRecord(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      placeType: placeType ?? this.placeType,
      placeName: placeName ?? this.placeName,
      visitedAt: visitedAt ?? this.visitedAt,
      visitType: visitType ?? this.visitType,
      visitLatitude: visitLatitude ?? this.visitLatitude,
      visitLongitude: visitLongitude ?? this.visitLongitude,
      distanceFromPlaceMeters: distanceFromPlaceMeters ?? this.distanceFromPlaceMeters,
      journeyId: journeyId ?? this.journeyId,
      waypointId: waypointId ?? this.waypointId,
      userId: userId ?? this.userId,
      photoUrls: photoUrls ?? this.photoUrls,
      notes: notes ?? this.notes,
      userRating: userRating ?? this.userRating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
