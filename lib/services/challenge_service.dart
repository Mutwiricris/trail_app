import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:zuritrails/models/challenge.dart';

/// Service for managing challenges
class ChallengeService extends ChangeNotifier {
  static final ChallengeService _instance = ChallengeService._internal();
  factory ChallengeService() => _instance;
  ChallengeService._internal();

  static const String _challengesBoxName = 'challenges';
  final Uuid _uuid = const Uuid();

  Box<Challenge>? _challengesBox;

  /// Get all challenges
  List<Challenge> get challenges {
    if (_challengesBox == null) return [];
    return _challengesBox!.values.toList()
      ..sort((a, b) => a.endDate.compareTo(b.endDate));
  }

  /// Get active challenges
  List<Challenge> get activeChallenges {
    return challenges.where((c) => c.isActive).toList();
  }

  /// Get daily challenges
  List<Challenge> get dailyChallenges {
    return activeChallenges
        .where((c) => c.type == ChallengeType.daily)
        .toList();
  }

  /// Get weekly challenges
  List<Challenge> get weeklyChallenges {
    return activeChallenges
        .where((c) => c.type == ChallengeType.weekly)
        .toList();
  }

  /// Get completed challenges
  List<Challenge> get completedChallenges {
    return challenges.where((c) => c.isCompleted).toList();
  }

  /// Initialize service
  Future<void> initialize() async {
    try {
      // Register adapter if not registered
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(ChallengeAdapter());
      }

      // Open box
      if (Hive.isBoxOpen(_challengesBoxName)) {
        _challengesBox = Hive.box<Challenge>(_challengesBoxName);
      } else {
        _challengesBox = await Hive.openBox<Challenge>(_challengesBoxName);
      }

      // Generate initial challenges if empty
      if (challenges.isEmpty) {
        await _generateInitialChallenges();
      }
    } catch (e) {
      debugPrint('Error initializing challenge service: $e');
    }

    notifyListeners();
  }

  /// Generate initial challenges
  Future<void> _generateInitialChallenges() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Daily challenges
    await _addChallenge(Challenge(
      id: _uuid.v4(),
      title: 'Morning Explorer',
      description: 'Complete a journey before noon',
      type: ChallengeType.daily,
      category: ChallengeCategory.consistency,
      targetValue: 1,
      xpReward: 50,
      startDate: today,
      endDate: today.add(const Duration(days: 1)),
    ));

    await _addChallenge(Challenge(
      id: _uuid.v4(),
      title: '5km Adventure',
      description: 'Travel at least 5 kilometers today',
      type: ChallengeType.daily,
      category: ChallengeCategory.distance,
      targetValue: 5,
      xpReward: 75,
      startDate: today,
      endDate: today.add(const Duration(days: 1)),
    ));

    // Weekly challenges
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    await _addChallenge(Challenge(
      id: _uuid.v4(),
      title: 'Weekly Wanderer',
      description: 'Complete 3 journeys this week',
      type: ChallengeType.weekly,
      category: ChallengeCategory.consistency,
      targetValue: 3,
      xpReward: 200,
      startDate: weekStart,
      endDate: weekEnd,
    ));

    await _addChallenge(Challenge(
      id: _uuid.v4(),
      title: 'Gem Hunter',
      description: 'Discover 2 hidden gems this week',
      type: ChallengeType.weekly,
      category: ChallengeCategory.exploration,
      targetValue: 2,
      xpReward: 150,
      startDate: weekStart,
      endDate: weekEnd,
    ));

    await _addChallenge(Challenge(
      id: _uuid.v4(),
      title: 'Photo Diary',
      description: 'Take photos on 5 different journeys',
      type: ChallengeType.weekly,
      category: ChallengeCategory.photography,
      targetValue: 5,
      xpReward: 175,
      startDate: weekStart,
      endDate: weekEnd,
    ));
  }

  /// Add a challenge
  Future<void> _addChallenge(Challenge challenge) async {
    await _challengesBox?.put(challenge.id, challenge);
    notifyListeners();
  }

  /// Update challenge progress
  Future<void> updateProgress(String challengeId, int progress) async {
    final challenge = _challengesBox?.get(challengeId);
    if (challenge == null) return;

    final updatedChallenge = challenge.copyWith(
      currentProgress: progress,
      isCompleted: progress >= challenge.targetValue,
      completedAt: progress >= challenge.targetValue ? DateTime.now() : null,
    );

    await _challengesBox?.put(challengeId, updatedChallenge);
    notifyListeners();
  }

  /// Increment challenge progress
  Future<void> incrementProgress(String challengeId, int amount) async {
    final challenge = _challengesBox?.get(challengeId);
    if (challenge == null) return;

    await updateProgress(
      challengeId,
      challenge.currentProgress + amount,
    );
  }

  /// Complete a challenge
  Future<void> completeChallenge(String challengeId) async {
    final challenge = _challengesBox?.get(challengeId);
    if (challenge == null) return;

    final updatedChallenge = challenge.copyWith(
      currentProgress: challenge.targetValue,
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    await _challengesBox?.put(challengeId, updatedChallenge);
    notifyListeners();
  }

  /// Track journey completion
  Future<void> onJourneyCompleted(double distanceKm) async {
    // Update distance challenges
    for (final challenge in activeChallenges) {
      if (challenge.category == ChallengeCategory.distance) {
        await incrementProgress(challenge.id, distanceKm.toInt());
      }
      if (challenge.category == ChallengeCategory.consistency &&
          challenge.title.contains('journey')) {
        await incrementProgress(challenge.id, 1);
      }
    }
  }

  /// Track gem discovery
  Future<void> onGemDiscovered() async {
    for (final challenge in activeChallenges) {
      if (challenge.category == ChallengeCategory.exploration) {
        await incrementProgress(challenge.id, 1);
      }
    }
  }

  /// Track photo taken
  Future<void> onPhotoTaken() async {
    for (final challenge in activeChallenges) {
      if (challenge.category == ChallengeCategory.photography) {
        await incrementProgress(challenge.id, 1);
      }
    }
  }

  /// Refresh challenges (remove expired, add new)
  Future<void> refreshChallenges() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if we need new daily challenges
    final hasTodaysChallenges = dailyChallenges.any((c) =>
        c.startDate.year == today.year &&
        c.startDate.month == today.month &&
        c.startDate.day == today.day);

    if (!hasTodaysChallenges) {
      await _generateInitialChallenges();
    }

    notifyListeners();
  }

  /// Get challenge by ID
  Challenge? getChallenge(String id) {
    return _challengesBox?.get(id);
  }

  /// Delete challenge
  Future<void> deleteChallenge(String id) async {
    await _challengesBox?.delete(id);
    notifyListeners();
  }

  @override
  void dispose() {
    _challengesBox?.close();
    super.dispose();
  }
}
