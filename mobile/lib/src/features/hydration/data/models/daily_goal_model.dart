import 'package:isar/isar.dart';

import '../../domain/entities/daily_goal.dart';

part 'daily_goal_model.g.dart';

/// Isar model for DailyGoal entity
@collection
class DailyGoalModel {
  DailyGoalModel();

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String goalId;

  @Index()
  late String userId;

  @Index()
  late DateTime date;

  late int baseGoalMl;
  late int weatherAdjustmentMl;
  late int activityAdjustmentMl;
  late int biologyAdjustmentMl;

  double? temperatureC;
  double? humidityPercent;

  late int achievedMl;
  late bool isCompleted;

  late DateTime createdAt;
  late DateTime updatedAt;

  /// Computed total goal
  int get totalGoalMl =>
      baseGoalMl +
      weatherAdjustmentMl +
      activityAdjustmentMl +
      biologyAdjustmentMl;

  /// Convert to domain entity
  DailyGoal toEntity() {
    return DailyGoal(
      goalId: goalId,
      userId: userId,
      date: date,
      baseGoalMl: baseGoalMl,
      weatherAdjustmentMl: weatherAdjustmentMl,
      activityAdjustmentMl: activityAdjustmentMl,
      biologyAdjustmentMl: biologyAdjustmentMl,
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
      achievedMl: achievedMl,
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from domain entity
  static DailyGoalModel fromEntity(DailyGoal entity) {
    return DailyGoalModel()
      ..goalId = entity.goalId
      ..userId = entity.userId
      ..date = entity.date
      ..baseGoalMl = entity.baseGoalMl
      ..weatherAdjustmentMl = entity.weatherAdjustmentMl
      ..activityAdjustmentMl = entity.activityAdjustmentMl
      ..biologyAdjustmentMl = entity.biologyAdjustmentMl
      ..temperatureC = entity.temperatureC
      ..humidityPercent = entity.humidityPercent
      ..achievedMl = entity.achievedMl
      ..isCompleted = entity.isCompleted
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }

  /// Create from Supabase JSON
  factory DailyGoalModel.fromJson(Map<String, dynamic> json) {
    return DailyGoalModel()
      ..goalId = json['goal_id'] as String
      ..userId = json['user_id'] as String
      ..date = DateTime.parse(json['date'] as String)
      ..baseGoalMl = json['base_goal_ml'] as int
      ..weatherAdjustmentMl = json['weather_adjustment_ml'] as int? ?? 0
      ..activityAdjustmentMl = json['activity_adjustment_ml'] as int? ?? 0
      ..biologyAdjustmentMl = json['biology_adjustment_ml'] as int? ?? 0
      ..temperatureC = (json['temperature_c'] as num?)?.toDouble()
      ..humidityPercent = (json['humidity_percent'] as num?)?.toDouble()
      ..achievedMl = json['achieved_ml'] as int? ?? 0
      ..isCompleted = json['is_completed'] as bool? ?? false
      ..createdAt = DateTime.parse(json['created_at'] as String)
      ..updatedAt = DateTime.parse(json['updated_at'] as String);
  }

  /// Convert to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'goal_id': goalId,
      'user_id': userId,
      'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'base_goal_ml': baseGoalMl,
      'weather_adjustment_ml': weatherAdjustmentMl,
      'activity_adjustment_ml': activityAdjustmentMl,
      'biology_adjustment_ml': biologyAdjustmentMl,
      'temperature_c': temperatureC,
      'humidity_percent': humidityPercent,
      'achieved_ml': achievedMl,
      'is_completed': isCompleted,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }
}

