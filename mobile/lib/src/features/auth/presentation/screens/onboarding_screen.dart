import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../shared/theme/app_gradients.dart';
import '../../../../app/router.dart';
import '../../../gamification/presentation/widgets/puru/puru_widget.dart';
import '../../../gamification/domain/models/mascot_models.dart';
import '../../../gamification/domain/services/mascot_registry.dart';
import '../../../gamification/domain/services/mascot_factory.dart';
import '../../../gamification/presentation/providers/mascot_providers.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/auth_providers.dart';
import '../providers/onboarding_providers.dart';
import '../widgets/onboarding_widgets.dart';
import '../widgets/goal_reveal_dialog.dart';

/// Onboarding Screen - Collects user profile data
/// 
/// Features:
/// - 5 profile screens: Gender, Birth Year, Weight, Time, Special Status (female only)
/// - Animated transitions and feedback
/// - Puru mascot responds to user input
/// - Saves data locally and calculates base goal
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _completeOnboarding() async {
    final controller = ref.read(onboardingControllerProvider.notifier);
    final state = ref.read(onboardingControllerProvider);
    
    try {
      final goal = await controller.saveAndComplete();
      final formula = ref.read(formulaExplanationProvider);
      
      // Save selected mascot to active mascot provider
      final selectedMascot = state.data.selectedMascot ?? MascotType.aquaAxo;
      await ref.read(activeMascotProvider.notifier).setActiveMascot(selectedMascot);
      
      if (mounted) {
        await GoalRevealDialog.show(
          context,
          goalMl: goal,
          formulaExplanation: formula,
          onStart: () {
            // Invalidate the provider to refresh onboarding status
            ref.invalidate(hasCompletedOnboardingProvider);
            
            // Small delay to ensure provider refresh
            Future.microtask(() {
              if (mounted) {
                context.go(AppRoutes.home);
              }
            });
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('common.error'.tr()),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    // Listen for page changes
    ref.listen<OnboardingState>(onboardingControllerProvider, (prev, next) {
      if (prev?.currentPage != next.currentPage) {
        _animateToPage(next.currentPage);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress and back button
            _buildHeader(state, controller),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => controller.goToPage(page),
                children: [
                  _GenderPage(
                    selected: state.data.gender,
                    onSelected: controller.setGender,
                  ),
                  _BirthYearPage(
                    selectedYear: state.data.birthYear ?? 1990,
                    onChanged: controller.setBirthYear,
                  ),
                  _WeightPage(
                    weight: state.data.weightKg ?? 65,
                    onChanged: controller.setWeight,
                  ),
                  _TimePage(
                    wakeHour: state.data.wakeTimeHour,
                    wakeMinute: state.data.wakeTimeMinute,
                    sleepHour: state.data.sleepTimeHour,
                    sleepMinute: state.data.sleepTimeMinute,
                    onWakeTimeChanged: controller.setWakeTime,
                    onSleepTimeChanged: controller.setSleepTime,
                  ),
                  if (state.data.gender == Gender.female)
                    _PregnancyPage(
                      isPregnant: state.data.isPregnant,
                      isBreastfeeding: state.data.isBreastfeeding,
                      onPregnantChanged: controller.setPregnant,
                      onBreastfeedingChanged: controller.setBreastfeeding,
                    ),
                  // Mascot Selection Page (always last)
                  _MascotSelectionPage(
                    selected: state.data.selectedMascot,
                    onSelected: controller.setSelectedMascot,
                  ),
                ],
              ),
            ),
            
            // Bottom button
            _buildBottomButton(state, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(OnboardingState state, OnboardingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back button - only show if not on first page
          AnimatedOpacity(
            opacity: state.currentPage > 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: state.currentPage > 0
                  ? () {
                      HapticFeedback.lightImpact();
                      controller.previousPage();
                    }
                  : null,
              icon: const Icon(Icons.arrow_back_rounded),
              color: AppColors.deepOcean,
            ),
          ),
          
          // Progress indicator
          Expanded(
            child: OnboardingProgress(
              progress: state.progress,
              currentPage: state.currentPage,
              totalPages: state.totalPages,
            ),
          ),
          
          // Skip button (placeholder for alignment)
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBottomButton(
    OnboardingState state,
    OnboardingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: OnboardingButton(
        label: state.isLastPage 
            ? 'common.done'.tr() 
            : 'common.continue'.tr(),
        onPressed: state.canProceed
            ? () {
                HapticFeedback.mediumImpact();
                if (state.isLastPage) {
                  _completeOnboarding();
                } else {
                  controller.nextPage();
                }
              }
            : null,
        isLoading: state.isSaving,
      ),
    );
  }
}

// ============== PAGE 1: GENDER ==============

class _GenderPage extends StatelessWidget {
  final Gender? selected;
  final ValueChanged<Gender> onSelected;

  const _GenderPage({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingPageWrapper(
      title: 'onboarding.gender_title'.tr(),
      child: Row(
        children: [
          Expanded(
            child: GenderCard(
              gender: Gender.male,
              isSelected: selected == Gender.male,
              onTap: () => onSelected(Gender.male),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GenderCard(
              gender: Gender.female,
              isSelected: selected == Gender.female,
              onTap: () => onSelected(Gender.female),
            ),
          ),
        ],
      ),
    );
  }
}

// ============== PAGE 2: BIRTH YEAR ==============

class _BirthYearPage extends StatelessWidget {
  final int selectedYear;
  final ValueChanged<int> onChanged;

  const _BirthYearPage({
    required this.selectedYear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingPageWrapper(
      title: 'onboarding.birth_year_title'.tr(),
      child: Column(
        children: [
          // Puru with age feedback
          _AgeFeedbackPuru(age: DateTime.now().year - selectedYear),
          
          const SizedBox(height: 32),
          
          // Year picker
          Expanded(
            child: YearPickerWheel(
              selectedYear: selectedYear,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgeFeedbackPuru extends StatelessWidget {
  final int age;

  const _AgeFeedbackPuru({required this.age});

  @override
  Widget build(BuildContext context) {
    // Puru hydration based on water needs (younger = more)
    double hydration;
    if (age < 30) {
      hydration = 0.9;
    } else if (age <= 55) {
      hydration = 0.75;
    } else {
      hydration = 0.6;
    }

    return Column(
      children: [
        PuruWidget(
          size: 100,
          hydrationPercent: hydration,
          showMessage: false,
          showGlowEffect: false,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.hydroEnd.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            age < 30 
                ? 'Cơ thể cần nhiều nước!' 
                : age <= 55 
                    ? 'Cân bằng nước tốt' 
                    : 'Uống nước đều đặn nhé',
            style: AppTextStyles.labelMedium(color: AppColors.hydroEnd),
          ),
        ),
      ],
    );
  }
}

// ============== PAGE 3: WEIGHT ==============

class _WeightPage extends StatelessWidget {
  final double weight;
  final ValueChanged<double> onChanged;

  const _WeightPage({
    required this.weight,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingPageWrapper(
      title: 'onboarding.weight_title'.tr(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WeightSlider(
            weight: weight,
            onChanged: onChanged,
            puruWidget: PuruWidget(
              size: 120,
              hydrationPercent: 0.7,
              showMessage: false,
              showGlowEffect: false,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Goal preview
          _GoalPreview(weightKg: weight),
        ],
      ),
    );
  }
}

class _GoalPreview extends StatelessWidget {
  final double weightKg;

  const _GoalPreview({required this.weightKg});

  @override
  Widget build(BuildContext context) {
    // Approximate goal (assuming age 30)
    final approxGoal = (weightKg * 35).round();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primary.scale(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.hydroEnd.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.water_drop_outlined,
            color: AppColors.hydroEnd,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Khoảng ~$approxGoal ml/ngày',
            style: AppTextStyles.labelLarge(color: AppColors.hydroEnd),
          ),
        ],
      ),
    );
  }
}

// ============== PAGE 4: TIME ==============

class _TimePage extends StatelessWidget {
  final int wakeHour;
  final int wakeMinute;
  final int sleepHour;
  final int sleepMinute;
  final void Function(int, int) onWakeTimeChanged;
  final void Function(int, int) onSleepTimeChanged;

  const _TimePage({
    required this.wakeHour,
    required this.wakeMinute,
    required this.sleepHour,
    required this.sleepMinute,
    required this.onWakeTimeChanged,
    required this.onSleepTimeChanged,
  });

  int get _activeHours {
    final wake = wakeHour * 60 + wakeMinute;
    var sleep = sleepHour * 60 + sleepMinute;
    if (sleep < wake) sleep += 24 * 60;
    return (sleep - wake) ~/ 60;
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageWrapper(
      title: 'onboarding.time_title'.tr(),
      subtitle: 'onboarding.time_subtitle'.tr(),
      child: Column(
        children: [
          // Active hours display
          _ActiveHoursDisplay(hours: _activeHours),
          
          const SizedBox(height: 32),
          
          // Wake time
          TimeSelector(
            label: 'onboarding.wake_time'.tr(),
            icon: Icons.wb_sunny_rounded,
            hour: wakeHour,
            minute: wakeMinute,
            iconColor: Colors.orange,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: wakeHour, minute: wakeMinute),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: AppColors.hydroEnd,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                onWakeTimeChanged(picked.hour, picked.minute);
              }
            },
          ),
          
          const SizedBox(height: 16),
          
          // Sleep time
          TimeSelector(
            label: 'onboarding.sleep_time'.tr(),
            icon: Icons.bedtime_rounded,
            hour: sleepHour,
            minute: sleepMinute,
            iconColor: Colors.indigo,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: sleepHour, minute: sleepMinute),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: AppColors.hydroEnd,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                onSleepTimeChanged(picked.hour, picked.minute);
              }
            },
          ),
          
          const Spacer(),
          
          // Puru sleeping
          Opacity(
            opacity: 0.7,
            child: PuruMini(
              size: 60,
              hydrationPercent: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveHoursDisplay extends StatelessWidget {
  final int hours;

  const _ActiveHoursDisplay({required this.hours});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            color: AppColors.hydroEnd,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$hours giờ hoạt động',
            style: AppTextStyles.labelLarge(color: AppColors.deepOcean),
          ),
        ],
      ),
    );
  }
}

// ============== PAGE 5: PREGNANCY (FEMALE ONLY) ==============

class _PregnancyPage extends StatelessWidget {
  final bool isPregnant;
  final bool isBreastfeeding;
  final ValueChanged<bool> onPregnantChanged;
  final ValueChanged<bool> onBreastfeedingChanged;

  const _PregnancyPage({
    required this.isPregnant,
    required this.isBreastfeeding,
    required this.onPregnantChanged,
    required this.onBreastfeedingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingPageWrapper(
      title: 'onboarding.special_status'.tr(),
      subtitle: 'onboarding.special_status_subtitle'.tr(),
      child: Column(
        children: [
          SpecialStatusTile(
            title: 'onboarding.pregnant'.tr(),
            subtitle: '+300ml/ngày',
            value: isPregnant,
            onChanged: onPregnantChanged,
          ),
          
          const SizedBox(height: 16),
          
          SpecialStatusTile(
            title: 'onboarding.breastfeeding'.tr(),
            subtitle: '+500ml/ngày',
            value: isBreastfeeding,
            onChanged: onBreastfeedingChanged,
          ),
          
          // Extra goal display - animate in when selected
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: (isPregnant || isBreastfeeding)
                ? Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: _ExtraGoalDisplay(
                      isPregnant: isPregnant,
                      isBreastfeeding: isBreastfeeding,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          
          const Spacer(),
          
          // Supportive Puru - smaller to avoid overflow
          PuruWidget(
            size: 70,
            hydrationPercent: 0.8,
            showMessage: false,
          ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ExtraGoalDisplay extends StatelessWidget {
  final bool isPregnant;
  final bool isBreastfeeding;

  const _ExtraGoalDisplay({
    required this.isPregnant,
    required this.isBreastfeeding,
  });

  int get _extraMl {
    int extra = 0;
    if (isPregnant) extra += 300;
    if (isBreastfeeding) extra += 500;
    return extra;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primary.scale(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.hydroEnd.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_rounded,
              color: AppColors.hydroEnd,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '+$_extraMl ml',
                style: AppTextStyles.titleLarge(color: AppColors.hydroEnd),
              ),
              Text(
                'sẽ được thêm vào mục tiêu',
                style: AppTextStyles.bodySmall(color: AppColors.grey600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============== PAGE: MASCOT SELECTION ==============

class _MascotSelectionPage extends StatelessWidget {
  final MascotType? selected;
  final ValueChanged<MascotType> onSelected;

  const _MascotSelectionPage({
    required this.selected,
    required this.onSelected,
  });

  /// Launch mascots available for selection during onboarding
  static const List<MascotType> _availableMascots = [
    MascotType.aquaAxo,         // Classic Puru (default)
    MascotType.celestialDrop,   // Celestial Drop
    MascotType.liquidChibiBot,  // Chibi Bot
  ];

  @override
  Widget build(BuildContext context) {
    // Custom layout for mascot selection - more compact header
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          
          // Compact title
          Text(
            'onboarding.mascot_title'.tr(),
            style: AppTextStyles.headlineSmall(),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            'onboarding.mascot_subtitle'.tr(),
            style: AppTextStyles.bodySmall(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Selected mascot preview with smooth size animation
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: selected != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _CompactMascotPreview(type: selected!),
                  )
                : const SizedBox.shrink(),
          ),
          
          // Mascot cards - fixed height row
          SizedBox(
            height: 180,
            child: Row(
              children: _availableMascots.map((mascot) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: MascotSelectionCard(
                      type: mascot,
                      isSelected: selected == mascot,
                      onTap: () => onSelected(mascot),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const Spacer(),
          
          // Info text - more compact
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.grey600,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'onboarding.mascot_info'.tr(),
                    style: AppTextStyles.caption(color: AppColors.grey600),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Compact preview of selected mascot with smooth animation
class _CompactMascotPreview extends StatelessWidget {
  final MascotType type;
  
  const _CompactMascotPreview({required this.type});

  @override
  Widget build(BuildContext context) {
    final info = MascotRegistry.getInfo(type);
    final quote = info.quotes.isNotEmpty ? info.quotes.first : '';
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppGradients.primary.scale(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.hydroEnd.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small mascot preview
          SizedBox(
            width: 48,
            height: 48,
            child: MascotWidget(
              type: type,
              size: 48,
              hydrationPercent: 0.9,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Quote - full display without ellipsis
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  info.nameVi,
                  style: AppTextStyles.labelMedium(
                    color: AppColors.hydroEnd,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quote,
                  style: AppTextStyles.bodySmall(
                    color: AppColors.grey700,
                  ),
                  // No maxLines or overflow - show full quote
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
