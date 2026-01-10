import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hidden_gem.dart';
import '../models/route.dart';

/// Offline save service for caching content for offline access
///
/// Handles:
/// - Download and cache content for offline viewing
/// - Image caching
/// - Storage quota management
/// - Offline availability checking
class OfflineSaveService extends ChangeNotifier {
  static const String _offlineCacheBoxName = 'offline_cache';
  static const int _maxOfflineItems = 20; // Configurable limit
  static const int _maxStorageBytes = 100 * 1024 * 1024; // 100 MB

  Box? _offlineCacheBox;
  int _currentStorageBytes = 0;

  /// Get currently cached items count
  int get cachedItemsCount {
    if (_offlineCacheBox == null) return 0;
    return _offlineCacheBox!.length;
  }

  /// Get current storage usage in bytes
  int get currentStorageBytes => _currentStorageBytes;

  /// Get current storage usage in MB
  double get currentStorageMB => _currentStorageBytes / (1024 * 1024);

  /// Check if storage limit reached
  bool get isStorageLimitReached => cachedItemsCount >= _maxOfflineItems;

  /// Initialize Hive and boxes
  Future<void> initialize() async {
    await Hive.initFlutter();

    // Open boxes
    try {
      if (Hive.isBoxOpen(_offlineCacheBoxName)) {
        _offlineCacheBox = Hive.box(_offlineCacheBoxName);
      } else {
        _offlineCacheBox = await Hive.openBox(_offlineCacheBoxName);
      }

      // Calculate current storage
      await _calculateStorageSize();

      debugPrint(
          'OfflineSaveService initialized with $cachedItemsCount cached items (${currentStorageMB.toStringAsFixed(2)} MB)');
    } catch (e) {
      debugPrint('Error opening offline cache box: $e');
      rethrow;
    }
  }

  // ==================== Save for Offline ====================

  /// Save hidden gem for offline access
  Future<void> saveGemForOffline(HiddenGem gem) async {
    if (_offlineCacheBox == null) {
      throw Exception('OfflineSaveService not initialized');
    }

    // Check storage limit
    if (isStorageLimitReached &&
        !isAvailableOffline('gem_${gem.id}', 'gem')) {
      throw Exception(
          'Offline storage limit reached ($_maxOfflineItems items)');
    }

    // Create cache entry
    final cacheEntry = {
      'type': 'gem',
      'id': gem.id,
      'data': {
        'id': gem.id,
        'name': gem.name,
        'description': gem.description,
        'category': gem.category.name,
        'photoUrls': gem.photoUrls,
        'latitude': gem.latitude,
        'longitude': gem.longitude,
        'rating': gem.rating,
        'discoveredBy': gem.discoveredBy,
        'addedBy': gem.addedBy,
        'createdAt': gem.createdAt.toIso8601String(),
      },
      'cachedAt': DateTime.now().toIso8601String(),
      'sizeBytes': _estimateGemSize(gem),
    };

    await _offlineCacheBox!.put('gem_${gem.id}', cacheEntry);
    await _calculateStorageSize();
    notifyListeners();

    debugPrint('Saved gem "${gem.name}" for offline access');
  }

  /// Save safari/tour for offline access
  Future<void> saveSafariForOffline(Map<String, dynamic> safari) async {
    if (_offlineCacheBox == null) {
      throw Exception('OfflineSaveService not initialized');
    }

    final safariId = safari['id'] ?? 'unknown';

    // Check storage limit
    if (isStorageLimitReached &&
        !isAvailableOffline('safari_$safariId', 'safari')) {
      throw Exception(
          'Offline storage limit reached ($_maxOfflineItems items)');
    }

    // Create cache entry
    final cacheEntry = {
      'type': 'safari',
      'id': safariId,
      'data': safari,
      'cachedAt': DateTime.now().toIso8601String(),
      'sizeBytes': _estimateSafariSize(safari),
    };

    await _offlineCacheBox!.put('safari_$safariId', cacheEntry);
    await _calculateStorageSize();
    notifyListeners();

    debugPrint('Saved safari "${safari['name']}" for offline access');
  }

  /// Save route for offline access
  Future<void> saveRouteForOffline(Route route) async {
    if (_offlineCacheBox == null) {
      throw Exception('OfflineSaveService not initialized');
    }

    // Check storage limit
    if (isStorageLimitReached &&
        !isAvailableOffline('route_${route.id}', 'route')) {
      throw Exception(
          'Offline storage limit reached ($_maxOfflineItems items)');
    }

    // Create cache entry
    final cacheEntry = {
      'type': 'route',
      'id': route.id,
      'data': {
        'id': route.id,
        'name': route.name,
        'description': route.description,
        'type': route.type.name,
        'difficulty': route.difficulty.name,
        'distanceKm': route.distanceKm,
        'estimatedDuration': route.estimatedDuration,
        'elevationGainMeters': route.elevationGainMeters,
        'rating': route.rating,
        'completedCount': route.completedCount,
        'highlights': route.highlights,
        'region': route.region,
      },
      'cachedAt': DateTime.now().toIso8601String(),
      'sizeBytes': _estimateRouteSize(route),
    };

    await _offlineCacheBox!.put('route_${route.id}', cacheEntry);
    await _calculateStorageSize();
    notifyListeners();

    debugPrint('Saved route "${route.name}" for offline access');
  }

  // ==================== Check Availability ====================

  /// Check if item is available offline
  bool isAvailableOffline(String id, String type) {
    if (_offlineCacheBox == null) return false;
    return _offlineCacheBox!.containsKey('${type}_$id');
  }

  /// Get all offline item keys
  List<String> getAllOfflineItems() {
    if (_offlineCacheBox == null) return [];
    return _offlineCacheBox!.keys.cast<String>().toList();
  }

  /// Get offline item data
  Map<String, dynamic>? getOfflineItem(String id, String type) {
    if (_offlineCacheBox == null) return null;
    final entry = _offlineCacheBox!.get('${type}_$id');
    if (entry == null) return null;
    return Map<String, dynamic>.from(entry as Map);
  }

  // ==================== Remove ====================

  /// Remove item from offline cache
  Future<void> removeOfflineItem(String id, String type) async {
    if (_offlineCacheBox == null) {
      throw Exception('OfflineSaveService not initialized');
    }

    final key = '${type}_$id';
    if (!_offlineCacheBox!.containsKey(key)) {
      debugPrint('Item not in offline cache: $key');
      return;
    }

    await _offlineCacheBox!.delete(key);
    await _calculateStorageSize();
    notifyListeners();

    debugPrint('Removed $key from offline cache');
  }

  /// Clear all offline data
  Future<void> clearAllOfflineData() async {
    if (_offlineCacheBox == null) {
      throw Exception('OfflineSaveService not initialized');
    }

    await _offlineCacheBox!.clear();
    _currentStorageBytes = 0;
    notifyListeners();

    debugPrint('Cleared all offline data');
  }

  // ==================== Storage Management ====================

  /// Calculate total storage size
  Future<void> _calculateStorageSize() async {
    if (_offlineCacheBox == null) {
      _currentStorageBytes = 0;
      return;
    }

    int totalBytes = 0;
    for (final value in _offlineCacheBox!.values) {
      if (value is Map) {
        final sizeBytes = value['sizeBytes'] as int? ?? 0;
        totalBytes += sizeBytes;
      }
    }

    _currentStorageBytes = totalBytes;
  }

  /// Get offline storage size
  Future<int> getOfflineStorageSize() async {
    await _calculateStorageSize();
    return _currentStorageBytes;
  }

  /// Cleanup old offline data (LRU eviction)
  Future<void> cleanupOldOfflineData() async {
    if (_offlineCacheBox == null) return;

    // Get all entries sorted by cachedAt
    final entries = <MapEntry<String, Map<String, dynamic>>>[];
    for (final key in _offlineCacheBox!.keys) {
      final value = _offlineCacheBox!.get(key);
      if (value is Map) {
        entries.add(MapEntry(
          key.toString(),
          Map<String, dynamic>.from(value),
        ));
      }
    }

    entries.sort((a, b) {
      final aTime = DateTime.parse(a.value['cachedAt'] as String);
      final bTime = DateTime.parse(b.value['cachedAt'] as String);
      return aTime.compareTo(bTime);
    });

    // Remove oldest entries if over limit
    int removed = 0;
    while (entries.length > _maxOfflineItems) {
      final oldest = entries.removeAt(0);
      await _offlineCacheBox!.delete(oldest.key);
      removed++;
    }

    if (removed > 0) {
      await _calculateStorageSize();
      notifyListeners();
      debugPrint('Cleaned up $removed old offline items');
    }
  }

  // ==================== Size Estimation ====================

  /// Estimate gem size in bytes
  int _estimateGemSize(HiddenGem gem) {
    // Basic estimation: text + image URLs
    int size = 0;
    size += gem.name.length * 2; // UTF-16
    size += gem.description.length * 2;
    size += gem.photoUrls.length * 100; // URL length estimate
    return size;
  }

  /// Estimate safari size in bytes
  int _estimateSafariSize(Map<String, dynamic> safari) {
    // Basic estimation
    int size = 0;
    size += (safari['name']?.toString().length ?? 0) * 2;
    size += (safari['description']?.toString().length ?? 0) * 2;
    final images = safari['images'] as List?;
    size += (images?.length ?? 0) * 100;
    return size;
  }

  /// Estimate route size in bytes
  int _estimateRouteSize(Route route) {
    int size = 0;
    size += route.name.length * 2;
    size += route.description.length * 2;
    size += route.waypoints.length * 32; // Lat/lng pairs
    size += route.segments.length * 200; // Segment data estimate
    size += route.highlights.length * 50;
    return size;
  }

  // ==================== Statistics ====================

  /// Get offline storage statistics
  Map<String, dynamic> getStorageStatistics() {
    final items = getAllOfflineItems();

    int gemCount = 0;
    int safariCount = 0;
    int routeCount = 0;

    for (final key in items) {
      if (key.startsWith('gem_')) gemCount++;
      if (key.startsWith('safari_')) safariCount++;
      if (key.startsWith('route_')) routeCount++;
    }

    return {
      'totalItems': items.length,
      'gems': gemCount,
      'safaris': safariCount,
      'routes': routeCount,
      'storageMB': currentStorageMB,
      'storageBytes': currentStorageBytes,
      'maxItems': _maxOfflineItems,
      'maxStorageMB': _maxStorageBytes / (1024 * 1024),
      'isLimitReached': isStorageLimitReached,
    };
  }

  /// Dispose
  @override
  void dispose() {
    // Note: Don't close Hive boxes in dispose
    super.dispose();
  }
}
