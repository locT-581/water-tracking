/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'SmartHydro';
  static const String appVersion = '1.0.0';
  static const String appSlogan = 'Hydration tuned to your biology.';

  // API Endpoints
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org/data/2.5';

  // Hydration Calculation Constants
  static const int youngAgeThreshold = 30;
  static const int middleAgeThreshold = 55;
  static const double youngMultiplier = 40.0;    // ml per kg
  static const double middleMultiplier = 35.0;   // ml per kg
  static const double elderMultiplier = 30.0;    // ml per kg

  // Weather Adjustment Thresholds
  static const double hotTempThreshold = 30.0;   // °C
  static const double veryHotTempThreshold = 35.0;
  static const double lowHumidityThreshold = 40.0; // %

  // Weather Adjustment Percentages
  static const double hotTempAdjustment = 0.10;     // +10%
  static const double veryHotTempAdjustment = 0.15; // +15%
  static const double lowHumidityAdjustment = 0.05; // +5%

  // Biology Adjustments (ml)
  static const int pregnancyAdjustment = 300;
  static const int breastfeedingAdjustment = 500;

  // Activity Adjustments (ml per 30 minutes)
  static const int lightActivityAdjustment = 150;
  static const int moderateActivityAdjustment = 250;
  static const int highActivityAdjustment = 350;
  static const int intenseActivityAdjustment = 500;

  // Notification Settings
  static const int maxNotificationsPerDay = 8;
  static const int silentPeriodMinutes = 90;
  static const int defaultWakeHour = 7;
  static const int defaultSleepHour = 23;

  // Quick Add Presets (ml)
  static const List<int> quickAddPresets = [150, 250, 500];

  // UI Constants
  static const double cardBorderRadius = 24.0;
  static const double buttonBorderRadius = 50.0;
  static const double inputBorderRadius = 16.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Cache Durations
  static const Duration weatherCacheDuration = Duration(hours: 3);
  static const Duration articleCacheDuration = Duration(hours: 24);

  // Gamification
  static const int streak7Reward = 100;    // points
  static const int streak30Reward = 500;
  static const int goalCompletePoints = 50;
  static const int logWaterPoints = 5;

  // Streak Milestones
  static const List<int> streakMilestones = [3, 7, 14, 21, 30, 60, 90, 100, 365];
}

