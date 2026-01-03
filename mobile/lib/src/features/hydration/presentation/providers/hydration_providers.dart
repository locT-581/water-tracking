import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../data/repositories/daily_goal_repository.dart';
import '../../data/repositories/water_log_repository.dart';
import '../../domain/entities/daily_goal.dart';
import '../../domain/entities/water_log.dart';
import '../../domain/services/hydration_calculator.dart';
import '../../../../core/constants/bhi_constants.dart';
import '../../../../core/providers/weather_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/onboarding_providers.dart';

/// Hydration calculator provider (singleton)
final hydrationCalculatorProvider = Provider<HydrationCalculator>((ref) {
  return const HydrationCalculator();
});

/// Daily Goal Repository provider
final dailyGoalRepositoryProvider = Provider<DailyGoalRepository>((ref) {
  final isar = ref.watch(isarProvider);
  final onboardingService = ref.watch(onboardingServiceProvider);
  final calculator = ref.watch(hydrationCalculatorProvider);
  final weatherService = ref.watch(weatherServiceProvider);
  
  // Get user ID if logged in, otherwise use 'guest'
  final userAsync = ref.watch(currentUserProvider);
  final userId = userAsync.valueOrNull?.id;

  return DailyGoalRepository(
    isar: isar,
    onboardingService: onboardingService,
    calculator: calculator,
    weatherService: weatherService,
    userId: userId,
  );
});

/// Water Log Repository provider
final waterLogRepositoryProvider = Provider<WaterLogRepository>((ref) {
  final isar = ref.watch(isarProvider);
  
  // Get user ID if logged in, otherwise use 'guest'
  final userAsync = ref.watch(currentUserProvider);
  final userId = userAsync.valueOrNull?.id;

  return WaterLogRepository(
    isar: isar,
    userId: userId,
  );
});

/// Today's daily goal provider
final todayGoalProvider = StateNotifierProvider<TodayGoalNotifier, AsyncValue<DailyGoal>>((ref) {
  return TodayGoalNotifier(ref);
});

/// Today's water logs provider
final todayLogsProvider = StateNotifierProvider<TodayLogsNotifier, AsyncValue<List<WaterLog>>>((ref) {
  return TodayLogsNotifier(ref);
});

/// Today's total hydration (sum of all logs)
final todayTotalHydrationProvider = Provider<int>((ref) {
  final logsAsync = ref.watch(todayLogsProvider);
  return logsAsync.maybeWhen(
    data: (logs) => logs.fold(0, (sum, log) => sum + log.hydrationMl),
    orElse: () => 0,
  );
});

/// Today's progress percentage
final todayProgressProvider = Provider<double>((ref) {
  final goalAsync = ref.watch(todayGoalProvider);
  final totalHydration = ref.watch(todayTotalHydrationProvider);

  return goalAsync.maybeWhen(
    data: (goal) {
      if (goal.totalGoalMl == 0) return 0;
      return totalHydration / goal.totalGoalMl;
    },
    orElse: () => 0,
  );
});

/// Today's remaining ml
final todayRemainingProvider = Provider<int>((ref) {
  final goalAsync = ref.watch(todayGoalProvider);
  final totalHydration = ref.watch(todayTotalHydrationProvider);

  return goalAsync.maybeWhen(
    data: (goal) {
      final remaining = goal.totalGoalMl - totalHydration;
      return remaining > 0 ? remaining : 0;
    },
    orElse: () => 0,
  );
});

/// Hydration status based on progress
final hydrationStatusProvider = Provider<HydrationStatus>((ref) {
  final progress = ref.watch(todayProgressProvider);

  if (progress >= 1.0) return HydrationStatus.hydrated;
  if (progress >= 0.75) return HydrationStatus.good;
  if (progress >= 0.50) return HydrationStatus.okay;
  if (progress >= 0.25) return HydrationStatus.thirsty;
  return HydrationStatus.dehydrated;
});

/// Today's goal notifier
class TodayGoalNotifier extends StateNotifier<AsyncValue<DailyGoal>> {
  final Ref _ref;

  TodayGoalNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadTodayGoal();
  }

  Future<void> _loadTodayGoal() async {
    try {
      state = const AsyncValue.loading();
      
      final repository = _ref.read(dailyGoalRepositoryProvider);
      final goal = await repository.getTodayGoal();
      
      state = AsyncValue.data(goal);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update achieved amount when water is logged
  void addHydration(int hydrationMl) {
    state.whenData((goal) {
      state = AsyncValue.data(goal.addHydration(hydrationMl));
      
      // Also update in database async
      _ref.read(dailyGoalRepositoryProvider).addHydration(hydrationMl);
    });
  }

  /// Update weather adjustment
  Future<void> refreshWeatherAdjustment() async {
    try {
      final repository = _ref.read(dailyGoalRepositoryProvider);
      final updated = await repository.refreshWeatherAdjustment();
      state = AsyncValue.data(updated);
    } catch (_) {
      // Keep current state
    }
  }

  /// Refresh today's goal
  Future<void> refresh() async {
    await _loadTodayGoal();
  }
}

/// Today's logs notifier
class TodayLogsNotifier extends StateNotifier<AsyncValue<List<WaterLog>>> {
  final Ref _ref;
  
  // Cache logs in memory for quick access
  List<WaterLog> _cachedLogs = [];

  TodayLogsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadTodayLogs();
  }

  Future<void> _loadTodayLogs() async {
    try {
      final repository = _ref.read(waterLogRepositoryProvider);
      _cachedLogs = await repository.getTodayLogs();
      state = AsyncValue.data(List.from(_cachedLogs));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Add a new water log
  Future<void> addLog({
    required BeverageType beverageType,
    required int volumeMl,
  }) async {
    try {
      final repository = _ref.read(waterLogRepositoryProvider);
      
      // Create log in database
      final log = await repository.createLog(
        beverageType: beverageType,
        volumeMl: volumeMl,
      );

      // Update cache and state
      _cachedLogs.add(log);
      state = AsyncValue.data(List.from(_cachedLogs));

      // Update today's goal achieved amount
      _ref.read(todayGoalProvider.notifier).addHydration(log.hydrationMl);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Remove a log (undo)
  Future<void> removeLog(String logId) async {
    final index = _cachedLogs.indexWhere((l) => l.logId == logId);
    if (index != -1) {
      final logToRemove = _cachedLogs[index];
      
      // Remove from database
      final repository = _ref.read(waterLogRepositoryProvider);
      await repository.deleteLog(logId);

      // Update cache and state
      _cachedLogs.removeAt(index);
      state = AsyncValue.data(List.from(_cachedLogs));

      // Subtract from today's goal
      _ref.read(todayGoalProvider.notifier).addHydration(-logToRemove.hydrationMl);
    }
  }

  /// Get last log for undo
  WaterLog? getLastLog() {
    return _cachedLogs.isNotEmpty ? _cachedLogs.last : null;
  }

  /// Refresh today's logs
  Future<void> refresh() async {
    await _loadTodayLogs();
  }
}

/// Isar database provider
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar must be initialized in main.dart');
});
