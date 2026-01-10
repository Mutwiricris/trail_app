import 'package:latlong2/latlong.dart';

/// Types of routes
enum RouteType {
  safari('Safari Route', '🦁'),
  scenic('Scenic Drive', '🌄'),
  hiking('Hiking Trail', '🥾'),
  cycling('Cycling Route', '🚴'),
  walking('Walking Path', '🚶');

  final String displayName;
  final String icon;
  const RouteType(this.displayName, this.icon);
}

/// Difficulty levels
enum RouteDifficulty {
  easy('Easy', '✓'),
  moderate('Moderate', '⚠'),
  challenging('Challenging', '⚠⚠'),
  difficult('Difficult', '⚠⚠⚠');

  final String displayName;
  final String icon;
  const RouteDifficulty(this.displayName, this.icon);
}

/// Curated travel route
class Route {
  final String id;
  final String name;
  final String description;
  final RouteType type;
  final RouteDifficulty difficulty;

  // Route path
  final List<LatLng> waypoints;
  final List<RouteSegment> segments;

  // Stats
  final double distanceKm;
  final Duration estimatedDuration;
  final double? elevationGainMeters;

  // Metadata
  final double rating;
  final int completedCount;
  final List<String> highlights;
  final List<String> photoUrls;
  final String? coverPhotoUrl;

  // Location
  final String region;
  final LatLng startPoint;
  final LatLng endPoint;

  // Timestamps
  final DateTime createdAt;
  final DateTime? lastCompletedAt;

  Route({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.waypoints,
    this.segments = const [],
    required this.distanceKm,
    required this.estimatedDuration,
    this.elevationGainMeters,
    this.rating = 0.0,
    this.completedCount = 0,
    this.highlights = const [],
    this.photoUrls = const [],
    this.coverPhotoUrl,
    required this.region,
    required this.startPoint,
    required this.endPoint,
    required this.createdAt,
    this.lastCompletedAt,
  });

  /// Get formatted distance
  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';

  /// Get formatted duration
  String get formattedDuration {
    final hours = estimatedDuration.inHours;
    final minutes = estimatedDuration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get elevation gain formatted
  String? get formattedElevation {
    if (elevationGainMeters == null) return null;
    return '${elevationGainMeters!.toStringAsFixed(0)}m';
  }

  /// Check if route has segments
  bool get hasSegments => segments.isNotEmpty;

  /// Copy with method
  Route copyWith({
    String? id,
    String? name,
    String? description,
    RouteType? type,
    RouteDifficulty? difficulty,
    List<LatLng>? waypoints,
    List<RouteSegment>? segments,
    double? distanceKm,
    Duration? estimatedDuration,
    double? elevationGainMeters,
    double? rating,
    int? completedCount,
    List<String>? highlights,
    List<String>? photoUrls,
    String? coverPhotoUrl,
    String? region,
    LatLng? startPoint,
    LatLng? endPoint,
    DateTime? createdAt,
    DateTime? lastCompletedAt,
  }) {
    return Route(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      waypoints: waypoints ?? this.waypoints,
      segments: segments ?? this.segments,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      elevationGainMeters: elevationGainMeters ?? this.elevationGainMeters,
      rating: rating ?? this.rating,
      completedCount: completedCount ?? this.completedCount,
      highlights: highlights ?? this.highlights,
      photoUrls: photoUrls ?? this.photoUrls,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      region: region ?? this.region,
      startPoint: startPoint ?? this.startPoint,
      endPoint: endPoint ?? this.endPoint,
      createdAt: createdAt ?? this.createdAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
    );
  }
}

/// Hidden segment within a route (like Strava segments)
class RouteSegment {
  final String id;
  final String name;
  final String description;

  // Location
  final LatLng startPoint;
  final LatLng endPoint;
  final double distanceKm;

  // Type of segment
  final SegmentType type;

  // Stats
  final int discoveredByCount;
  final double? bestTimeMinutes;

  // Points
  final int pointsReward;

  // Metadata
  final List<String> photoUrls;
  final DateTime createdAt;

  RouteSegment({
    required this.id,
    required this.name,
    required this.description,
    required this.startPoint,
    required this.endPoint,
    required this.distanceKm,
    required this.type,
    this.discoveredByCount = 0,
    this.bestTimeMinutes,
    this.pointsReward = 50,
    this.photoUrls = const [],
    required this.createdAt,
  });

  /// Get formatted distance
  String get formattedDistance => '${distanceKm.toStringAsFixed(2)} km';

  /// Get formatted best time
  String? get formattedBestTime {
    if (bestTimeMinutes == null) return null;
    final hours = bestTimeMinutes! ~/ 60;
    final minutes = bestTimeMinutes!.remainder(60).toInt();
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

/// Types of segments
enum SegmentType {
  scenic('Scenic Spot', '🌅'),
  wildlife('Wildlife Spot', '🦁'),
  viewpoint('Viewpoint', '👁'),
  waterfall('Waterfall', '💧'),
  historical('Historical Site', '🏛'),
  photo('Photo Opportunity', '📸');

  final String displayName;
  final String icon;
  const SegmentType(this.displayName, this.icon);
}

/// Mock route data for testing
class MockRouteData {
  static List<Route> getMockRoutes() {
    return [
      Route(
        id: '1',
        name: 'Rift Valley Panorama',
        description: 'Breathtaking drive through the Great Rift Valley with stunning viewpoints and wildlife sightings',
        type: RouteType.scenic,
        difficulty: RouteDifficulty.moderate,
        waypoints: [
          LatLng(-0.9231, 36.0566), // Naivasha
          LatLng(-0.6833, 36.2167), // Nakuru
          LatLng(-0.2833, 36.0667), // Elementaita
        ],
        segments: [
          RouteSegment(
            id: 's1',
            name: 'Crescent Island Viewpoint',
            description: 'Panoramic view of Lake Naivasha',
            startPoint: LatLng(-0.7500, 36.3500),
            endPoint: LatLng(-0.7550, 36.3550),
            distanceKm: 0.8,
            type: SegmentType.viewpoint,
            discoveredByCount: 156,
            pointsReward: 75,
            createdAt: DateTime.now().subtract(const Duration(days: 90)),
          ),
        ],
        distanceKm: 95.5,
        estimatedDuration: const Duration(hours: 3, minutes: 30),
        elevationGainMeters: 450,
        rating: 4.8,
        completedCount: 234,
        highlights: [
          'Lake Naivasha views',
          'Flamingo colonies',
          'Escarpment vistas',
        ],
        region: 'Rift Valley',
        startPoint: LatLng(-0.9231, 36.0566),
        endPoint: LatLng(-0.2833, 36.0667),
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
      ),
      Route(
        id: '2',
        name: 'Mount Kenya Forest Trail',
        description: 'Dense montane forest hike with bamboo groves and mountain views',
        type: RouteType.hiking,
        difficulty: RouteDifficulty.challenging,
        waypoints: [
          LatLng(-0.1521, 37.3084),
          LatLng(-0.1600, 37.3200),
          LatLng(-0.1700, 37.3300),
        ],
        segments: [],
        distanceKm: 12.3,
        estimatedDuration: const Duration(hours: 5),
        elevationGainMeters: 800,
        rating: 4.9,
        completedCount: 89,
        highlights: [
          'Ancient cedar trees',
          'Mountain streams',
          'Wildlife corridors',
        ],
        region: 'Central Kenya',
        startPoint: LatLng(-0.1521, 37.3084),
        endPoint: LatLng(-0.1700, 37.3300),
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      Route(
        id: '3',
        name: 'Coastal Heritage Path',
        description: 'Historic walking route through Old Town Mombasa with cultural landmarks',
        type: RouteType.walking,
        difficulty: RouteDifficulty.easy,
        waypoints: [
          LatLng(-4.0435, 39.6682), // Fort Jesus
          LatLng(-4.0500, 39.6700), // Old Town
          LatLng(-4.0550, 39.6750), // Spice Market
        ],
        segments: [
          RouteSegment(
            id: 's2',
            name: 'Fort Jesus Ramparts',
            description: 'Historic Portuguese fort with ocean views',
            startPoint: LatLng(-4.0435, 39.6682),
            endPoint: LatLng(-4.0440, 39.6690),
            distanceKm: 0.3,
            type: SegmentType.historical,
            discoveredByCount: 423,
            pointsReward: 100,
            createdAt: DateTime.now().subtract(const Duration(days: 200)),
          ),
        ],
        distanceKm: 3.2,
        estimatedDuration: const Duration(hours: 2),
        rating: 4.6,
        completedCount: 512,
        highlights: [
          'Swahili architecture',
          'Spice markets',
          'Ocean views',
        ],
        region: 'Coastal Kenya',
        startPoint: LatLng(-4.0435, 39.6682),
        endPoint: LatLng(-4.0550, 39.6750),
        createdAt: DateTime.now().subtract(const Duration(days: 250)),
      ),
    ];
  }
}
