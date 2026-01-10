import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'achievement.g.dart';

/// Hive type IDs:
/// 0: Journey
/// 1: Waypoint
/// 2: Memory
/// 3: (reserved for Achievement - not used, stored in memory only)
/// 4: UserAchievementProgress

/// Achievement categories
enum AchievementCategory {
  exploration,
  distance,
  social,
  photography,
  consistency,
  special,
}

/// Achievement rarity levels
enum AchievementRarity {
  common,
  rare,
  epic,
  legendary,
}

/// Achievement data model
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final int requiredValue;
  final int currentValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int xpReward;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    required this.rarity,
    required this.requiredValue,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.xpReward,
  });

  /// Progress percentage (0.0 to 1.0)
  double get progress {
    if (isUnlocked) return 1.0;
    if (requiredValue == 0) return 0.0;
    return (currentValue / requiredValue).clamp(0.0, 1.0);
  }

  /// Progress text
  String get progressText {
    if (isUnlocked) return 'Completed';
    return '$currentValue / $requiredValue';
  }

  /// Rarity display name
  String get rarityName {
    switch (rarity) {
      case AchievementRarity.common:
        return 'Common';
      case AchievementRarity.rare:
        return 'Rare';
      case AchievementRarity.epic:
        return 'Epic';
      case AchievementRarity.legendary:
        return 'Legendary';
    }
  }

  /// Rarity color
  Color get rarityColor {
    switch (rarity) {
      case AchievementRarity.common:
        return const Color(0xFF9E9E9E);
      case AchievementRarity.rare:
        return const Color(0xFF2196F3);
      case AchievementRarity.epic:
        return const Color(0xFF9C27B0);
      case AchievementRarity.legendary:
        return const Color(0xFFFF9800);
    }
  }

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? color,
    AchievementCategory? category,
    AchievementRarity? rarity,
    int? requiredValue,
    int? currentValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? xpReward,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      requiredValue: requiredValue ?? this.requiredValue,
      currentValue: currentValue ?? this.currentValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      xpReward: xpReward ?? this.xpReward,
    );
  }
}

/// User achievement progress tracker
@HiveType(typeId: 4)
class UserAchievementProgress extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final Map<String, int> progressValues;

  @HiveField(2)
  final List<String> unlockedAchievements;

  @HiveField(3)
  final int totalXP;

  UserAchievementProgress({
    required this.userId,
    Map<String, int>? progressValues,
    List<String>? unlockedAchievements,
    this.totalXP = 0,
  })  : progressValues = progressValues ?? {},
        unlockedAchievements = unlockedAchievements ?? [];

  UserAchievementProgress copyWith({
    String? userId,
    Map<String, int>? progressValues,
    List<String>? unlockedAchievements,
    int? totalXP,
  }) {
    return UserAchievementProgress(
      userId: userId ?? this.userId,
      progressValues: progressValues ?? this.progressValues,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      totalXP: totalXP ?? this.totalXP,
    );
  }
}
