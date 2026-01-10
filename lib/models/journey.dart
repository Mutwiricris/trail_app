import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

part 'journey.g.dart';

/// Journey type enumeration
enum JourneyType {
  safari,
  roadTrip,
  hike,
  cityWalk,
  other;

  String get displayName {
    switch (this) {
      case JourneyType.safari:
        return 'Safari';
      case JourneyType.roadTrip:
        return 'Road Trip';
      case JourneyType.hike:
        return 'Hike';
      case JourneyType.cityWalk:
        return 'City Walk';
      case JourneyType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case JourneyType.safari:
        return '🦁';
      case JourneyType.roadTrip:
        return '🚗';
      case JourneyType.hike:
        return '🥾';
      case JourneyType.cityWalk:
        return '🏙️';
      case JourneyType.other:
        return '🗺️';
    }
  }
}

/// Waypoint model - represents a stop or point of interest during a journey
@HiveType(typeId: 1)
class Waypoint extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String? name;

  @HiveField(5)
  final String? note;

  @HiveField(6)
  final List<String>? photoUrls;

  @HiveField(7)
  final double? altitude;

  Waypoint({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.name,
    this.note,
    this.photoUrls,
    this.altitude,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  Map<String, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp.toIso8601String(),
        'name': name,
        'note': note,
        'photoUrls': photoUrls,
        'altitude': altitude,
      };

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
        id: json['id'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
        name: json['name'] as String?,
        note: json['note'] as String?,
        photoUrls: (json['photoUrls'] as List<dynamic>?)?.cast<String>(),
        altitude: (json['altitude'] as num?)?.toDouble(),
      );
}

/// Journey model - represents a complete journey/trip
@HiveType(typeId: 0)
class Journey extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final JourneyType type;

  @HiveField(3)
  final DateTime startTime;

  @HiveField(4)
  DateTime? endTime;

  @HiveField(5)
  final List<Waypoint> waypoints;

  @HiveField(6)
  double distanceKm;

  @HiveField(7)
  final List<String>? photoUrls;

  @HiveField(8)
  String? description;

  @HiveField(9)
  bool isActive;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  DateTime? updatedAt;

  Journey({
    required this.id,
    required this.title,
    required this.type,
    required this.startTime,
    this.endTime,
    List<Waypoint>? waypoints,
    this.distanceKm = 0.0,
    this.photoUrls,
    this.description,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  }) : waypoints = waypoints ?? [];

  /// Duration of the journey
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Number of places/waypoints visited
  int get placesCount => waypoints.length;

  /// Start location
  LatLng? get startLocation {
    if (waypoints.isEmpty) return null;
    return waypoints.first.latLng;
  }

  /// End location
  LatLng? get endLocation {
    if (waypoints.isEmpty) return null;
    return waypoints.last.latLng;
  }

  /// Check if journey is completed
  bool get isCompleted => endTime != null && !isActive;

  /// Formatted duration string
  String get formattedDuration {
    final d = duration;
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else {
      return '${minutes}min';
    }
  }

  /// Formatted distance string
  String get formattedDistance {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).toStringAsFixed(0)}m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.name,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'waypoints': waypoints.map((w) => w.toJson()).toList(),
        'distanceKm': distanceKm,
        'photoUrls': photoUrls,
        'description': description,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory Journey.fromJson(Map<String, dynamic> json) => Journey(
        id: json['id'] as String,
        title: json['title'] as String,
        type: JourneyType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => JourneyType.other,
        ),
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'] as String)
            : null,
        waypoints: (json['waypoints'] as List<dynamic>)
            .map((w) => Waypoint.fromJson(w as Map<String, dynamic>))
            .toList(),
        distanceKm: (json['distanceKm'] as num).toDouble(),
        photoUrls: (json['photoUrls'] as List<dynamic>?)?.cast<String>(),
        description: json['description'] as String?,
        isActive: json['isActive'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
      );

  /// Create a copy with updated fields
  Journey copyWith({
    String? title,
    JourneyType? type,
    DateTime? startTime,
    DateTime? endTime,
    List<Waypoint>? waypoints,
    double? distanceKm,
    List<String>? photoUrls,
    String? description,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return Journey(
      id: id,
      title: title ?? this.title,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      waypoints: waypoints ?? this.waypoints,
      distanceKm: distanceKm ?? this.distanceKm,
      photoUrls: photoUrls ?? this.photoUrls,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
