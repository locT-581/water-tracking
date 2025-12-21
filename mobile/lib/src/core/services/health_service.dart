import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/app_constants.dart';
import '../../features/hydration/domain/services/hydration_calculator.dart';

/// Health data from Apple Health / Google Fit
class HealthActivityData {
  final int steps;
  final int activeMinutes;
  final int caloriesBurned;
  final int workoutMinutes;
  final ActivityIntensity estimatedIntensity;
  final DateTime fetchedAt;

  const HealthActivityData({
    required this.steps,
    required this.activeMinutes,
    required this.caloriesBurned,
    required this.workoutMinutes,
    required this.estimatedIntensity,
    required this.fetchedAt,
  });

  /// Calculate water adjustment based on activity
  int calculateAdjustment() {
    if (workoutMinutes <= 0) return 0;

    int adjustmentPer30Min;
    switch (estimatedIntensity) {
      case ActivityIntensity.light:
        adjustmentPer30Min = AppConstants.lightActivityAdjustment;
      case ActivityIntensity.moderate:
        adjustmentPer30Min = AppConstants.moderateActivityAdjustment;
      case ActivityIntensity.high:
        adjustmentPer30Min = AppConstants.highActivityAdjustment;
      case ActivityIntensity.intense:
        adjustmentPer30Min = AppConstants.intenseActivityAdjustment;
    }

    final periods = workoutMinutes / 30;
    return (periods * adjustmentPer30Min).round();
  }
}

/// Service for integrating with Apple Health and Google Fit
class HealthService {
  final Health _health;
  bool _hasPermission = false;

  HealthService({Health? health}) : _health = health ?? Health();

  /// Request health permissions
  Future<bool> requestPermissions() async {
    // Request activity recognition permission first
    final activityStatus = await Permission.activityRecognition.request();
    if (!activityStatus.isGranted) {
      return false;
    }

    // Define the types we need
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.WORKOUT,
    ];

    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    try {
      _hasPermission = await _health.requestAuthorization(types, permissions: permissions);
      return _hasPermission;
    } catch (e) {
      return false;
    }
  }

  /// Check if we have permissions
  Future<bool> hasPermissions() async {
    if (_hasPermission) return true;

    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    try {
      for (final type in types) {
        final hasType = await _health.hasPermissions([type]);
        if (hasType != true) return false;
      }
      _hasPermission = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get today's activity data
  Future<HealthActivityData?> getTodayActivity() async {
    if (!await hasPermissions()) {
      return null;
    }

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    try {
      // Fetch steps
      final stepsData = await _health.getHealthDataFromTypes(
        startTime: startOfDay,
        endTime: now,
        types: [HealthDataType.STEPS],
      );
      final steps = stepsData.fold<int>(
        0,
        (sum, data) => sum + (data.value as NumericHealthValue).numericValue.toInt(),
      );

      // Fetch calories
      final caloriesData = await _health.getHealthDataFromTypes(
        startTime: startOfDay,
        endTime: now,
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
      );
      final calories = caloriesData.fold<int>(
        0,
        (sum, data) => sum + (data.value as NumericHealthValue).numericValue.toInt(),
      );

      // Fetch workouts
      final workoutData = await _health.getHealthDataFromTypes(
        startTime: startOfDay,
        endTime: now,
        types: [HealthDataType.WORKOUT],
      );
      final workoutMinutes = workoutData.fold<int>(
        0,
        (sum, data) {
          final workout = data.value as WorkoutHealthValue;
          return sum + (workout.totalEnergyBurned?.toInt() ?? 0);
        },
      );

      // Estimate intensity based on steps and calories
      final intensity = _estimateIntensity(
        steps: steps,
        calories: calories,
        workoutMinutes: workoutMinutes,
      );

      // Calculate active minutes from steps
      final activeMinutes = (steps / 100).round(); // ~100 steps per minute

      return HealthActivityData(
        steps: steps,
        activeMinutes: activeMinutes,
        caloriesBurned: calories,
        workoutMinutes: workoutMinutes,
        estimatedIntensity: intensity,
        fetchedAt: now,
      );
    } catch (e) {
      return null;
    }
  }

  /// Estimate activity intensity based on metrics
  ActivityIntensity _estimateIntensity({
    required int steps,
    required int calories,
    required int workoutMinutes,
  }) {
    // Use calories per minute as primary indicator
    if (workoutMinutes > 0) {
      final caloriesPerMin = calories / workoutMinutes;
      if (caloriesPerMin > 12) return ActivityIntensity.intense;
      if (caloriesPerMin > 8) return ActivityIntensity.high;
      if (caloriesPerMin > 5) return ActivityIntensity.moderate;
      return ActivityIntensity.light;
    }

    // Fallback to steps
    if (steps > 15000) return ActivityIntensity.high;
    if (steps > 10000) return ActivityIntensity.moderate;
    if (steps > 5000) return ActivityIntensity.light;
    return ActivityIntensity.light;
  }

  /// Check sedentary time (time since last significant activity)
  Future<int> getSedentaryMinutes() async {
    if (!await hasPermissions()) {
      return 0;
    }

    final now = DateTime.now();
    final twoHoursAgo = now.subtract(const Duration(hours: 2));

    try {
      final stepsData = await _health.getHealthDataFromTypes(
        startTime: twoHoursAgo,
        endTime: now,
        types: [HealthDataType.STEPS],
      );

      final recentSteps = stepsData.fold<int>(
        0,
        (sum, data) => sum + (data.value as NumericHealthValue).numericValue.toInt(),
      );

      // If less than 200 steps in last 2 hours, consider sedentary
      if (recentSteps < 200) {
        // Find last activity time
        final lastActivityTime = stepsData.isEmpty
            ? twoHoursAgo
            : stepsData.last.dateTo;
        return now.difference(lastActivityTime).inMinutes;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Check if user just finished a workout
  Future<bool> hasRecentWorkout({int withinMinutes = 30}) async {
    if (!await hasPermissions()) {
      return false;
    }

    final now = DateTime.now();
    final recentTime = now.subtract(Duration(minutes: withinMinutes));

    try {
      final workoutData = await _health.getHealthDataFromTypes(
        startTime: recentTime,
        endTime: now,
        types: [HealthDataType.WORKOUT],
      );

      return workoutData.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

