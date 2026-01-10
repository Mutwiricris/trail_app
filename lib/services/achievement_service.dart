import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/achievement.dart';
import '../utils/app_colors.dart';

/// Service for managing achievements and tracking progress
class AchievementService extends ChangeNotifier {
  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  static const String _progressBoxName = 'achievement_progress';
  Box<UserAchievementProgress>? _progressBox;

  UserAchievementProgress? _userProgress;
  final List<Achievement> _achievements = [];

  /// Get all achievements
  List<Achievement> get achievements => _achievements;

  /// Get unlocked achievements
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();

  /// Get locked achievements
  List<Achievement> get lockedAchievements =>
      _achievements.where((a) => !a.isUnlocked).toList();

  /// Get achievements by category
  List<Achievement> getAchievementsByCategory(AchievementCategory category) {
    return _achievements.where((a) => a.category == category).toList();
  }

  /// Get total XP earned
  int get totalXP => _userProgress?.totalXP ?? 0;

  /// Get unlock percentage
  double get unlockPercentage {
    if (_achievements.isEmpty) return 0.0;
    return unlockedAchievements.length / _achievements.length;
  }

  /// Initialize achievement service
  Future<void> initialize() async {
    try {
      // Open progress box
      if (Hive.isBoxOpen(_progressBoxName)) {
        _progressBox = Hive.box<UserAchievementProgress>(_progressBoxName);
      } else {
        _progressBox = await Hive.openBox<UserAchievementProgress>(_progressBoxName);
      }

      // Load or create user progress
      _userProgress = _progressBox?.get('user_1') ??
          UserAchievementProgress(userId: 'user_1');

      // Initialize predefined achievements
      _initializeAchievements();

      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing achievement service: $e');
    }
  }

  /// Initialize predefined achievements
  void _initializeAchievements() {
    _achievements.clear();

    // Exploration achievements
    _achievements.addAll([
      Achievement(
        id: 'first_journey',
        title: 'First Steps',
        description: 'Complete your first journey',
        icon: Icons.flag,
        color: AppColors.success,
        category: AchievementCategory.exploration,
        rarity: AchievementRarity.common,
        requiredValue: 1,
        currentValue: _getProgress('journeys_completed'),
        isUnlocked: _isUnlocked('first_journey'),
        unlockedAt: _getUnlockedAt('first_journey'),
        xpReward: 50,
      ),
      Achievement(
        id: 'explorer_5',
        title: 'Explorer',
        description: 'Complete 5 journeys',
        icon: Icons.explore,
        color: AppColors.berryCrush,
        category: AchievementCategory.exploration,
        rarity: AchievementRarity.common,
        requiredValue: 5,
        currentValue: _getProgress('journeys_completed'),
        isUnlocked: _isUnlocked('explorer_5'),
        unlockedAt: _getUnlockedAt('explorer_5'),
        xpReward: 100,
      ),
      Achievement(
        id: 'adventurer_25',
        title: 'Adventurer',
        description: 'Complete 25 journeys',
        icon: Icons.terrain,
        color: AppColors.berryCrush,
        category: AchievementCategory.exploration,
        rarity: AchievementRarity.rare,
        requiredValue: 25,
        currentValue: _getProgress('journeys_completed'),
        isUnlocked: _isUnlocked('adventurer_25'),
        unlockedAt: _getUnlockedAt('adventurer_25'),
        xpReward: 250,
      ),
      Achievement(
        id: 'gem_finder',
        title: 'Gem Finder',
        description: 'Discover 10 hidden gems',
        icon: Icons.diamond,
        color: AppColors.warning,
        category: AchievementCategory.exploration,
        rarity: AchievementRarity.rare,
        requiredValue: 10,
        currentValue: _getProgress('gems_discovered'),
        isUnlocked: _isUnlocked('gem_finder'),
        unlockedAt: _getUnlockedAt('gem_finder'),
        xpReward: 200,
      ),
    ]);

    // Distance achievements
    _achievements.addAll([
      Achievement(
        id: 'distance_10km',
        title: 'Marathon Starter',
        description: 'Travel a total of 10 kilometers',
        icon: Icons.directions_walk,
        color: AppColors.info,
        category: AchievementCategory.distance,
        rarity: AchievementRarity.common,
        requiredValue: 10,
        currentValue: _getProgress('total_distance_km'),
        isUnlocked: _isUnlocked('distance_10km'),
        unlockedAt: _getUnlockedAt('distance_10km'),
        xpReward: 75,
      ),
      Achievement(
        id: 'distance_50km',
        title: 'Long Distance Walker',
        description: 'Travel a total of 50 kilometers',
        icon: Icons.trending_up,
        color: AppColors.info,
        category: AchievementCategory.distance,
        rarity: AchievementRarity.rare,
        requiredValue: 50,
        currentValue: _getProgress('total_distance_km'),
        isUnlocked: _isUnlocked('distance_50km'),
        unlockedAt: _getUnlockedAt('distance_50km'),
        xpReward: 200,
      ),
      Achievement(
        id: 'distance_100km',
        title: 'Century Explorer',
        description: 'Travel a total of 100 kilometers',
        icon: Icons.emoji_events,
        color: AppColors.warning,
        category: AchievementCategory.distance,
        rarity: AchievementRarity.epic,
        requiredValue: 100,
        currentValue: _getProgress('total_distance_km'),
        isUnlocked: _isUnlocked('distance_100km'),
        unlockedAt: _getUnlockedAt('distance_100km'),
        xpReward: 500,
      ),
    ]);

    // Consistency achievements
    _achievements.addAll([
      Achievement(
        id: 'streak_7',
        title: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        icon: Icons.local_fire_department,
        color: AppColors.error,
        category: AchievementCategory.consistency,
        rarity: AchievementRarity.rare,
        requiredValue: 7,
        currentValue: _getProgress('current_streak'),
        isUnlocked: _isUnlocked('streak_7'),
        unlockedAt: _getUnlockedAt('streak_7'),
        xpReward: 150,
      ),
      Achievement(
        id: 'streak_30',
        title: 'Unstoppable',
        description: 'Maintain a 30-day streak',
        icon: Icons.whatshot,
        color: AppColors.error,
        category: AchievementCategory.consistency,
        rarity: AchievementRarity.epic,
        requiredValue: 30,
        currentValue: _getProgress('current_streak'),
        isUnlocked: _isUnlocked('streak_30'),
        unlockedAt: _getUnlockedAt('streak_30'),
        xpReward: 500,
      ),
    ]);

    // Social achievements
    _achievements.addAll([
      Achievement(
        id: 'social_share_5',
        title: 'Social Explorer',
        description: 'Share 5 journeys',
        icon: Icons.share,
        color: AppColors.berryCrush,
        category: AchievementCategory.social,
        rarity: AchievementRarity.common,
        requiredValue: 5,
        currentValue: _getProgress('journeys_shared'),
        isUnlocked: _isUnlocked('social_share_5'),
        unlockedAt: _getUnlockedAt('social_share_5'),
        xpReward: 100,
      ),
      Achievement(
        id: 'reactions_50',
        title: 'Inspiring Explorer',
        description: 'Receive 50 reactions',
        icon: Icons.favorite,
        color: AppColors.error,
        category: AchievementCategory.social,
        rarity: AchievementRarity.rare,
        requiredValue: 50,
        currentValue: _getProgress('reactions_received'),
        isUnlocked: _isUnlocked('reactions_50'),
        unlockedAt: _getUnlockedAt('reactions_50'),
        xpReward: 200,
      ),
    ]);

    // Photography achievements
    _achievements.addAll([
      Achievement(
        id: 'photo_master',
        title: 'Photo Master',
        description: 'Capture 50 photos',
        icon: Icons.photo_camera,
        color: AppColors.categoryNature,
        category: AchievementCategory.photography,
        rarity: AchievementRarity.rare,
        requiredValue: 50,
        currentValue: _getProgress('photos_taken'),
        isUnlocked: _isUnlocked('photo_master'),
        unlockedAt: _getUnlockedAt('photo_master'),
        xpReward: 150,
      ),
    ]);

    // Special achievements
    _achievements.addAll([
      Achievement(
        id: 'sunrise_hunter',
        title: 'Sunrise Hunter',
        description: 'Complete a journey before 7 AM',
        icon: Icons.wb_sunny,
        color: AppColors.warning,
        category: AchievementCategory.special,
        rarity: AchievementRarity.epic,
        requiredValue: 1,
        currentValue: _getProgress('early_journeys'),
        isUnlocked: _isUnlocked('sunrise_hunter'),
        unlockedAt: _getUnlockedAt('sunrise_hunter'),
        xpReward: 300,
      ),
      Achievement(
        id: 'night_owl',
        title: 'Night Owl',
        description: 'Complete a journey after 9 PM',
        icon: Icons.nightlight_round,
        color: AppColors.berryCrushDark,
        category: AchievementCategory.special,
        rarity: AchievementRarity.epic,
        requiredValue: 1,
        currentValue: _getProgress('late_journeys'),
        isUnlocked: _isUnlocked('night_owl'),
        unlockedAt: _getUnlockedAt('night_owl'),
        xpReward: 300,
      ),
    ]);
  }

  /// Update achievement progress
  Future<void> updateProgress(String progressKey, int value) async {
    if (_userProgress == null) return;

    final currentProgress = _userProgress!.progressValues[progressKey] ?? 0;
    if (value <= currentProgress) return;

    // Update progress
    final updatedProgress = Map<String, int>.from(_userProgress!.progressValues);
    updatedProgress[progressKey] = value;

    _userProgress = _userProgress!.copyWith(progressValues: updatedProgress);

    // Check for newly unlocked achievements
    await _checkAchievements(progressKey, value);

    // Save progress
    await _saveProgress();

    notifyListeners();
  }

  /// Increment achievement progress
  Future<void> incrementProgress(String progressKey, {int amount = 1}) async {
    final currentValue = _getProgress(progressKey);
    await updateProgress(progressKey, currentValue + amount);
  }

  /// Check and unlock achievements
  Future<void> _checkAchievements(String progressKey, int value) async {
    for (final achievement in _achievements) {
      if (achievement.isUnlocked) continue;

      // Check if this achievement tracks this progress key
      final shouldCheck = _shouldCheckAchievement(achievement, progressKey);
      if (!shouldCheck) continue;

      // Check if requirement is met
      if (value >= achievement.requiredValue) {
        await _unlockAchievement(achievement.id);
      }
    }
  }

  /// Determine if achievement should be checked for this progress key
  bool _shouldCheckAchievement(Achievement achievement, String progressKey) {
    // Map progress keys to achievements
    if (progressKey == 'journeys_completed') {
      return ['first_journey', 'explorer_5', 'adventurer_25']
          .contains(achievement.id);
    }
    if (progressKey == 'gems_discovered') {
      return achievement.id == 'gem_finder';
    }
    if (progressKey == 'total_distance_km') {
      return ['distance_10km', 'distance_50km', 'distance_100km']
          .contains(achievement.id);
    }
    if (progressKey == 'current_streak') {
      return ['streak_7', 'streak_30'].contains(achievement.id);
    }
    if (progressKey == 'journeys_shared') {
      return achievement.id == 'social_share_5';
    }
    if (progressKey == 'reactions_received') {
      return achievement.id == 'reactions_50';
    }
    if (progressKey == 'photos_taken') {
      return achievement.id == 'photo_master';
    }
    if (progressKey == 'early_journeys') {
      return achievement.id == 'sunrise_hunter';
    }
    if (progressKey == 'late_journeys') {
      return achievement.id == 'night_owl';
    }
    return false;
  }

  /// Unlock an achievement
  Future<void> _unlockAchievement(String achievementId) async {
    if (_userProgress == null) return;

    // Check if already unlocked
    if (_userProgress!.unlockedAchievements.contains(achievementId)) return;

    // Find achievement
    final achievement = _achievements.firstWhere((a) => a.id == achievementId);

    // Update unlocked achievements
    final updatedUnlocked = List<String>.from(_userProgress!.unlockedAchievements);
    updatedUnlocked.add(achievementId);

    // Add XP reward
    final newXP = _userProgress!.totalXP + achievement.xpReward;

    _userProgress = _userProgress!.copyWith(
      unlockedAchievements: updatedUnlocked,
      totalXP: newXP,
    );

    // Update achievement object
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index != -1) {
      _achievements[index] = achievement.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
    }

    debugPrint('🏆 Achievement unlocked: ${achievement.title} (+${achievement.xpReward} XP)');

    await _saveProgress();
  }

  /// Save progress to Hive
  Future<void> _saveProgress() async {
    if (_userProgress == null || _progressBox == null) return;
    await _progressBox!.put('user_1', _userProgress!);
  }

  /// Get progress value for a key
  int _getProgress(String key) {
    return _userProgress?.progressValues[key] ?? 0;
  }

  /// Check if achievement is unlocked
  bool _isUnlocked(String achievementId) {
    return _userProgress?.unlockedAchievements.contains(achievementId) ?? false;
  }

  /// Get unlock timestamp
  DateTime? _getUnlockedAt(String achievementId) {
    // This would need to be stored separately in a more complete implementation
    return null;
  }

  /// Dispose resources
  @override
  void dispose() {
    _progressBox?.close();
    super.dispose();
  }
}
