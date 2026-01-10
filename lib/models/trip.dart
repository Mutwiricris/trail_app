import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'trip.g.dart';

/// Type of trip
enum TripType {
  @HiveField(0)
  personal, // User-created itinerary
  @HiveField(1)
  booked // Operator tour booking
}

/// Status of trip
enum TripStatus {
  @HiveField(0)
  planning, // Not yet started
  @HiveField(1)
  upcoming, // Confirmed, in future
  @HiveField(2)
  active, // Currently happening
  @HiveField(3)
  completed, // Finished
  @HiveField(4)
  cancelled // Cancelled booking
}

/// Type of item in trip itinerary
enum TripItemType {
  @HiveField(0)
  gem, // Hidden gem
  @HiveField(1)
  safari, // Safari/tour
  @HiveField(2)
  route, // Route/destination
  @HiveField(3)
  custom // User-added custom location
}

/// Trip model - represents a travel itinerary or booked tour
///
/// Can be either:
/// - Personal trip: User-created itinerary with saved gems/safaris/routes
/// - Booked tour: Operator-provided safari package with booking details
@HiveType(typeId: 6)
class Trip extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  final TripType type;

  @HiveField(3)
  TripStatus status;

  // Dates
  @HiveField(4)
  DateTime? startDate;

  @HiveField(5)
  DateTime? endDate;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  DateTime? updatedAt;

  // Content - items in trip itinerary
  @HiveField(8)
  List<TripItem> items;

  // User notes and planning
  @HiveField(9)
  String? description;

  @HiveField(10)
  List<String>? notes;

  @HiveField(11)
  String? coverPhotoUrl;

  // Operator booking info (null for personal trips)
  @HiveField(12)
  OperatorBooking? operatorBooking;

  // Journey tracking (links to Journey when trip is active)
  @HiveField(13)
  String? activeJourneyId;

  @HiveField(14)
  List<String> completedJourneyIds;

  // Metadata
  @HiveField(15)
  final String userId;

  @HiveField(16)
  bool isArchived;

  Trip({
    String? id,
    required this.title,
    required this.type,
    TripStatus? status,
    this.startDate,
    this.endDate,
    DateTime? createdAt,
    this.updatedAt,
    List<TripItem>? items,
    this.description,
    this.notes,
    this.coverPhotoUrl,
    this.operatorBooking,
    this.activeJourneyId,
    List<String>? completedJourneyIds,
    required this.userId,
    bool? isArchived,
  })  : id = id ?? const Uuid().v4(),
        status = status ?? TripStatus.planning,
        createdAt = createdAt ?? DateTime.now(),
        items = items ?? [],
        completedJourneyIds = completedJourneyIds ?? [],
        isArchived = isArchived ?? false;

  /// Duration in days
  int? get durationDays {
    if (startDate == null || endDate == null) return null;
    return endDate!.difference(startDate!).inDays + 1;
  }

  /// Number of destinations in trip
  int get destinationCount => items.length;

  /// Number of visited destinations
  int get visitedCount => items.where((item) => item.isVisited).length;

  /// Progress percentage (0-100)
  double get progressPercent {
    if (items.isEmpty) return 0.0;
    return (visitedCount / items.length) * 100;
  }

  /// Whether trip is a booked tour
  bool get isBookedTour => type == TripType.booked && operatorBooking != null;

  /// Whether trip is currently active
  bool get isActive => status == TripStatus.active;

  /// Whether trip is completed
  bool get isCompleted => status == TripStatus.completed;

  /// Copy with method
  Trip copyWith({
    String? id,
    String? title,
    TripType? type,
    TripStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TripItem>? items,
    String? description,
    List<String>? notes,
    String? coverPhotoUrl,
    OperatorBooking? operatorBooking,
    String? activeJourneyId,
    List<String>? completedJourneyIds,
    String? userId,
    bool? isArchived,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      items: items ?? this.items,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      operatorBooking: operatorBooking ?? this.operatorBooking,
      activeJourneyId: activeJourneyId ?? this.activeJourneyId,
      completedJourneyIds: completedJourneyIds ?? this.completedJourneyIds,
      userId: userId ?? this.userId,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}

/// Trip item - represents a single destination/activity in a trip
@HiveType(typeId: 7)
class TripItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final TripItemType type;

  @HiveField(2)
  final String referenceId; // ID of gem/safari/route

  @HiveField(3)
  String name;

  @HiveField(4)
  String? description;

  // Location data (cached from reference)
  @HiveField(5)
  final double latitude;

  @HiveField(6)
  final double longitude;

  // Scheduling
  @HiveField(7)
  DateTime? scheduledDate;

  @HiveField(8)
  int orderIndex;

  // Visit tracking
  @HiveField(9)
  bool isVisited;

  @HiveField(10)
  DateTime? visitedAt;

  @HiveField(11)
  String? visitJourneyId; // Journey during which it was visited

  // User notes for this specific item
  @HiveField(12)
  String? notes;

  @HiveField(13)
  List<String>? photoUrls;

  @HiveField(14)
  String? coverPhotoUrl;

  TripItem({
    String? id,
    required this.type,
    required this.referenceId,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    this.scheduledDate,
    int? orderIndex,
    bool? isVisited,
    this.visitedAt,
    this.visitJourneyId,
    this.notes,
    this.photoUrls,
    this.coverPhotoUrl,
  })  : id = id ?? const Uuid().v4(),
        orderIndex = orderIndex ?? 0,
        isVisited = isVisited ?? false;

  /// Copy with method
  TripItem copyWith({
    String? id,
    TripItemType? type,
    String? referenceId,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    DateTime? scheduledDate,
    int? orderIndex,
    bool? isVisited,
    DateTime? visitedAt,
    String? visitJourneyId,
    String? notes,
    List<String>? photoUrls,
    String? coverPhotoUrl,
  }) {
    return TripItem(
      id: id ?? this.id,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      orderIndex: orderIndex ?? this.orderIndex,
      isVisited: isVisited ?? this.isVisited,
      visitedAt: visitedAt ?? this.visitedAt,
      visitJourneyId: visitJourneyId ?? this.visitJourneyId,
      notes: notes ?? this.notes,
      photoUrls: photoUrls ?? this.photoUrls,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
    );
  }
}

/// Operator booking details for booked tours
@HiveType(typeId: 8)
class OperatorBooking extends HiveObject {
  @HiveField(0)
  final String operatorId;

  @HiveField(1)
  final String operatorName;

  @HiveField(2)
  String? operatorPhone;

  @HiveField(3)
  String? operatorEmail;

  // Booking details
  @HiveField(4)
  final String confirmationCode;

  @HiveField(5)
  final double priceKES;

  @HiveField(6)
  String? currency;

  @HiveField(7)
  final DateTime bookedAt;

  // Included services
  @HiveField(8)
  List<String> includedServices;

  @HiveField(9)
  List<String> excludedServices;

  // Accommodation
  @HiveField(10)
  String? accommodationType;

  @HiveField(11)
  int numberOfGuests;

  // Status
  @HiveField(12)
  bool isPaid;

  @HiveField(13)
  bool isConfirmed;

  @HiveField(14)
  String? cancellationPolicy;

  OperatorBooking({
    required this.operatorId,
    required this.operatorName,
    this.operatorPhone,
    this.operatorEmail,
    required this.confirmationCode,
    required this.priceKES,
    this.currency,
    DateTime? bookedAt,
    List<String>? includedServices,
    List<String>? excludedServices,
    this.accommodationType,
    int? numberOfGuests,
    bool? isPaid,
    bool? isConfirmed,
    this.cancellationPolicy,
  })  : bookedAt = bookedAt ?? DateTime.now(),
        includedServices = includedServices ?? [],
        excludedServices = excludedServices ?? [],
        numberOfGuests = numberOfGuests ?? 1,
        isPaid = isPaid ?? false,
        isConfirmed = isConfirmed ?? false;

  /// Copy with method
  OperatorBooking copyWith({
    String? operatorId,
    String? operatorName,
    String? operatorPhone,
    String? operatorEmail,
    String? confirmationCode,
    double? priceKES,
    String? currency,
    DateTime? bookedAt,
    List<String>? includedServices,
    List<String>? excludedServices,
    String? accommodationType,
    int? numberOfGuests,
    bool? isPaid,
    bool? isConfirmed,
    String? cancellationPolicy,
  }) {
    return OperatorBooking(
      operatorId: operatorId ?? this.operatorId,
      operatorName: operatorName ?? this.operatorName,
      operatorPhone: operatorPhone ?? this.operatorPhone,
      operatorEmail: operatorEmail ?? this.operatorEmail,
      confirmationCode: confirmationCode ?? this.confirmationCode,
      priceKES: priceKES ?? this.priceKES,
      currency: currency ?? this.currency,
      bookedAt: bookedAt ?? this.bookedAt,
      includedServices: includedServices ?? this.includedServices,
      excludedServices: excludedServices ?? this.excludedServices,
      accommodationType: accommodationType ?? this.accommodationType,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      isPaid: isPaid ?? this.isPaid,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
    );
  }
}
