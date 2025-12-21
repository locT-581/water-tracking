import 'package:equatable/equatable.dart';

/// User profile entity representing core user data
class UserProfile extends Equatable {
  final String userId;
  final String email;
  final String? name;
  final Gender? gender;
  final int? birthYear;
  final double? weightKg;
  final double? heightCm;
  final TimeOfDayValue wakeTime;
  final TimeOfDayValue sleepTime;
  final bool isPregnant;
  final bool isBreastfeeding;
  final String timezone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.userId,
    required this.email,
    this.name,
    this.gender,
    this.birthYear,
    this.weightKg,
    this.heightCm,
    this.wakeTime = const TimeOfDayValue(hour: 7, minute: 0),
    this.sleepTime = const TimeOfDayValue(hour: 23, minute: 0),
    this.isPregnant = false,
    this.isBreastfeeding = false,
    this.timezone = 'Asia/Ho_Chi_Minh',
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get user's current age based on birth year
  int? get age {
    if (birthYear == null) return null;
    return DateTime.now().year - birthYear!;
  }

  /// Check if user has completed onboarding
  bool get hasCompletedOnboarding {
    return gender != null && birthYear != null && weightKg != null;
  }

  /// Get active hours (time between wake and sleep)
  int get activeHours {
    final wakeMinutes = wakeTime.hour * 60 + wakeTime.minute;
    var sleepMinutes = sleepTime.hour * 60 + sleepTime.minute;
    
    // Handle overnight (e.g., wake 7:00, sleep 23:00)
    if (sleepMinutes < wakeMinutes) {
      sleepMinutes += 24 * 60;
    }
    
    return (sleepMinutes - wakeMinutes) ~/ 60;
  }

  UserProfile copyWith({
    String? userId,
    String? email,
    String? name,
    Gender? gender,
    int? birthYear,
    double? weightKg,
    double? heightCm,
    TimeOfDayValue? wakeTime,
    TimeOfDayValue? sleepTime,
    bool? isPregnant,
    bool? isBreastfeeding,
    String? timezone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthYear: birthYear ?? this.birthYear,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      wakeTime: wakeTime ?? this.wakeTime,
      sleepTime: sleepTime ?? this.sleepTime,
      isPregnant: isPregnant ?? this.isPregnant,
      isBreastfeeding: isBreastfeeding ?? this.isBreastfeeding,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        name,
        gender,
        birthYear,
        weightKg,
        heightCm,
        wakeTime,
        sleepTime,
        isPregnant,
        isBreastfeeding,
        timezone,
        createdAt,
        updatedAt,
      ];
}

/// Gender enum
enum Gender {
  male,
  female;

  String get displayNameVi {
    switch (this) {
      case Gender.male:
        return 'Nam';
      case Gender.female:
        return 'Nữ';
    }
  }

  String get displayNameEn {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }
}

/// Simple time of day value
class TimeOfDayValue extends Equatable {
  final int hour;
  final int minute;

  const TimeOfDayValue({required this.hour, required this.minute});

  String format() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  List<Object?> get props => [hour, minute];
}

