import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/entities/user_profile.dart';

/// Hydration Calculator - Core engine for calculating water goals
/// Based on SRS v1.1 formulas
class HydrationCalculator {
  const HydrationCalculator();

  /// Calculate base daily water goal based on age and weight
  /// 
  /// Formula:
  /// - Age < 30: weight × 40 ml
  /// - Age 30-55: weight × 35 ml
  /// - Age > 55: weight × 30 ml
  int calculateBaseGoal({
    required int age,
    required double weightKg,
  }) {
    double multiplier;
    
    if (age < AppConstants.youngAgeThreshold) {
      multiplier = AppConstants.youngMultiplier;
    } else if (age <= AppConstants.middleAgeThreshold) {
      multiplier = AppConstants.middleMultiplier;
    } else {
      multiplier = AppConstants.elderMultiplier;
    }
    
    return (weightKg * multiplier).round();
  }

  /// Calculate weather adjustment based on temperature and humidity
  /// 
  /// Rules:
  /// - Temp > 35°C: +15% of base goal
  /// - Temp > 30°C: +10% of base goal
  /// - Humidity < 40%: +5% of base goal
  int calculateWeatherAdjustment({
    required int baseGoalMl,
    required double temperatureC,
    required double humidityPercent,
  }) {
    double adjustment = 0;
    
    // Temperature adjustment
    if (temperatureC > AppConstants.veryHotTempThreshold) {
      adjustment += baseGoalMl * AppConstants.veryHotTempAdjustment;
    } else if (temperatureC > AppConstants.hotTempThreshold) {
      adjustment += baseGoalMl * AppConstants.hotTempAdjustment;
    }
    
    // Humidity adjustment
    if (humidityPercent < AppConstants.lowHumidityThreshold) {
      adjustment += baseGoalMl * AppConstants.lowHumidityAdjustment;
    }
    
    return adjustment.round();
  }

  /// Calculate activity adjustment based on exercise duration and intensity
  /// 
  /// Rules (per 30 minutes):
  /// - Light activity: +150ml
  /// - Moderate activity: +250ml
  /// - High intensity: +350ml
  /// - Very high intensity: +500ml
  int calculateActivityAdjustment({
    required int durationMinutes,
    required ActivityIntensity intensity,
  }) {
    if (durationMinutes <= 0) return 0;
    
    final periods = durationMinutes / 30;
    int adjustmentPer30Min;
    
    switch (intensity) {
      case ActivityIntensity.light:
        adjustmentPer30Min = AppConstants.lightActivityAdjustment;
      case ActivityIntensity.moderate:
        adjustmentPer30Min = AppConstants.moderateActivityAdjustment;
      case ActivityIntensity.high:
        adjustmentPer30Min = AppConstants.highActivityAdjustment;
      case ActivityIntensity.intense:
        adjustmentPer30Min = AppConstants.intenseActivityAdjustment;
    }
    
    return (periods * adjustmentPer30Min).round();
  }

  /// Calculate biology adjustment for pregnancy/breastfeeding
  /// 
  /// Rules:
  /// - Pregnant: +300ml fixed
  /// - Breastfeeding: +500ml fixed
  int calculateBiologyAdjustment({
    required bool isPregnant,
    required bool isBreastfeeding,
  }) {
    int adjustment = 0;
    
    if (isPregnant) {
      adjustment += AppConstants.pregnancyAdjustment;
    }
    
    if (isBreastfeeding) {
      adjustment += AppConstants.breastfeedingAdjustment;
    }
    
    return adjustment;
  }

  /// Calculate total daily goal for a user profile
  int calculateTotalGoal({
    required UserProfile profile,
    double? temperatureC,
    double? humidityPercent,
    int activityDurationMinutes = 0,
    ActivityIntensity activityIntensity = ActivityIntensity.moderate,
  }) {
    // Validate required fields
    if (profile.age == null || profile.weightKg == null) {
      throw ArgumentError('User profile must have age and weight');
    }
    
    // Calculate base goal
    final baseGoal = calculateBaseGoal(
      age: profile.age!,
      weightKg: profile.weightKg!,
    );
    
    // Calculate weather adjustment
    int weatherAdjustment = 0;
    if (temperatureC != null && humidityPercent != null) {
      weatherAdjustment = calculateWeatherAdjustment(
        baseGoalMl: baseGoal,
        temperatureC: temperatureC,
        humidityPercent: humidityPercent,
      );
    }
    
    // Calculate activity adjustment
    final activityAdjustment = calculateActivityAdjustment(
      durationMinutes: activityDurationMinutes,
      intensity: activityIntensity,
    );
    
    // Calculate biology adjustment
    final biologyAdjustment = calculateBiologyAdjustment(
      isPregnant: profile.isPregnant,
      isBreastfeeding: profile.isBreastfeeding,
    );
    
    return baseGoal + weatherAdjustment + activityAdjustment + biologyAdjustment;
  }

  /// Calculate hourly goal based on active hours
  int calculateHourlyGoal({
    required int totalGoalMl,
    required int activeHours,
  }) {
    if (activeHours <= 0) return 0;
    return (totalGoalMl / activeHours).round();
  }
}

/// Activity intensity levels
enum ActivityIntensity {
  light,      // Walking, light yoga
  moderate,   // Brisk walking, light gym
  high,       // Running, swimming, cycling
  intense,    // HIIT, marathon, competitive sports
}

