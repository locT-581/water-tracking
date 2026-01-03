import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/daily_goal.dart';
import '../models/daily_goal_model.dart';
import '../../../auth/data/services/onboarding_service.dart';
import '../../domain/services/hydration_calculator.dart';
import '../../../../core/services/weather_service.dart';

/// Repository for managing DailyGoal data
/// 
/// Handles:
/// - Creating new daily goals based on user profile
/// - Loading today's goal
/// - Updating goal (weather adjustments, achieved amount)
/// - Syncing with Supabase (future)
class DailyGoalRepository {
  final Isar _isar;
  final OnboardingService _onboardingService;
  final HydrationCalculator _calculator;
  final WeatherService _weatherService;
  final String? _userId;

  DailyGoalRepository({
    required Isar isar,
    required OnboardingService onboardingService,
    required HydrationCalculator calculator,
    required WeatherService weatherService,
    String? userId,
  })  : _isar = isar,
        _onboardingService = onboardingService,
        _calculator = calculator,
        _weatherService = weatherService,
        _userId = userId;

  String get _effectiveUserId => _userId ?? 'guest';

  /// Get today's date (normalized to midnight)
  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Generate unique goal ID
  String _generateGoalId() {
    return const Uuid().v4();
  }

  // ============== READ OPERATIONS ==============

  /// Get today's goal, creating one if not exists
  Future<DailyGoal> getTodayGoal() async {
    // Try to load existing goal
    final existing = await _loadTodayGoalFromDb();
    if (existing != null) {
      return existing;
    }

    // Create new goal for today
    return await createTodayGoal();
  }

  /// Load today's goal from database
  Future<DailyGoal?> _loadTodayGoalFromDb() async {
    final model = await _isar.dailyGoalModels
        .filter()
        .userIdEqualTo(_effectiveUserId)
        .dateBetween(
          _today,
          _today.add(const Duration(days: 1)),
        )
        .findFirst();

    return model?.toEntity();
  }

  /// Get goals for a date range (for history/stats)
  Future<List<DailyGoal>> getGoalsInRange(DateTime start, DateTime end) async {
    final models = await _isar.dailyGoalModels
        .filter()
        .userIdEqualTo(_effectiveUserId)
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();

    return models.map((m) => m.toEntity()).toList();
  }

  /// Get last N days of goals
  Future<List<DailyGoal>> getRecentGoals(int days) async {
    final start = _today.subtract(Duration(days: days));
    return getGoalsInRange(start, _today.add(const Duration(days: 1)));
  }

  // ============== CREATE OPERATIONS ==============

  /// Create today's goal based on user profile and weather
  Future<DailyGoal> createTodayGoal() async {
    final profile = _onboardingService.getSavedProfile();
    
    if (profile == null || !profile.isComplete) {
      throw Exception('User profile is incomplete');
    }

    // Calculate base goal
    final age = profile.age ?? 30;
    final weight = profile.weightKg ?? 65;
    
    final baseGoal = _calculator.calculateBaseGoal(
      age: age,
      weightKg: weight,
    );

    // Calculate biology adjustment
    final biologyAdjustment = _calculator.calculateBiologyAdjustment(
      isPregnant: profile.isPregnant,
      isBreastfeeding: profile.isBreastfeeding,
    );

    // Fetch weather and calculate adjustment
    int weatherAdjustment = 0;
    double? temperature;
    double? humidity;

    try {
      final weather = await _weatherService.getCurrentWeather();
      if (weather != null) {
        temperature = weather.temperatureC;
        humidity = weather.humidityPercent;
        weatherAdjustment = _calculator.calculateWeatherAdjustment(
          baseGoalMl: baseGoal,
          temperatureC: temperature,
          humidityPercent: humidity,
        );
      }
    } catch (_) {
      // Weather fetch failed, continue without adjustment
    }

    final now = DateTime.now();
    final goal = DailyGoal(
      goalId: _generateGoalId(),
      userId: _effectiveUserId,
      date: _today,
      baseGoalMl: baseGoal,
      weatherAdjustmentMl: weatherAdjustment,
      activityAdjustmentMl: 0,
      biologyAdjustmentMl: biologyAdjustment,
      temperatureC: temperature,
      humidityPercent: humidity,
      achievedMl: 0,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );

    // Save to database
    await _saveGoal(goal);

    return goal;
  }

  // ============== UPDATE OPERATIONS ==============

  /// Update goal in database
  Future<void> _saveGoal(DailyGoal goal) async {
    final model = DailyGoalModel.fromEntity(goal);
    
    await _isar.writeTxn(() async {
      // Check if exists by goalId
      final existing = await _isar.dailyGoalModels
          .filter()
          .goalIdEqualTo(goal.goalId)
          .findFirst();

      if (existing != null) {
        model.id = existing.id;
      }

      await _isar.dailyGoalModels.put(model);
    });
  }

  /// Add hydration to today's goal
  Future<DailyGoal> addHydration(int hydrationMl) async {
    final goal = await getTodayGoal();
    final updated = goal.addHydration(hydrationMl);
    await _saveGoal(updated);
    return updated;
  }

  /// Subtract hydration (for undo)
  Future<DailyGoal> subtractHydration(int hydrationMl) async {
    return addHydration(-hydrationMl);
  }

  /// Update weather adjustment
  Future<DailyGoal> refreshWeatherAdjustment() async {
    final goal = await getTodayGoal();
    
    try {
      // Force refresh weather
      _weatherService.clearCache();
      final weather = await _weatherService.getCurrentWeather();
      
      if (weather != null) {
        final newAdjustment = _calculator.calculateWeatherAdjustment(
          baseGoalMl: goal.baseGoalMl,
          temperatureC: weather.temperatureC,
          humidityPercent: weather.humidityPercent,
        );

        final updated = goal.updateWeatherAdjustment(
          adjustmentMl: newAdjustment,
          temperature: weather.temperatureC,
          humidity: weather.humidityPercent,
        );

        await _saveGoal(updated);
        return updated;
      }
    } catch (_) {
      // Weather fetch failed
    }

    return goal;
  }

  /// Update activity adjustment
  Future<DailyGoal> updateActivityAdjustment({
    required int durationMinutes,
    required ActivityIntensity intensity,
  }) async {
    final goal = await getTodayGoal();
    
    final adjustment = _calculator.calculateActivityAdjustment(
      durationMinutes: durationMinutes,
      intensity: intensity,
    );

    // Add to existing activity adjustment
    final totalActivity = goal.activityAdjustmentMl + adjustment;
    final updated = goal.updateActivityAdjustment(totalActivity);
    
    await _saveGoal(updated);
    return updated;
  }

  // ============== DELETE OPERATIONS ==============

  /// Clear all goals (for development/testing)
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.dailyGoalModels.clear();
    });
  }

  // ============== SYNC OPERATIONS (Future) ==============

  /// Sync with Supabase (to be implemented)
  Future<void> syncWithCloud() async {
    // TODO: Implement cloud sync
    // 1. Pull remote changes
    // 2. Merge with local
    // 3. Push local changes
  }
}

