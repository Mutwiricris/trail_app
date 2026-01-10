import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for handling local push notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Notification channels
  static const String _channelIdStreaks = 'streaks';
  static const String _channelIdAchievements = 'achievements';
  static const String _channelIdMemories = 'memories';
  static const String _channelIdGeneral = 'general';

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions
    await _requestPermissions();

    _initialized = true;
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    // iOS permissions
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Android 13+ permissions
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // TODO: Navigate to relevant screen based on payload
  }

  /// Schedule daily streak reminder
  Future<void> scheduleStreakReminder({int hour = 20, int minute = 0}) async {
    await _notifications.zonedSchedule(
      1, // ID for streak reminder
      '🔥 Keep your streak alive!',
      'You haven\'t explored today. A quick journey keeps your streak going!',
      _nextInstanceOfTime(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdStreaks,
          'Streak Reminders',
          channelDescription: 'Daily reminders to maintain your exploration streak',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'streak_reminder',
    );
  }

  /// Cancel streak reminder
  Future<void> cancelStreakReminder() async {
    await _notifications.cancel(1);
  }

  /// Show achievement unlock notification
  Future<void> showAchievementUnlock({
    required String achievementName,
    required String description,
    required int xpEarned,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
      '🏆 Achievement Unlocked!',
      '$achievementName - +$xpEarned XP',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdAchievements,
          'Achievements',
          channelDescription: 'Notifications for unlocked achievements',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(
            '$achievementName\n\n$description\n\n+$xpEarned Explorer Points earned!',
          ),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          subtitle: description,
        ),
      ),
      payload: 'achievement_unlock',
    );
  }

  /// Schedule morning memory notification
  Future<void> scheduleMemoryNotification({
    required String memoryTitle,
    required int yearsAgo,
    int hour = 9,
    int minute = 0,
  }) async {
    await _notifications.zonedSchedule(
      2, // ID for memory notification
      '📅 On This Day',
      '$yearsAgo ${yearsAgo == 1 ? 'year' : 'years'} ago: $memoryTitle',
      _nextInstanceOfTime(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdMemories,
          'Memories',
          channelDescription: 'On This Day memory reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'memory_$yearsAgo',
    );
  }

  /// Show level up notification
  Future<void> showLevelUp({
    required String levelName,
    required int newLevel,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '⭐ Level Up!',
      'You are now a $levelName (Level $newLevel)!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdGeneral,
          'General',
          channelDescription: 'General app notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'level_up',
    );
  }

  /// Show journey completed notification
  Future<void> showJourneyCompleted({
    required String journeyTitle,
    required double distance,
    required int duration,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '✅ Journey Completed!',
      '$journeyTitle - ${distance.toStringAsFixed(1)} km in ${duration}min',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdGeneral,
          'General',
          channelDescription: 'General app notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'journey_completed',
    );
  }

  /// Show streak milestone notification
  Future<void> showStreakMilestone({
    required int days,
  }) async {
    String message;
    if (days == 7) {
      message = 'Amazing! You\'ve explored for a full week!';
    } else if (days == 30) {
      message = 'Incredible! One month of consistent exploration!';
    } else if (days == 100) {
      message = 'Legendary! 100 days of exploration!';
    } else {
      message = '$days days of exploration - keep it going!';
    }

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '🔥 Streak Milestone!',
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdStreaks,
          'Streak Reminders',
          channelDescription: 'Daily reminders to maintain your exploration streak',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'streak_milestone_$days',
    );
  }

  /// Show hidden gem discovered notification
  Future<void> showGemDiscovered({
    required String gemName,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '💎 Hidden Gem Discovered!',
      'You found $gemName - well done, explorer!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdGeneral,
          'General',
          channelDescription: 'General app notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'gem_discovered',
    );
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Get next instance of a specific time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }

    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final settings = await ios.checkPermissions();
      return settings?.isEnabled ?? false;
    }

    return false;
  }
}
