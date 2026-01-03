import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/onboarding_service.dart';
import '../../domain/entities/user_profile.dart';
import '../../../hydration/domain/services/hydration_calculator.dart';
import '../../../gamification/domain/models/mascot_models.dart';

// ============== SERVICE PROVIDER ==============

/// OnboardingService provider
final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

// ============== STATE PROVIDERS ==============

/// Has completed onboarding
final hasCompletedOnboardingLocalProvider = Provider<bool>((ref) {
  final service = ref.watch(onboardingServiceProvider);
  return service.hasCompletedOnboarding;
});

/// Saved onboarding data
final savedOnboardingDataProvider = Provider<OnboardingData?>((ref) {
  final service = ref.watch(onboardingServiceProvider);
  return service.getSavedProfile();
});

// ============== ONBOARDING STATE NOTIFIER ==============

/// Onboarding state for the wizard flow
class OnboardingState {
  final int currentPage;
  final OnboardingData data;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final bool isComplete;

  const OnboardingState({
    this.currentPage = 0,
    this.data = const OnboardingData(),
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.isComplete = false,
  });

  // Pages: Gender, Birth Year, Weight, Time, [Pregnancy if female], Mascot Selection
  int get totalPages {
    int base = 4; // Gender, Birth Year, Weight, Time
    if (data.gender == Gender.female) base += 1; // Pregnancy
    base += 1; // Mascot selection (always last)
    return base;
  }
  
  double get progress => (currentPage + 1) / totalPages;
  
  /// Check which page type we're on
  int get _mascotPageIndex => data.gender == Gender.female ? 5 : 4;
  
  bool get isMascotPage => currentPage == _mascotPageIndex;
  
  bool get canProceed {
    switch (currentPage) {
      case 0: // Gender
        return data.gender != null;
      case 1: // Birth year
        return data.birthYear != null;
      case 2: // Weight
        return data.weightKg != null;
      case 3: // Time
        return true;
      case 4: // Pregnancy (only for female) or Mascot Selection (for male)
        if (data.gender == Gender.female) {
          return true; // Pregnancy page
        } else {
          return data.selectedMascot != null; // Mascot selection
        }
      case 5: // Mascot Selection (for female)
        return data.selectedMascot != null;
      default:
        return true;
    }
  }
  
  bool get isLastPage => currentPage >= totalPages - 1;

  OnboardingState copyWith({
    int? currentPage,
    OnboardingData? data,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool? isComplete,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

/// Onboarding controller
class OnboardingController extends StateNotifier<OnboardingState> {
  final OnboardingService _service;
  final HydrationCalculator _calculator;

  OnboardingController(this._service, this._calculator)
      : super(const OnboardingState()) {
    // Load saved data if exists
    _loadSavedData();
  }

  void _loadSavedData() {
    final saved = _service.getSavedProfile();
    if (saved != null) {
      state = state.copyWith(data: saved);
    }
  }

  // ============== PAGE NAVIGATION ==============

  void nextPage() {
    if (state.canProceed && !state.isLastPage) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page < state.totalPages) {
      state = state.copyWith(currentPage: page);
    }
  }

  // ============== DATA UPDATES ==============

  void setGender(Gender gender) {
    state = state.copyWith(
      data: state.data.copyWith(gender: gender),
    );
  }

  void setBirthYear(int year) {
    state = state.copyWith(
      data: state.data.copyWith(birthYear: year),
    );
  }

  void setWeight(double weightKg) {
    state = state.copyWith(
      data: state.data.copyWith(weightKg: weightKg),
    );
  }

  void setWakeTime(int hour, int minute) {
    state = state.copyWith(
      data: state.data.copyWith(
        wakeTimeHour: hour,
        wakeTimeMinute: minute,
      ),
    );
  }

  void setSleepTime(int hour, int minute) {
    state = state.copyWith(
      data: state.data.copyWith(
        sleepTimeHour: hour,
        sleepTimeMinute: minute,
      ),
    );
  }

  void setPregnant(bool value) {
    state = state.copyWith(
      data: state.data.copyWith(isPregnant: value),
    );
  }

  void setBreastfeeding(bool value) {
    state = state.copyWith(
      data: state.data.copyWith(isBreastfeeding: value),
    );
  }

  void setSelectedMascot(MascotType mascot) {
    state = state.copyWith(
      data: state.data.copyWith(selectedMascot: mascot),
    );
  }

  // ============== GOAL CALCULATION ==============

  /// Calculate the daily water goal
  int calculateGoal() {
    final data = state.data;
    if (data.age == null || data.weightKg == null) return 2000;

    final baseGoal = _calculator.calculateBaseGoal(
      age: data.age!,
      weightKg: data.weightKg!,
    );

    final biologyAdjustment = _calculator.calculateBiologyAdjustment(
      isPregnant: data.isPregnant,
      isBreastfeeding: data.isBreastfeeding,
    );

    return baseGoal + biologyAdjustment;
  }

  // ============== SAVE & COMPLETE ==============

  /// Save onboarding data and complete
  Future<int> saveAndComplete() async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final goal = calculateGoal();
      final finalData = state.data.copyWith(calculatedGoalMl: goal);
      
      await _service.saveProfile(finalData);
      
      state = state.copyWith(
        isSaving: false,
        isComplete: true,
        data: finalData,
      );
      
      return goal;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Không thể lưu thông tin. Vui lòng thử lại.',
      );
      rethrow;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset onboarding
  Future<void> reset() async {
    await _service.clearProfile();
    state = const OnboardingState();
  }
}

/// Onboarding controller provider
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  final service = ref.watch(onboardingServiceProvider);
  const calculator = HydrationCalculator();
  return OnboardingController(service, calculator);
});

// ============== HELPER PROVIDERS ==============

/// Current goal preview (updates as user fills form)
final goalPreviewProvider = Provider<int>((ref) {
  final controller = ref.watch(onboardingControllerProvider.notifier);
  return controller.calculateGoal();
});

/// Formula explanation
final formulaExplanationProvider = Provider<String>((ref) {
  final state = ref.watch(onboardingControllerProvider);
  final data = state.data;
  
  if (data.age == null || data.weightKg == null) {
    return 'Điền thông tin để xem công thức';
  }
  
  String multiplier;
  if (data.age! < 30) {
    multiplier = '40ml × ${data.weightKg!.round()}kg';
  } else if (data.age! <= 55) {
    multiplier = '35ml × ${data.weightKg!.round()}kg';
  } else {
    multiplier = '30ml × ${data.weightKg!.round()}kg';
  }
  
  final parts = <String>[multiplier];
  
  if (data.isPregnant) {
    parts.add('+ 300ml (mang thai)');
  }
  if (data.isBreastfeeding) {
    parts.add('+ 500ml (cho con bú)');
  }
  
  return parts.join('\n');
});

