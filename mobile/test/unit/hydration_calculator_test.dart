import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hydro/src/features/hydration/domain/services/hydration_calculator.dart';
import 'package:smart_hydro/src/features/auth/domain/entities/user_profile.dart';

void main() {
  late HydrationCalculator calculator;

  setUp(() {
    calculator = const HydrationCalculator();
  });

  group('calculateBaseGoal', () {
    test('should return weight × 40 for age < 30', () {
      final result = calculator.calculateBaseGoal(age: 25, weightKg: 70);
      expect(result, 2800); // 70 × 40
    });

    test('should return weight × 35 for age 30-55', () {
      final result = calculator.calculateBaseGoal(age: 40, weightKg: 70);
      expect(result, 2450); // 70 × 35
    });

    test('should return weight × 30 for age > 55', () {
      final result = calculator.calculateBaseGoal(age: 60, weightKg: 70);
      expect(result, 2100); // 70 × 30
    });

    test('should handle edge case age = 30', () {
      final result = calculator.calculateBaseGoal(age: 30, weightKg: 70);
      expect(result, 2450); // Age 30 uses 35 multiplier
    });

    test('should handle edge case age = 55', () {
      final result = calculator.calculateBaseGoal(age: 55, weightKg: 70);
      expect(result, 2450); // Age 55 uses 35 multiplier
    });

    test('should handle decimal weight', () {
      final result = calculator.calculateBaseGoal(age: 25, weightKg: 65.5);
      expect(result, 2620); // 65.5 × 40 = 2620
    });
  });

  group('calculateWeatherAdjustment', () {
    test('should return 0 for normal temperature', () {
      final result = calculator.calculateWeatherAdjustment(
        baseGoalMl: 2500,
        temperatureC: 25,
        humidityPercent: 50,
      );
      expect(result, 0);
    });

    test('should add 10% for temperature > 30°C', () {
      final result = calculator.calculateWeatherAdjustment(
        baseGoalMl: 2500,
        temperatureC: 32,
        humidityPercent: 50,
      );
      expect(result, 250); // 2500 × 0.10
    });

    test('should add 15% for temperature > 35°C', () {
      final result = calculator.calculateWeatherAdjustment(
        baseGoalMl: 2500,
        temperatureC: 36,
        humidityPercent: 50,
      );
      expect(result, 375); // 2500 × 0.15
    });

    test('should add 5% for humidity < 40%', () {
      final result = calculator.calculateWeatherAdjustment(
        baseGoalMl: 2500,
        temperatureC: 25,
        humidityPercent: 35,
      );
      expect(result, 125); // 2500 × 0.05
    });

    test('should combine temperature and humidity adjustments', () {
      final result = calculator.calculateWeatherAdjustment(
        baseGoalMl: 2500,
        temperatureC: 32,
        humidityPercent: 35,
      );
      expect(result, 375); // (2500 × 0.10) + (2500 × 0.05) = 250 + 125
    });

    test('should combine very hot and dry conditions', () {
      final result = calculator.calculateWeatherAdjustment(
        baseGoalMl: 2500,
        temperatureC: 38,
        humidityPercent: 30,
      );
      expect(result, 500); // (2500 × 0.15) + (2500 × 0.05) = 375 + 125
    });
  });

  group('calculateActivityAdjustment', () {
    test('should return 0 for no activity', () {
      final result = calculator.calculateActivityAdjustment(
        durationMinutes: 0,
        intensity: ActivityIntensity.moderate,
      );
      expect(result, 0);
    });

    test('should return 250ml for 30min moderate activity', () {
      final result = calculator.calculateActivityAdjustment(
        durationMinutes: 30,
        intensity: ActivityIntensity.moderate,
      );
      expect(result, 250);
    });

    test('should return 350ml for 30min high intensity activity', () {
      final result = calculator.calculateActivityAdjustment(
        durationMinutes: 30,
        intensity: ActivityIntensity.high,
      );
      expect(result, 350);
    });

    test('should return 500ml for 30min intense activity', () {
      final result = calculator.calculateActivityAdjustment(
        durationMinutes: 30,
        intensity: ActivityIntensity.intense,
      );
      expect(result, 500);
    });

    test('should scale with duration', () {
      final result = calculator.calculateActivityAdjustment(
        durationMinutes: 60,
        intensity: ActivityIntensity.moderate,
      );
      expect(result, 500); // 2 × 250
    });

    test('should handle partial periods', () {
      final result = calculator.calculateActivityAdjustment(
        durationMinutes: 45,
        intensity: ActivityIntensity.moderate,
      );
      expect(result, 375); // 1.5 × 250
    });
  });

  group('calculateBiologyAdjustment', () {
    test('should return 0 for normal user', () {
      final result = calculator.calculateBiologyAdjustment(
        isPregnant: false,
        isBreastfeeding: false,
      );
      expect(result, 0);
    });

    test('should return +300ml for pregnant user', () {
      final result = calculator.calculateBiologyAdjustment(
        isPregnant: true,
        isBreastfeeding: false,
      );
      expect(result, 300);
    });

    test('should return +500ml for breastfeeding user', () {
      final result = calculator.calculateBiologyAdjustment(
        isPregnant: false,
        isBreastfeeding: true,
      );
      expect(result, 500);
    });

    test('should combine pregnant and breastfeeding', () {
      final result = calculator.calculateBiologyAdjustment(
        isPregnant: true,
        isBreastfeeding: true,
      );
      expect(result, 800); // 300 + 500
    });
  });

  group('calculateTotalGoal', () {
    test('should calculate total goal for basic profile', () {
      final profile = UserProfile(
        userId: 'test',
        email: 'test@test.com',
        gender: Gender.male,
        birthYear: 1995, // Age ~30
        weightKg: 70,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = calculator.calculateTotalGoal(profile: profile);
      expect(result, 2450); // 70 × 35 for age 30
    });

    test('should include weather adjustment', () {
      final profile = UserProfile(
        userId: 'test',
        email: 'test@test.com',
        gender: Gender.male,
        birthYear: 1995,
        weightKg: 70,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = calculator.calculateTotalGoal(
        profile: profile,
        temperatureC: 35,
        humidityPercent: 50,
      );
      expect(result, 2695); // 2450 + (2450 × 0.10)
    });

    test('should include biology adjustment for pregnant user', () {
      final profile = UserProfile(
        userId: 'test',
        email: 'test@test.com',
        gender: Gender.female,
        birthYear: 1995,
        weightKg: 60,
        isPregnant: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = calculator.calculateTotalGoal(profile: profile);
      expect(result, 2400); // (60 × 35) + 300 = 2100 + 300
    });

    test('should throw error if profile incomplete', () {
      final profile = UserProfile(
        userId: 'test',
        email: 'test@test.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(
        () => calculator.calculateTotalGoal(profile: profile),
        throwsArgumentError,
      );
    });
  });

  group('calculateHourlyGoal', () {
    test('should distribute goal across active hours', () {
      final result = calculator.calculateHourlyGoal(
        totalGoalMl: 2400,
        activeHours: 16,
      );
      expect(result, 150); // 2400 / 16
    });

    test('should handle non-divisible amounts', () {
      final result = calculator.calculateHourlyGoal(
        totalGoalMl: 2500,
        activeHours: 16,
      );
      expect(result, 156); // 2500 / 16 ≈ 156
    });

    test('should return 0 for 0 active hours', () {
      final result = calculator.calculateHourlyGoal(
        totalGoalMl: 2400,
        activeHours: 0,
      );
      expect(result, 0);
    });
  });
}

