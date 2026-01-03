import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

/// Background task identifiers
class BackgroundTasks {
  static const String midnightReset = 'midnight_reset_task';
  static const String weatherUpdate = 'weather_update_task';
  static const String syncQueue = 'sync_queue_task';
  static const String dailyNotification = 'daily_notification_task';
}

/// Callback dispatcher for background tasks
/// This function must be top-level (not inside a class)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    debugPrint('🔄 Background task started: $taskName');
    
    try {
      switch (taskName) {
        case BackgroundTasks.midnightReset:
          await _handleMidnightReset();
          break;
        case BackgroundTasks.weatherUpdate:
          await _handleWeatherUpdate();
          break;
        case BackgroundTasks.syncQueue:
          await _handleSyncQueue();
          break;
        case BackgroundTasks.dailyNotification:
          await _handleDailyNotification();
          break;
        default:
          debugPrint('⚠️ Unknown task: $taskName');
          return Future.value(false);
      }
      
      debugPrint('✅ Background task completed: $taskName');
      return Future.value(true);
    } catch (e) {
      debugPrint('❌ Background task failed: $taskName - $e');
      return Future.value(false);
    }
  });
}

/// Handle midnight reset - create new daily goal
Future<void> _handleMidnightReset() async {
  // TODO: Initialize services and create new daily goal
  // This will:
  // 1. Mark previous day's goal as complete
  // 2. Create new goal for today
  // 3. Reset streak if goal not completed
  debugPrint('📅 Midnight reset: Creating new daily goal');
}

/// Handle weather update - refresh weather data
Future<void> _handleWeatherUpdate() async {
  // TODO: Fetch weather and update today's goal adjustment
  debugPrint('🌤️ Weather update: Refreshing weather data');
}

/// Handle sync queue - push pending changes to server
Future<void> _handleSyncQueue() async {
  // TODO: Process sync queue when online
  debugPrint('🔄 Sync queue: Processing pending changes');
}

/// Handle daily notification scheduling
Future<void> _handleDailyNotification() async {
  // TODO: Schedule notifications for the day
  debugPrint('🔔 Daily notification: Scheduling reminders');
}

/// Service for managing background tasks
class BackgroundTaskService {
  static bool _isInitialized = false;

  /// Initialize workmanager and register periodic tasks
  static Future<void> initialize() async {
    if (_isInitialized) return;

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );

    _isInitialized = true;
    debugPrint('✅ BackgroundTaskService initialized');
  }

  /// Register all periodic tasks
  static Future<void> registerPeriodicTasks() async {
    if (!_isInitialized) {
      await initialize();
    }

    // Cancel all existing tasks first
    await Workmanager().cancelAll();

    // Register midnight reset task
    // Runs daily at around midnight
    await Workmanager().registerPeriodicTask(
      'midnight-reset-1',
      BackgroundTasks.midnightReset,
      frequency: const Duration(hours: 24),
      initialDelay: _getDelayUntilMidnight(),
      constraints: Constraints(
        networkType: NetworkType.unmetered,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    // Register weather update task
    // Runs every 3 hours as per AppConstants.weatherCacheDuration
    await Workmanager().registerPeriodicTask(
      'weather-update-1',
      BackgroundTasks.weatherUpdate,
      frequency: const Duration(hours: 3),
      initialDelay: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    // Register sync queue task
    // Runs every 30 minutes when connected
    await Workmanager().registerPeriodicTask(
      'sync-queue-1',
      BackgroundTasks.syncQueue,
      frequency: const Duration(minutes: 30),
      initialDelay: const Duration(minutes: 5),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    debugPrint('✅ Periodic tasks registered');
  }

  /// Get duration until next midnight
  static Duration _getDelayUntilMidnight() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }

  /// Run a one-time task immediately
  static Future<void> runTaskNow(String taskName) async {
    if (!_isInitialized) {
      await initialize();
    }

    await Workmanager().registerOneOffTask(
      '${taskName}_immediate_${DateTime.now().millisecondsSinceEpoch}',
      taskName,
      constraints: Constraints(
        networkType: taskName == BackgroundTasks.syncQueue
            ? NetworkType.connected
            : NetworkType.unmetered,
      ),
    );
  }

  /// Cancel all background tasks
  static Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
    debugPrint('🛑 All background tasks cancelled');
  }

  /// Cancel a specific task by unique name
  static Future<void> cancelTask(String uniqueName) async {
    await Workmanager().cancelByUniqueName(uniqueName);
    debugPrint('🛑 Task cancelled: $uniqueName');
  }
}

