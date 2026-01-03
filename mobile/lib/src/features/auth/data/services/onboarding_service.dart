import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_profile.dart';
import '../../../gamification/domain/models/mascot_models.dart';

/// OnboardingService - Manages user profile data locally
/// 
/// For guest users, data is stored in SharedPreferences.
/// For authenticated users, data syncs to Supabase.
class OnboardingService {
  static const String _profileKey = 'user_profile';
  static const String _onboardingCompleteKey = 'onboarding_complete';
  
  final SharedPreferences _prefs;
  
  OnboardingService(this._prefs);
  
  // ============== PROFILE DATA ==============
  
  /// Check if onboarding is complete
  bool get hasCompletedOnboarding => 
      _prefs.getBool(_onboardingCompleteKey) ?? false;
  
  /// Save onboarding completion status
  Future<void> setOnboardingComplete(bool complete) async {
    await _prefs.setBool(_onboardingCompleteKey, complete);
  }
  
  /// Get saved profile data
  OnboardingData? getSavedProfile() {
    final json = _prefs.getString(_profileKey);
    if (json == null) return null;
    
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return OnboardingData.fromJson(map);
    } catch (e) {
      return null;
    }
  }
  
  /// Save profile data locally
  Future<void> saveProfile(OnboardingData data) async {
    final json = jsonEncode(data.toJson());
    await _prefs.setString(_profileKey, json);
    await setOnboardingComplete(true);
  }
  
  /// Clear profile data
  Future<void> clearProfile() async {
    await _prefs.remove(_profileKey);
    await _prefs.remove(_onboardingCompleteKey);
  }
  
  /// Convert OnboardingData to UserProfile
  UserProfile toUserProfile(OnboardingData data, String userId, String email) {
    return UserProfile(
      userId: userId,
      email: email,
      gender: data.gender,
      birthYear: data.birthYear,
      weightKg: data.weightKg,
      wakeTime: TimeOfDayValue(
        hour: data.wakeTimeHour,
        minute: data.wakeTimeMinute,
      ),
      sleepTime: TimeOfDayValue(
        hour: data.sleepTimeHour,
        minute: data.sleepTimeMinute,
      ),
      isPregnant: data.isPregnant,
      isBreastfeeding: data.isBreastfeeding,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

/// Onboarding data model for local storage
class OnboardingData {
  final Gender? gender;
  final int? birthYear;
  final double? weightKg;
  final int wakeTimeHour;
  final int wakeTimeMinute;
  final int sleepTimeHour;
  final int sleepTimeMinute;
  final bool isPregnant;
  final bool isBreastfeeding;
  final int? calculatedGoalMl;
  final MascotType? selectedMascot;
  
  const OnboardingData({
    this.gender,
    this.birthYear,
    this.weightKg,
    this.wakeTimeHour = 7,
    this.wakeTimeMinute = 0,
    this.sleepTimeHour = 23,
    this.sleepTimeMinute = 0,
    this.isPregnant = false,
    this.isBreastfeeding = false,
    this.calculatedGoalMl,
    this.selectedMascot,
  });
  
  /// Check if has minimum required data
  bool get isComplete => 
      gender != null && birthYear != null && weightKg != null;
  
  /// Get age from birth year
  int? get age {
    if (birthYear == null) return null;
    return DateTime.now().year - birthYear!;
  }
  
  /// Get active hours
  int get activeHours {
    final wakeMinutes = wakeTimeHour * 60 + wakeTimeMinute;
    var sleepMinutes = sleepTimeHour * 60 + sleepTimeMinute;
    
    if (sleepMinutes < wakeMinutes) {
      sleepMinutes += 24 * 60;
    }
    
    return (sleepMinutes - wakeMinutes) ~/ 60;
  }
  
  OnboardingData copyWith({
    Gender? gender,
    int? birthYear,
    double? weightKg,
    int? wakeTimeHour,
    int? wakeTimeMinute,
    int? sleepTimeHour,
    int? sleepTimeMinute,
    bool? isPregnant,
    bool? isBreastfeeding,
    int? calculatedGoalMl,
    MascotType? selectedMascot,
  }) {
    return OnboardingData(
      gender: gender ?? this.gender,
      birthYear: birthYear ?? this.birthYear,
      weightKg: weightKg ?? this.weightKg,
      wakeTimeHour: wakeTimeHour ?? this.wakeTimeHour,
      wakeTimeMinute: wakeTimeMinute ?? this.wakeTimeMinute,
      sleepTimeHour: sleepTimeHour ?? this.sleepTimeHour,
      sleepTimeMinute: sleepTimeMinute ?? this.sleepTimeMinute,
      isPregnant: isPregnant ?? this.isPregnant,
      isBreastfeeding: isBreastfeeding ?? this.isBreastfeeding,
      calculatedGoalMl: calculatedGoalMl ?? this.calculatedGoalMl,
      selectedMascot: selectedMascot ?? this.selectedMascot,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'gender': gender?.name,
    'birthYear': birthYear,
    'weightKg': weightKg,
    'wakeTimeHour': wakeTimeHour,
    'wakeTimeMinute': wakeTimeMinute,
    'sleepTimeHour': sleepTimeHour,
    'sleepTimeMinute': sleepTimeMinute,
    'isPregnant': isPregnant,
    'isBreastfeeding': isBreastfeeding,
    'calculatedGoalMl': calculatedGoalMl,
    'selectedMascot': selectedMascot?.name,
  };
  
  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      gender: json['gender'] != null 
          ? Gender.values.firstWhere((g) => g.name == json['gender'])
          : null,
      birthYear: json['birthYear'] as int?,
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      wakeTimeHour: json['wakeTimeHour'] as int? ?? 7,
      wakeTimeMinute: json['wakeTimeMinute'] as int? ?? 0,
      sleepTimeHour: json['sleepTimeHour'] as int? ?? 23,
      sleepTimeMinute: json['sleepTimeMinute'] as int? ?? 0,
      isPregnant: json['isPregnant'] as bool? ?? false,
      isBreastfeeding: json['isBreastfeeding'] as bool? ?? false,
      calculatedGoalMl: json['calculatedGoalMl'] as int?,
      selectedMascot: json['selectedMascot'] != null
          ? MascotType.values.firstWhere(
              (m) => m.name == json['selectedMascot'],
              orElse: () => MascotType.aquaAxo,
            )
          : null,
    );
  }
}

