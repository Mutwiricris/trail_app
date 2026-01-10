import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'wishlist_item.g.dart';

/// Type of wishlist item
enum WishlistItemType {
  @HiveField(0)
  gem, // Hidden gem
  @HiveField(1)
  safari, // Safari/tour
  @HiveField(2)
  route // Route/destination
}

/// Wishlist item - represents a saved/bookmarked place for future trips
///
/// Used for quick bookmarking of interesting places that users want to
/// visit later. Items can be moved to trips when planning itineraries.
@HiveType(typeId: 9)
class WishlistItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final WishlistItemType type;

  @HiveField(2)
  final String referenceId; // ID of gem/safari/route

  @HiveField(3)
  String name;

  @HiveField(4)
  String? description;

  // Cached data for offline viewing
  @HiveField(5)
  final double latitude;

  @HiveField(6)
  final double longitude;

  @HiveField(7)
  String? coverPhotoUrl;

  @HiveField(8)
  double? rating;

  // Metadata
  @HiveField(9)
  final DateTime savedAt;

  @HiveField(10)
  final String userId;

  @HiveField(11)
  String? notes;

  // Priority/organization
  @HiveField(12)
  int priority; // 0=low, 1=medium, 2=high

  @HiveField(13)
  List<String>? tags;

  WishlistItem({
    String? id,
    required this.type,
    required this.referenceId,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    this.coverPhotoUrl,
    this.rating,
    DateTime? savedAt,
    required this.userId,
    this.notes,
    int? priority,
    this.tags,
  })  : id = id ?? const Uuid().v4(),
        savedAt = savedAt ?? DateTime.now(),
        priority = priority ?? 0;

  /// Get priority label
  String get priorityLabel {
    switch (priority) {
      case 2:
        return 'High';
      case 1:
        return 'Medium';
      default:
        return 'Low';
    }
  }

  /// Whether item is high priority
  bool get isHighPriority => priority == 2;

  /// Copy with method
  WishlistItem copyWith({
    String? id,
    WishlistItemType? type,
    String? referenceId,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    String? coverPhotoUrl,
    double? rating,
    DateTime? savedAt,
    String? userId,
    String? notes,
    int? priority,
    List<String>? tags,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      rating: rating ?? this.rating,
      savedAt: savedAt ?? this.savedAt,
      userId: userId ?? this.userId,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
    );
  }
}
