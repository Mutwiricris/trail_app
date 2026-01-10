import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Service for fetching navigation routes using OSRM (Open Source Routing Machine)
class RoutingService {
  // OSRM demo server - free and open source
  // For production, consider hosting your own OSRM instance
  static const String _baseUrl = 'https://router.project-osrm.org';

  /// Fetch route from start to destination
  /// Returns route polyline points, distance in meters, and duration in seconds
  Future<RouteResult?> getRoute({
    required LatLng start,
    required LatLng destination,
    String profile = 'driving', // driving, walking, cycling
  }) async {
    try {
      // Build OSRM API URL
      // Format: /route/v1/{profile}/{coordinates}?overview=full&geometries=polyline
      final url = Uri.parse(
        '$_baseUrl/route/v1/$profile/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson&steps=true',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Route request timed out');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          final coordinates = geometry['coordinates'] as List;

          // Convert coordinates to LatLng points
          final points = coordinates.map((coord) {
            return LatLng(coord[1].toDouble(), coord[0].toDouble());
          }).toList();

          // Extract distance and duration
          final distance = (route['distance'] as num).toDouble(); // meters
          final duration = (route['duration'] as num).toDouble(); // seconds

          // Extract turn-by-turn steps if available
          final steps = <RouteStep>[];
          if (route['legs'] != null && route['legs'].isNotEmpty) {
            final leg = route['legs'][0];
            if (leg['steps'] != null) {
              for (var step in leg['steps']) {
                steps.add(RouteStep(
                  instruction: step['maneuver']['instruction'] ?? '',
                  distance: (step['distance'] as num).toDouble(),
                  duration: (step['duration'] as num).toDouble(),
                  location: LatLng(
                    step['maneuver']['location'][1].toDouble(),
                    step['maneuver']['location'][0].toDouble(),
                  ),
                ));
              }
            }
          }

          return RouteResult(
            points: points,
            distanceMeters: distance,
            durationSeconds: duration,
            steps: steps,
            profile: profile,
          );
        }
      }

      return null;
    } catch (e) {
      print('Error fetching route: $e');
      return null;
    }
  }

  /// Get multiple route alternatives
  Future<List<RouteResult>> getRouteAlternatives({
    required LatLng start,
    required LatLng destination,
    String profile = 'driving',
    int alternatives = 3,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/route/v1/$profile/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson&alternatives=$alternatives',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 'Ok' && data['routes'] != null) {
          final routes = <RouteResult>[];

          for (var route in data['routes']) {
            final geometry = route['geometry'];
            final coordinates = geometry['coordinates'] as List;

            final points = coordinates.map((coord) {
              return LatLng(coord[1].toDouble(), coord[0].toDouble());
            }).toList();

            final distance = (route['distance'] as num).toDouble();
            final duration = (route['duration'] as num).toDouble();

            routes.add(RouteResult(
              points: points,
              distanceMeters: distance,
              durationSeconds: duration,
              steps: [],
              profile: profile,
            ));
          }

          return routes;
        }
      }

      return [];
    } catch (e) {
      print('Error fetching route alternatives: $e');
      return [];
    }
  }
}

/// Result of a route query
class RouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;
  final List<RouteStep> steps;
  final String profile; // driving, walking, cycling

  RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.steps,
    this.profile = 'driving',
  });

  /// Get distance in kilometers (actual distance from OSRM)
  double get distanceKm => distanceMeters / 1000;

  /// Get realistic duration in minutes with real-world corrections
  /// OSRM gives ideal times, we add buffers for traffic, stops, and terrain
  double get durationMinutes {
    final idealMinutes = durationSeconds / 60;

    // Apply real-world correction factors based on transport mode
    double correctionFactor;
    switch (profile) {
      case 'driving':
        // Add 25% for traffic, stops, signals in urban areas
        correctionFactor = 1.25;
        break;
      case 'walking':
        // Add 15% for terrain variations, rest breaks
        correctionFactor = 1.15;
        break;
      case 'cycling':
        // Add 20% for hills, traffic navigation
        correctionFactor = 1.20;
        break;
      default:
        correctionFactor = 1.25;
    }

    return idealMinutes * correctionFactor;
  }

  /// Get formatted distance string
  String get formattedDistance {
    if (distanceKm < 1) {
      return '${distanceMeters.toStringAsFixed(0)} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  /// Get formatted duration string
  String get formattedDuration {
    final hours = (durationMinutes / 60).floor();
    final minutes = (durationMinutes % 60).round();

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    }
    return '${minutes}min';
  }
}

/// A single step in the route (turn-by-turn instruction)
class RouteStep {
  final String instruction;
  final double distance;
  final double duration;
  final LatLng location;

  RouteStep({
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.location,
  });
}
