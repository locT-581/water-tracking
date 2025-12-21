import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import '../../../../core/constants/app_constants.dart';

/// Notification service for smart hydration reminders
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications;
  bool _initialized = false;

  // Track last log time for Silent Period
  DateTime? _lastLogTime;

  NotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _notifications = plugin ?? FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz_data.initializeTimeZones();

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
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

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to app
    // This would typically be handled by a global navigator
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    bool? granted;

    if (android != null) {
      granted = await android.requestNotificationsPermission();
    }

    if (ios != null) {
      granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return granted ?? false;
  }

  /// Schedule daily reminders based on user's wake/sleep time
  Future<void> scheduleDailyReminders({
    required int wakeHour,
    required int sleepHour,
    required int totalGoalMl,
    required int currentMl,
  }) async {
    // Cancel existing reminders
    await cancelAllReminders();

    final remainingMl = totalGoalMl - currentMl;
    if (remainingMl <= 0) return; // Goal already met

    final now = DateTime.now();
    final activeHours = _calculateActiveHours(wakeHour, sleepHour);
    final hourlyGoal = remainingMl ~/ activeHours;

    // Calculate reminder intervals (max 8 per day)
    final reminderCount = activeHours.clamp(1, AppConstants.maxNotificationsPerDay);
    final intervalHours = activeHours ~/ reminderCount;

    for (int i = 0; i < reminderCount; i++) {
      final hour = (wakeHour + (i * intervalHours)) % 24;

      // Skip if past sleep time
      if (_isPastSleepTime(hour, sleepHour)) continue;

      // Skip if already past this hour today
      if (now.hour >= hour) continue;

      final scheduledTime = DateTime(now.year, now.month, now.day, hour);
      await _scheduleReminder(
        id: i,
        time: scheduledTime,
        title: 'Đến giờ uống nước rồi! 💧',
        body: 'Còn ${_formatMl(remainingMl - (hourlyGoal * i))}ml nữa thôi!',
      );
    }
  }

  /// Schedule a single reminder
  Future<void> _scheduleReminder({
    required int id,
    required DateTime time,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'hydration_reminders',
      'Hydration Reminders',
      channelDescription: 'Nhắc nhở uống nước',
      importance: Importance.high,
      priority: Priority.defaultPriority,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Record that user logged water (for Silent Period)
  void recordWaterLog() {
    _lastLogTime = DateTime.now();
  }

  /// Check if we're in Silent Period (90 mins after last log)
  bool isInSilentPeriod() {
    if (_lastLogTime == null) return false;
    final diff = DateTime.now().difference(_lastLogTime!);
    return diff.inMinutes < AppConstants.silentPeriodMinutes;
  }

  /// Cancel all scheduled reminders
  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  /// Show immediate notification (for achievements, etc.)
  Future<void> showImmediateNotification({
    required String title,
    required String body,
    int id = 999,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'achievements',
      'Achievements',
      channelDescription: 'Thông báo thành tựu',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details);
  }

  /// Show goal completed notification
  Future<void> showGoalCompletedNotification() async {
    await showImmediateNotification(
      title: '🎉 Tuyệt vời!',
      body: 'Bạn đã đạt mục tiêu uống nước hôm nay!',
      id: 1000,
    );
  }

  // Helper methods
  int _calculateActiveHours(int wakeHour, int sleepHour) {
    if (sleepHour > wakeHour) {
      return sleepHour - wakeHour;
    } else {
      return (24 - wakeHour) + sleepHour;
    }
  }

  bool _isPastSleepTime(int hour, int sleepHour) {
    if (sleepHour > 12) {
      return hour >= sleepHour || hour < 6;
    } else {
      return hour >= sleepHour && hour < 12;
    }
  }

  String _formatMl(int ml) {
    if (ml >= 1000) {
      return '${(ml / 1000).toStringAsFixed(1)}L';
    }
    return '$ml ml';
  }
}

