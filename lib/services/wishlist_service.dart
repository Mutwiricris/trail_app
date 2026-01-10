import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/wishlist_item.dart';
import '../models/trip.dart';

/// Wishlist service for managing saved items
///
/// Handles quick bookmarking of interesting places (gems, safaris, routes)
/// that users want to visit later. Items can be moved to trips when planning.
class WishlistService extends ChangeNotifier {
  static const String _wishlistBoxName = 'wishlist_items';

  Box<WishlistItem>? _wishlistBox;

  /// Get all wishlist items
  List<WishlistItem> get wishlistItems {
    if (_wishlistBox == null) return [];
    return _wishlistBox!.values.toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt)); // Most recent first
  }

  /// Initialize Hive and boxes
  Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapter (typeId 9)
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(WishlistItemAdapter());
    }

    // Open boxes
    try {
      if (Hive.isBoxOpen(_wishlistBoxName)) {
        _wishlistBox = Hive.box<WishlistItem>(_wishlistBoxName);
      } else {
        _wishlistBox = await Hive.openBox<WishlistItem>(_wishlistBoxName);
      }

      debugPrint(
          'WishlistService initialized with ${wishlistItems.length} items');
    } catch (e) {
      debugPrint('Error opening wishlist box: $e');
      rethrow;
    }
  }

  // ==================== CRUD Operations ====================

  /// Add item to wishlist
  Future<WishlistItem> addToWishlist({
    required String referenceId,
    required WishlistItemType type,
    required String name,
    required String userId,
    String? description,
    required double latitude,
    required double longitude,
    String? coverPhotoUrl,
    double? rating,
    String? notes,
    int priority = 0,
    List<String>? tags,
  }) async {
    if (_wishlistBox == null) {
      throw Exception('WishlistService not initialized');
    }

    // Check if already in wishlist
    if (isInWishlist(referenceId, type)) {
      throw Exception('Item already in wishlist');
    }

    final wishlistItem = WishlistItem(
      type: type,
      referenceId: referenceId,
      name: name,
      userId: userId,
      description: description,
      latitude: latitude,
      longitude: longitude,
      coverPhotoUrl: coverPhotoUrl,
      rating: rating,
      notes: notes,
      priority: priority,
      tags: tags,
    );

    await _wishlistBox!.put(wishlistItem.id, wishlistItem);
    notifyListeners();

    debugPrint('Added "$name" to wishlist');
    return wishlistItem;
  }

  /// Remove item from wishlist
  Future<void> removeFromWishlist(String itemId) async {
    if (_wishlistBox == null) {
      throw Exception('WishlistService not initialized');
    }

    await _wishlistBox!.delete(itemId);
    notifyListeners();

    debugPrint('Removed item from wishlist: $itemId');
  }

  /// Update wishlist item
  Future<void> updateWishlistItem(WishlistItem item) async {
    if (_wishlistBox == null) {
      throw Exception('WishlistService not initialized');
    }

    await _wishlistBox!.put(item.id, item);
    notifyListeners();

    debugPrint('Updated wishlist item: ${item.name}');
  }

  // ==================== Queries ====================

  /// Get all wishlist items
  List<WishlistItem> getAllWishlistItems() {
    return wishlistItems;
  }

  /// Get wishlist items by type
  List<WishlistItem> getWishlistByType(WishlistItemType type) {
    return wishlistItems.where((item) => item.type == type).toList();
  }

  /// Get wishlist items by priority
  List<WishlistItem> getWishlistByPriority(int priority) {
    return wishlistItems.where((item) => item.priority == priority).toList();
  }

  /// Get high priority wishlist items
  List<WishlistItem> getHighPriorityItems() {
    return wishlistItems.where((item) => item.isHighPriority).toList();
  }

  /// Get wishlist items with tag
  List<WishlistItem> getWishlistByTag(String tag) {
    return wishlistItems
        .where((item) => item.tags?.contains(tag) == true)
        .toList();
  }

  /// Check if item is in wishlist
  bool isInWishlist(String referenceId, WishlistItemType type) {
    return wishlistItems.any(
        (item) => item.referenceId == referenceId && item.type == type);
  }

  /// Get wishlist item by reference ID
  WishlistItem? getWishlistItem(String referenceId, WishlistItemType type) {
    try {
      return wishlistItems.firstWhere(
          (item) => item.referenceId == referenceId && item.type == type);
    } catch (e) {
      return null;
    }
  }

  // ==================== Priority Management ====================

  /// Set item priority
  Future<void> setItemPriority(String itemId, int priority) async {
    final item = _wishlistBox?.get(itemId);
    if (item == null) {
      throw Exception('Wishlist item not found: $itemId');
    }

    final updatedItem = item.copyWith(priority: priority);
    await updateWishlistItem(updatedItem);

    debugPrint('Set priority of "${item.name}" to $priority');
  }

  /// Add tag to item
  Future<void> addTagToItem(String itemId, String tag) async {
    final item = _wishlistBox?.get(itemId);
    if (item == null) {
      throw Exception('Wishlist item not found: $itemId');
    }

    final tags = item.tags ?? [];
    if (!tags.contains(tag)) {
      tags.add(tag);
      final updatedItem = item.copyWith(tags: tags);
      await updateWishlistItem(updatedItem);

      debugPrint('Added tag "$tag" to "${item.name}"');
    }
  }

  /// Remove tag from item
  Future<void> removeTagFromItem(String itemId, String tag) async {
    final item = _wishlistBox?.get(itemId);
    if (item == null) {
      throw Exception('Wishlist item not found: $itemId');
    }

    final tags = item.tags ?? [];
    if (tags.contains(tag)) {
      tags.remove(tag);
      final updatedItem = item.copyWith(tags: tags);
      await updateWishlistItem(updatedItem);

      debugPrint('Removed tag "$tag" from "${item.name}"');
    }
  }

  // ==================== Move to Trip ====================

  /// Convert wishlist item to trip item
  TripItem convertToTripItem(WishlistItem wishlistItem) {
    // Map wishlist type to trip item type
    TripItemType tripItemType;
    switch (wishlistItem.type) {
      case WishlistItemType.gem:
        tripItemType = TripItemType.gem;
        break;
      case WishlistItemType.safari:
        tripItemType = TripItemType.safari;
        break;
      case WishlistItemType.route:
        tripItemType = TripItemType.route;
        break;
    }

    return TripItem(
      type: tripItemType,
      referenceId: wishlistItem.referenceId,
      name: wishlistItem.name,
      description: wishlistItem.description,
      latitude: wishlistItem.latitude,
      longitude: wishlistItem.longitude,
      coverPhotoUrl: wishlistItem.coverPhotoUrl,
      notes: wishlistItem.notes,
    );
  }

  /// Move wishlist item to trip (returns TripItem, doesn't remove from wishlist)
  Future<TripItem> moveToTrip(String wishlistItemId, String tripId) async {
    final item = _wishlistBox?.get(wishlistItemId);
    if (item == null) {
      throw Exception('Wishlist item not found: $wishlistItemId');
    }

    final tripItem = convertToTripItem(item);

    debugPrint('Created trip item from wishlist item: ${item.name}');
    return tripItem;
  }

  // ==================== Bulk Operations ====================

  /// Clear all wishlist items
  Future<void> clearWishlist() async {
    if (_wishlistBox == null) {
      throw Exception('WishlistService not initialized');
    }

    await _wishlistBox!.clear();
    notifyListeners();

    debugPrint('Cleared all wishlist items');
  }

  /// Remove multiple items
  Future<void> removeMultipleItems(List<String> itemIds) async {
    if (_wishlistBox == null) {
      throw Exception('WishlistService not initialized');
    }

    for (final itemId in itemIds) {
      await _wishlistBox!.delete(itemId);
    }

    notifyListeners();
    debugPrint('Removed ${itemIds.length} items from wishlist');
  }

  // ==================== Statistics ====================

  /// Get wishlist statistics
  Map<String, int> getWishlistStatistics() {
    final items = wishlistItems;

    return {
      'total': items.length,
      'gems': items.where((i) => i.type == WishlistItemType.gem).length,
      'safaris': items.where((i) => i.type == WishlistItemType.safari).length,
      'routes': items.where((i) => i.type == WishlistItemType.route).length,
      'highPriority': items.where((i) => i.priority == 2).length,
      'mediumPriority': items.where((i) => i.priority == 1).length,
      'lowPriority': items.where((i) => i.priority == 0).length,
    };
  }

  /// Dispose
  @override
  void dispose() {
    // Note: Don't close Hive boxes in dispose
    super.dispose();
  }
}
