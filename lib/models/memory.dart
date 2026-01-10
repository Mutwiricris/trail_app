import 'package:hive/hive.dart';

part 'memory.g.dart';

/// Memory model for "On This Day" feature
@HiveType(typeId: 2)
class Memory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String journeyId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final DateTime originalDate;

  @HiveField(5)
  final String? photoUrl;

  @HiveField(6)
  final Map<String, dynamic> stats;

  @HiveField(7)
  final DateTime createdAt;

  Memory({
    required this.id,
    required this.journeyId,
    required this.title,
    this.description,
    required this.originalDate,
    this.photoUrl,
    required this.stats,
    required this.createdAt,
  });

  /// Calculate years since the memory
  int get yearsAgo {
    final now = DateTime.now();
    return now.year - originalDate.year;
  }

  /// Get formatted time ago string
  String get timeAgoText {
    if (yearsAgo == 1) return '1 Year Ago';
    if (yearsAgo > 1) return '$yearsAgo Years Ago';

    final monthsAgo = DateTime.now().month - originalDate.month;
    if (monthsAgo == 1) return '1 Month Ago';
    if (monthsAgo > 1) return '$monthsAgo Months Ago';

    return 'Recently';
  }

  /// Check if this memory should be shown today
  bool get shouldShowToday {
    final now = DateTime.now();
    return now.month == originalDate.month &&
           now.day == originalDate.day &&
           now.year > originalDate.year;
  }

  Memory copyWith({
    String? id,
    String? journeyId,
    String? title,
    String? description,
    DateTime? originalDate,
    String? photoUrl,
    Map<String, dynamic>? stats,
    DateTime? createdAt,
  }) {
    return Memory(
      id: id ?? this.id,
      journeyId: journeyId ?? this.journeyId,
      title: title ?? this.title,
      description: description ?? this.description,
      originalDate: originalDate ?? this.originalDate,
      photoUrl: photoUrl ?? this.photoUrl,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
