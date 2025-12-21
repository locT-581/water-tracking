import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/daily_goal.dart';
import '../../domain/entities/water_log.dart';
import '../../domain/services/hydration_calculator.dart';
import '../../../../core/constants/bhi_constants.dart';

/// Hydration calculator provider (singleton)
final hydrationCalculatorProvider = Provider<HydrationCalculator>((ref) {
  return const HydrationCalculator();
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
  // ignore: unused_field
  final Ref _ref;

  TodayGoalNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadTodayGoal();
  }

  Future<void> _loadTodayGoal() async {
    try {
      // TODO: Load from local database or create new goal
      // For now, create a mock goal
      final now = DateTime.now();
      final goal = DailyGoal(
        goalId: 'today-${now.year}${now.month}${now.day}',
        userId: 'mock-user',
        date: DateTime(now.year, now.month, now.day),
        baseGoalMl: 2500,
        weatherAdjustmentMl: 250,
        activityAdjustmentMl: 0,
        biologyAdjustmentMl: 0,
        temperatureC: 32,
        humidityPercent: 65,
        achievedMl: 0,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      state = AsyncValue.data(goal);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update achieved amount when water is logged
  void addHydration(int hydrationMl) {
    state.whenData((goal) {
      state = AsyncValue.data(goal.addHydration(hydrationMl));
    });
  }

  /// Update weather adjustment
  void updateWeatherAdjustment({
    required int adjustmentMl,
    double? temperature,
    double? humidity,
  }) {
    state.whenData((goal) {
      state = AsyncValue.data(goal.updateWeatherAdjustment(
        adjustmentMl: adjustmentMl,
        temperature: temperature,
        humidity: humidity,
      ));
    });
  }

  /// Refresh today's goal
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadTodayGoal();
  }
}

/// Today's logs notifier
class TodayLogsNotifier extends StateNotifier<AsyncValue<List<WaterLog>>> {
  final Ref _ref;

  TodayLogsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadTodayLogs();
  }

  Future<void> _loadTodayLogs() async {
    try {
      // TODO: Load from local database
      // For now, return empty list
      state = const AsyncValue.data([]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Add a new water log
  Future<void> addLog({
    required BeverageType beverageType,
    required int volumeMl,
  }) async {
    final log = WaterLog.create(
      logId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'mock-user',
      beverageType: beverageType,
      volumeMl: volumeMl,
    );

    state.whenData((logs) {
      state = AsyncValue.data([...logs, log]);

      // Update today's goal achieved amount
      _ref.read(todayGoalProvider.notifier).addHydration(log.hydrationMl);
    });
  }

  /// Remove a log (undo)
  void removeLog(String logId) {
    state.whenData((logs) {
      final logToRemove = logs.firstWhere((l) => l.logId == logId);
      state = AsyncValue.data(logs.where((l) => l.logId != logId).toList());

      // Subtract from today's goal
      _ref.read(todayGoalProvider.notifier).addHydration(-logToRemove.hydrationMl);
    });
  }

  /// Refresh today's logs
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadTodayLogs();
  }
}

