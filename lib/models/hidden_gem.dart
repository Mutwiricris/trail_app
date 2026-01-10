import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Hidden gem category
enum GemCategory {
  nature,
  culture,
  adventure,
  food,
  views;

  String get displayName {
    switch (this) {
      case GemCategory.nature:
        return 'Nature';
      case GemCategory.culture:
        return 'Culture';
      case GemCategory.adventure:
        return 'Adventure';
      case GemCategory.food:
        return 'Food';
      case GemCategory.views:
        return 'Views';
    }
  }

  String get icon {
    switch (this) {
      case GemCategory.nature:
        return '🌿';
      case GemCategory.culture:
        return '🏛️';
      case GemCategory.adventure:
        return '🧗';
      case GemCategory.food:
        return '🍽️';
      case GemCategory.views:
        return '🌄';
    }
  }

  Color get color {
    switch (this) {
      case GemCategory.nature:
        return AppColors.success;
      case GemCategory.culture:
        return AppColors.berryCrush;
      case GemCategory.adventure:
        return AppColors.error;
      case GemCategory.food:
        return AppColors.warning;
      case GemCategory.views:
        return AppColors.info;
    }
  }

  IconData get iconData {
    switch (this) {
      case GemCategory.nature:
        return Icons.forest;
      case GemCategory.culture:
        return Icons.museum;
      case GemCategory.adventure:
        return Icons.hiking;
      case GemCategory.food:
        return Icons.restaurant;
      case GemCategory.views:
        return Icons.landscape;
    }
  }
}

/// Hidden gem model
class HiddenGem {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final GemCategory category;
  final List<String> photoUrls;
  final double rating;
  final int discoveredBy;
  final String addedBy;
  final DateTime createdAt;

  HiddenGem({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.photoUrls = const [],
    this.rating = 0.0,
    this.discoveredBy = 0,
    required this.addedBy,
    required this.createdAt,
  });

  LatLng get location => LatLng(latitude, longitude);

  String get formattedRating => rating.toStringAsFixed(1);

  /// Get the color for this gem's category
  Color get categoryColor => category.color;

  /// Get the icon for this gem's category
  IconData get categoryIcon => category.iconData;

  /// Get the discovery count (alias for discoveredBy)
  int get discoveryCount => discoveredBy;
}

/// Mock data for hidden gems
class MockGemsData {
  static List<HiddenGem> getMockGems() {
    return [
      HiddenGem(
        id: '1',
        name: 'Secret Waterfall, Nyeri',
        description: 'A hidden waterfall deep in the forest, accessible only by a short hike.',
        latitude: -0.4167,
        longitude: 36.9500,
        category: GemCategory.nature,
        photoUrls: [],
        rating: 4.8,
        discoveredBy: 23,
        addedBy: 'user1',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      HiddenGem(
        id: '2',
        name: 'Traditional Village Market',
        description: 'Authentic local market with crafts and traditional foods.',
        latitude: -1.2833,
        longitude: 36.8167,
        category: GemCategory.culture,
        photoUrls: [],
        rating: 4.5,
        discoveredBy: 45,
        addedBy: 'user2',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      HiddenGem(
        id: '3',
        name: 'Sunset Viewpoint',
        description: 'Amazing panoramic views of the Rift Valley at sunset.',
        latitude: -0.9000,
        longitude: 36.0833,
        category: GemCategory.views,
        photoUrls: [],
        rating: 4.9,
        discoveredBy: 67,
        addedBy: 'user3',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
