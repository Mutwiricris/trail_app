/// Feed item types
enum FeedItemType {
  journey,
  gem,
  photo,
  achievement;
}

/// Reaction types (Kudos-style)
enum ReactionType {
  inspired,
  respect,
  adventurous;

  String get emoji {
    switch (this) {
      case ReactionType.inspired:
        return '💡';
      case ReactionType.respect:
        return '🔥';
      case ReactionType.adventurous:
        return '🌍';
    }
  }

  String get label {
    switch (this) {
      case ReactionType.inspired:
        return 'Inspired';
      case ReactionType.respect:
        return 'Respect';
      case ReactionType.adventurous:
        return 'Adventurous';
    }
  }
}

/// Feed item model
class FeedItem {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final FeedItemType type;
  final String title;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;
  final int reactionsCount;
  final List<ReactionType> userReactions;

  FeedItem({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.type,
    required this.title,
    this.description,
    this.imageUrl,
    required this.createdAt,
    this.reactionsCount = 0,
    this.userReactions = const [],
  });

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Mock feed data
class MockFeedData {
  static List<FeedItem> getMockFeed() {
    return [
      FeedItem(
        id: '1',
        userId: 'user1',
        userName: 'Sarah K.',
        type: FeedItemType.gem,
        title: 'discovered a waterfall in Nyeri',
        description: 'Secret Falls, Nyeri',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        reactionsCount: 12,
      ),
      FeedItem(
        id: '2',
        userId: 'user2',
        userName: 'Chris M.',
        type: FeedItemType.journey,
        title: 'completed a safari journey',
        description: 'Masai Mara Safari • 145 km • 6h 30min',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        reactionsCount: 8,
      ),
      FeedItem(
        id: '3',
        userId: 'user3',
        userName: 'Jane D.',
        type: FeedItemType.achievement,
        title: 'unlocked Sunrise Hunter badge',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        reactionsCount: 15,
      ),
    ];
  }
}
