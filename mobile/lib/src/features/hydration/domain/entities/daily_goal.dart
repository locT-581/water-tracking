import 'package:equatable/equatable.dart';

/// Daily goal entity representing hydration target for a specific day
class DailyGoal extends Equatable {
  final String goalId;
  final String userId;
  final DateTime date;
  final int baseGoalMl;
  final int weatherAdjustmentMl;
  final int activityAdjustmentMl;
  final int biologyAdjustmentMl;
  final double? temperatureC;
  final double? humidityPercent;
  final int achievedMl;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyGoal({
    required this.goalId,
    required this.userId,
    required this.date,
    required this.baseGoalMl,
    this.weatherAdjustmentMl = 0,
    this.activityAdjustmentMl = 0,
    this.biologyAdjustmentMl = 0,
    this.temperatureC,
    this.humidityPercent,
    this.achievedMl = 0,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Total goal including all adjustments
  int get totalGoalMl =>
      baseGoalMl +
      weatherAdjustmentMl +
      activityAdjustmentMl +
      biologyAdjustmentMl;

  /// Remaining ml to reach goal
  int get remainingMl {
    final remaining = totalGoalMl - achievedMl;
    return remaining > 0 ? remaining : 0;
  }

  /// Progress percentage (0.0 - 1.0+)
  double get progressPercent {
    if (totalGoalMl == 0) return 0;
    return achievedMl / totalGoalMl;
  }

  /// Progress percentage capped at 100
  double get progressPercentCapped {
    final progress = progressPercent;
    return progress > 1.0 ? 1.0 : progress;
  }

  /// Check if goal is exceeded (over hydrated)
  bool get isExceeded => achievedMl > totalGoalMl;

  /// Get hydration status based on progress
  HydrationStatus get status {
    final percent = progressPercent;
    if (percent >= 1.0) return HydrationStatus.hydrated;
    if (percent >= 0.75) return HydrationStatus.good;
    if (percent >= 0.50) return HydrationStatus.okay;
    if (percent >= 0.25) return HydrationStatus.thirsty;
    return HydrationStatus.dehydrated;
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  DailyGoal copyWith({
    String? goalId,
    String? userId,
    DateTime? date,
    int? baseGoalMl,
    int? weatherAdjustmentMl,
    int? activityAdjustmentMl,
    int? biologyAdjustmentMl,
    double? temperatureC,
    double? humidityPercent,
    int? achievedMl,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyGoal(
      goalId: goalId ?? this.goalId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      baseGoalMl: baseGoalMl ?? this.baseGoalMl,
      weatherAdjustmentMl: weatherAdjustmentMl ?? this.weatherAdjustmentMl,
      activityAdjustmentMl: activityAdjustmentMl ?? this.activityAdjustmentMl,
      biologyAdjustmentMl: biologyAdjustmentMl ?? this.biologyAdjustmentMl,
      temperatureC: temperatureC ?? this.temperatureC,
      humidityPercent: humidityPercent ?? this.humidityPercent,
      achievedMl: achievedMl ?? this.achievedMl,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Add hydration to achieved amount
  DailyGoal addHydration(int hydrationMl) {
    final newAchieved = achievedMl + hydrationMl;
    return copyWith(
      achievedMl: newAchieved,
      isCompleted: newAchieved >= totalGoalMl,
      updatedAt: DateTime.now(),
    );
  }

  /// Update weather adjustment
  DailyGoal updateWeatherAdjustment({
    required int adjustmentMl,
    double? temperature,
    double? humidity,
  }) {
    return copyWith(
      weatherAdjustmentMl: adjustmentMl,
      temperatureC: temperature,
      humidityPercent: humidity,
      updatedAt: DateTime.now(),
    );
  }

  /// Update activity adjustment
  DailyGoal updateActivityAdjustment(int adjustmentMl) {
    return copyWith(
      activityAdjustmentMl: adjustmentMl,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        goalId,
        userId,
        date,
        baseGoalMl,
        weatherAdjustmentMl,
        activityAdjustmentMl,
        biologyAdjustmentMl,
        temperatureC,
        humidityPercent,
        achievedMl,
        isCompleted,
        createdAt,
        updatedAt,
      ];
}

/// Hydration status enum for UI display
enum HydrationStatus {
  dehydrated,
  thirsty,
  okay,
  good,
  hydrated;

  String get displayNameVi {
    switch (this) {
      case HydrationStatus.dehydrated:
        return 'Rất khát';
      case HydrationStatus.thirsty:
        return 'Khát';
      case HydrationStatus.okay:
        return 'Ổn';
      case HydrationStatus.good:
        return 'Tốt';
      case HydrationStatus.hydrated:
        return 'Tuyệt vời';
    }
  }

  String get displayNameEn {
    switch (this) {
      case HydrationStatus.dehydrated:
        return 'Dehydrated';
      case HydrationStatus.thirsty:
        return 'Thirsty';
      case HydrationStatus.okay:
        return 'Okay';
      case HydrationStatus.good:
        return 'Good';
      case HydrationStatus.hydrated:
        return 'Hydrated';
    }
  }
}

