import 'package:hive/hive.dart';

part 'challenge.g.dart';

/// Types of challenges
enum ChallengeType {
  daily('Daily Challenge', '📅'),
  weekly('Weekly Challenge', '📆'),
  monthly('Monthly Challenge', '🗓'),
  special('Special Event', '⭐');

  final String displayName;
  final String icon;
  const ChallengeType(this.displayName, this.icon);
}

/// Challenge categories
enum ChallengeCategory {
  distance('Distance', Icons.route),
  exploration('Exploration', Icons.explore),
  social('Social', Icons.people),
  photography('Photography', Icons.camera_alt),
  consistency('Consistency', Icons.calendar_today);

  final String displayName;
  final IconData icon;
  const ChallengeCategory(this.displayName, this.icon);
}

@HiveType(typeId: 5)
class Challenge {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final ChallengeType type;

  @HiveField(4)
  final ChallengeCategory category;

  @HiveField(5)
  final int targetValue;

  @HiveField(6)
  final int currentProgress;

  @HiveField(7)
  final int xpReward;

  @HiveField(8)
  final DateTime startDate;

  @HiveField(9)
  final DateTime endDate;

  @HiveField(10)
  final bool isCompleted;

  @HiveField(11)
  final DateTime? completedAt;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.targetValue,
    this.currentProgress = 0,
    required this.xpReward,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.completedAt,
  });

  /// Get progress percentage
  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    return (currentProgress / targetValue).clamp(0.0, 1.0);
  }

  /// Get remaining time
  Duration get timeRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return Duration.zero;
    return endDate.difference(now);
  }

  /// Check if challenge is active
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate) && !isCompleted;
  }

  /// Check if challenge is expired
  bool get isExpired {
    return DateTime.now().isAfter(endDate) && !isCompleted;
  }

  /// Get formatted time remaining
  String get formattedTimeRemaining {
    if (isCompleted) return 'Completed';
    if (isExpired) return 'Expired';

    final remaining = timeRemaining;
    if (remaining.inDays > 0) {
      return '${remaining.inDays}d ${remaining.inHours.remainder(24)}h left';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes.remainder(60)}m left';
    } else {
      return '${remaining.inMinutes}m left';
    }
  }

  /// Copy with method
  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    ChallengeType? type,
    ChallengeCategory? category,
    int? targetValue,
    int? currentProgress,
    int? xpReward,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      targetValue: targetValue ?? this.targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      xpReward: xpReward ?? this.xpReward,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// Icon workaround for Hive
class IconData {
  final int codePoint;
  const IconData(this.codePoint);
}

class Icons {
  static const route = IconData(0xe548);
  static const explore = IconData(0xe3b7);
  static const people = IconData(0xe534);
  static const camera_alt = IconData(0xe3af);
  static const calendar_today = IconData(0xe935);
}
