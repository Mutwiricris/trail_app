import 'package:flutter/foundation.dart';
import '../models/journey.dart';

/// Service for calculating and tracking exploration scores
class ExplorationScoreService extends ChangeNotifier {
  static final ExplorationScoreService _instance = ExplorationScoreService._internal();
  factory ExplorationScoreService() => _instance;
  ExplorationScoreService._internal();

  /// Score breakdown
  Map<String, int> _scoreBreakdown = {};
  int _totalScore = 0;

  /// Get total exploration score
  int get totalScore => _totalScore;

  /// Get score breakdown by category
  Map<String, int> get scoreBreakdown => Map.unmodifiable(_scoreBreakdown);

  /// Calculate exploration score from journeys
  void calculateScore(List<Journey> journeys) {
    final breakdown = <String, int>{
      'distance': 0,
      'places': 0,
      'diversity': 0,
      'consistency': 0,
      'exploration': 0,
    };

    if (journeys.isEmpty) {
      _scoreBreakdown = breakdown;
      _totalScore = 0;
      notifyListeners();
      return;
    }

    // 1. Distance score (0-300 points)
    final totalDistance = journeys.fold<double>(
      0.0,
      (sum, j) => sum + j.distanceKm,
    );
    breakdown['distance'] = _calculateDistanceScore(totalDistance);

    // 2. Places visited score (0-250 points)
    final totalPlaces = journeys.fold<int>(
      0,
      (sum, j) => sum + j.placesCount,
    );
    breakdown['places'] = _calculatePlacesScore(totalPlaces);

    // 3. Diversity score (0-200 points)
    breakdown['diversity'] = _calculateDiversityScore(journeys);

    // 4. Consistency score (0-150 points)
    breakdown['consistency'] = _calculateConsistencyScore(journeys);

    // 5. Exploration score (0-100 points)
    breakdown['exploration'] = _calculateExplorationScore(journeys);

    _scoreBreakdown = breakdown;
    _totalScore = breakdown.values.fold(0, (sum, score) => sum + score);

    notifyListeners();
  }

  /// Calculate distance score (max 300 points)
  int _calculateDistanceScore(double totalKm) {
    // 0-10km: 0-50 points
    // 10-50km: 50-150 points
    // 50-100km: 150-250 points
    // 100km+: 250-300 points

    if (totalKm <= 10) {
      return (totalKm * 5).toInt();
    } else if (totalKm <= 50) {
      return 50 + ((totalKm - 10) * 2.5).toInt();
    } else if (totalKm <= 100) {
      return 150 + ((totalKm - 50) * 2).toInt();
    } else {
      return (250 + ((totalKm - 100) * 0.5)).toInt().clamp(0, 300);
    }
  }

  /// Calculate places score (max 250 points)
  int _calculatePlacesScore(int totalPlaces) {
    // Each place worth 5 points, max 250
    return (totalPlaces * 5).clamp(0, 250);
  }

  /// Calculate diversity score (max 200 points)
  int _calculateDiversityScore(List<Journey> journeys) {
    // Points for exploring different types of journeys
    final types = journeys.map((j) => j.type).toSet();
    final typeScore = types.length * 30; // 30 points per unique type

    // Points for visiting different times
    final morningJourneys = journeys.where((j) => j.startTime.hour < 12).length;
    final afternoonJourneys = journeys.where((j) => j.startTime.hour >= 12 && j.startTime.hour < 18).length;
    final eveningJourneys = journeys.where((j) => j.startTime.hour >= 18).length;

    int timeScore = 0;
    if (morningJourneys > 0) timeScore += 20;
    if (afternoonJourneys > 0) timeScore += 20;
    if (eveningJourneys > 0) timeScore += 20;

    // Points for varying distances
    final shortTrips = journeys.where((j) => j.distanceKm < 2).length;
    final mediumTrips = journeys.where((j) => j.distanceKm >= 2 && j.distanceKm < 5).length;
    final longTrips = journeys.where((j) => j.distanceKm >= 5).length;

    int distanceVarietyScore = 0;
    if (shortTrips > 0) distanceVarietyScore += 20;
    if (mediumTrips > 0) distanceVarietyScore += 20;
    if (longTrips > 0) distanceVarietyScore += 20;

    return (typeScore + timeScore + distanceVarietyScore).clamp(0, 200);
  }

  /// Calculate consistency score (max 150 points)
  int _calculateConsistencyScore(List<Journey> journeys) {
    if (journeys.isEmpty) return 0;

    // Sort by date
    final sortedJourneys = List<Journey>.from(journeys)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    // Calculate streaks
    int currentStreak = 1;
    int maxStreak = 1;

    for (int i = 1; i < sortedJourneys.length; i++) {
      final daysDiff = sortedJourneys[i].startTime.difference(
        sortedJourneys[i - 1].startTime
      ).inDays;

      if (daysDiff <= 1) {
        currentStreak++;
        maxStreak = maxStreak > currentStreak ? maxStreak : currentStreak;
      } else {
        currentStreak = 1;
      }
    }

    // Streak bonus (0-80 points)
    final streakScore = (maxStreak * 5).clamp(0, 80);

    // Frequency bonus (0-70 points)
    final daysActive = sortedJourneys
        .map((j) => DateTime(j.startTime.year, j.startTime.month, j.startTime.day))
        .toSet()
        .length;
    final frequencyScore = (daysActive * 3).clamp(0, 70);

    return streakScore + frequencyScore;
  }

  /// Calculate exploration score (max 100 points)
  int _calculateExplorationScore(List<Journey> journeys) {
    // Bonus points for exploration behavior
    int score = 0;

    // Long journeys bonus (5+ km)
    final longJourneys = journeys.where((j) => j.distanceKm >= 5).length;
    score += (longJourneys * 10).clamp(0, 40);

    // Many waypoints bonus (5+ places)
    final explorativeJourneys = journeys.where((j) => j.placesCount >= 5).length;
    score += (explorativeJourneys * 8).clamp(0, 40);

    // Weekend explorer bonus
    final weekendJourneys = journeys.where((j) {
      final weekday = j.startTime.weekday;
      return weekday == 6 || weekday == 7; // Saturday or Sunday
    }).length;
    score += (weekendJourneys * 5).clamp(0, 20);

    return score.clamp(0, 100);
  }

  /// Get exploration level based on score
  ExplorationLevel getLevel() {
    if (_totalScore < 200) return ExplorationLevel.novice;
    if (_totalScore < 500) return ExplorationLevel.explorer;
    if (_totalScore < 800) return ExplorationLevel.pathfinder;
    if (_totalScore < 1200) return ExplorationLevel.trailblazer;
    return ExplorationLevel.legend;
  }

  /// Get score rank (percentile)
  int getPercentile() {
    // Mock percentile calculation
    // In real app, compare against all users
    if (_totalScore < 100) return 10;
    if (_totalScore < 300) return 25;
    if (_totalScore < 600) return 50;
    if (_totalScore < 900) return 75;
    return 90;
  }

  /// Get insights based on scores
  List<ScoreInsight> getInsights(List<Journey> journeys) {
    final insights = <ScoreInsight>[];

    // Distance insight
    final totalDistance = journeys.fold<double>(0.0, (sum, j) => sum + j.distanceKm);
    if (totalDistance < 10) {
      insights.add(ScoreInsight(
        title: 'Distance Goal',
        description: 'Travel ${(10 - totalDistance).toStringAsFixed(1)} km more to boost your distance score!',
        icon: 'directions_walk',
        category: 'distance',
        potentialPoints: 50 - _scoreBreakdown['distance']!,
      ));
    }

    // Diversity insight
    final types = journeys.map((j) => j.type).toSet();
    if (types.length < JourneyType.values.length) {
      insights.add(ScoreInsight(
        title: 'Explore New Types',
        description: 'Try ${JourneyType.values.length - types.length} new journey types to increase diversity!',
        icon: 'explore',
        category: 'diversity',
        potentialPoints: (JourneyType.values.length - types.length) * 30,
      ));
    }

    // Places insight
    final totalPlaces = journeys.fold<int>(0, (sum, j) => sum + j.placesCount);
    if (totalPlaces < 50) {
      insights.add(ScoreInsight(
        title: 'Hidden Gems',
        description: 'Discover ${50 - totalPlaces} more places to maximize your score!',
        icon: 'place',
        category: 'places',
        potentialPoints: (50 - totalPlaces) * 5,
      ));
    }

    // Consistency insight
    if (journeys.length < 10) {
      insights.add(ScoreInsight(
        title: 'Build a Streak',
        description: 'Complete journeys regularly to boost consistency score!',
        icon: 'local_fire_department',
        category: 'consistency',
        potentialPoints: 80,
      ));
    }

    return insights;
  }
}

/// Exploration level enum
enum ExplorationLevel {
  novice,
  explorer,
  pathfinder,
  trailblazer,
  legend;

  String get displayName {
    switch (this) {
      case ExplorationLevel.novice:
        return 'Novice';
      case ExplorationLevel.explorer:
        return 'Explorer';
      case ExplorationLevel.pathfinder:
        return 'Pathfinder';
      case ExplorationLevel.trailblazer:
        return 'Trailblazer';
      case ExplorationLevel.legend:
        return 'Legend';
    }
  }

  String get icon {
    switch (this) {
      case ExplorationLevel.novice:
        return '🌱';
      case ExplorationLevel.explorer:
        return '🗺️';
      case ExplorationLevel.pathfinder:
        return '🧭';
      case ExplorationLevel.trailblazer:
        return '⛰️';
      case ExplorationLevel.legend:
        return '🏆';
    }
  }

  int get minScore {
    switch (this) {
      case ExplorationLevel.novice:
        return 0;
      case ExplorationLevel.explorer:
        return 200;
      case ExplorationLevel.pathfinder:
        return 500;
      case ExplorationLevel.trailblazer:
        return 800;
      case ExplorationLevel.legend:
        return 1200;
    }
  }

  int? get nextLevelScore {
    switch (this) {
      case ExplorationLevel.novice:
        return 200;
      case ExplorationLevel.explorer:
        return 500;
      case ExplorationLevel.pathfinder:
        return 800;
      case ExplorationLevel.trailblazer:
        return 1200;
      case ExplorationLevel.legend:
        return null; // Max level
    }
  }
}

/// Score insight model
class ScoreInsight {
  final String title;
  final String description;
  final String icon;
  final String category;
  final int potentialPoints;

  ScoreInsight({
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.potentialPoints,
  });
}
