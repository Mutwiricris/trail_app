import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/memory.dart';
import '../models/journey.dart';

/// Memory service for managing "On This Day" memories
class MemoryService extends ChangeNotifier {
  static final MemoryService _instance = MemoryService._internal();
  factory MemoryService() => _instance;
  MemoryService._internal();

  static const String _memoriesBoxName = 'memories';
  final Uuid _uuid = const Uuid();

  Box<Memory>? _memoriesBox;

  /// Get all memories
  List<Memory> get memories {
    if (_memoriesBox == null) return [];
    return _memoriesBox!.values.toList()
      ..sort((a, b) => b.originalDate.compareTo(a.originalDate));
  }

  /// Get memories for today
  List<Memory> get todaysMemories {
    return memories.where((memory) => memory.shouldShowToday).toList();
  }

  /// Initialize Hive boxes
  Future<void> initialize() async {
    try {
      // Register adapter if not already registered
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(MemoryAdapter());
      }

      // Open box
      if (Hive.isBoxOpen(_memoriesBoxName)) {
        _memoriesBox = Hive.box<Memory>(_memoriesBoxName);
      } else {
        _memoriesBox = await Hive.openBox<Memory>(_memoriesBoxName);
      }
    } catch (e) {
      debugPrint('Error opening memories box: $e');
    }

    notifyListeners();
  }

  /// Create memory from journey
  Future<Memory> createMemoryFromJourney(Journey journey) async {
    if (journey.title.isEmpty) {
      throw Exception('Journey must have a title');
    }

    final memory = Memory(
      id: _uuid.v4(),
      journeyId: journey.id,
      title: journey.title,
      description: journey.description,
      originalDate: journey.startTime,
      photoUrl: journey.waypoints.isNotEmpty &&
                journey.waypoints.first.photoUrls?.isNotEmpty == true
          ? journey.waypoints.first.photoUrls!.first
          : null,
      stats: {
        'distance': journey.distanceKm,
        'duration': journey.duration.inMinutes,
        'places': journey.placesCount,
        'type': journey.type.toString(),
      },
      createdAt: DateTime.now(),
    );

    await _memoriesBox?.put(memory.id, memory);
    notifyListeners();

    return memory;
  }

  /// Get memory by ID
  Memory? getMemory(String id) {
    return _memoriesBox?.get(id);
  }

  /// Delete memory
  Future<void> deleteMemory(String id) async {
    await _memoriesBox?.delete(id);
    notifyListeners();
  }

  /// Get memories from a specific year
  List<Memory> getMemoriesFromYear(int year) {
    return memories
        .where((memory) => memory.originalDate.year == year)
        .toList();
  }

  /// Get memories from a specific month
  List<Memory> getMemoriesFromMonth(int year, int month) {
    return memories
        .where((memory) =>
            memory.originalDate.year == year &&
            memory.originalDate.month == month)
        .toList();
  }

  /// Generate monthly memories
  Future<void> generateMemoriesFromJourneys(List<Journey> journeys) async {
    for (final journey in journeys) {
      if (journey.isCompleted) {
        // Check if memory already exists for this journey
        final existingMemory = memories.firstWhere(
          (m) => m.journeyId == journey.id,
          orElse: () => Memory(
            id: '',
            journeyId: '',
            title: '',
            originalDate: DateTime.now(),
            stats: {},
            createdAt: DateTime.now(),
          ),
        );

        if (existingMemory.id.isEmpty) {
          await createMemoryFromJourney(journey);
        }
      }
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _memoriesBox?.close();
    super.dispose();
  }
}
