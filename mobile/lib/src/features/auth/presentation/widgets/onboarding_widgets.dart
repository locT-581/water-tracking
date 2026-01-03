import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../shared/theme/app_gradients.dart';
import '../../domain/entities/user_profile.dart';
import '../../../gamification/domain/models/mascot_models.dart';
import '../../../gamification/domain/services/mascot_registry.dart';
import '../../../gamification/domain/services/mascot_factory.dart';

/// Animated page wrapper for onboarding screens
class OnboardingPageWrapper extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final EdgeInsets padding;

  const OnboardingPageWrapper({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          const SizedBox(height: 32),
          
          // Title with fade-in animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 400),
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            ),
            child: Text(
              title,
              style: AppTextStyles.headlineMedium(),
              textAlign: TextAlign.center,
            ),
          ),
          
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: child,
              ),
              child: Text(
                subtitle!,
                style: AppTextStyles.bodyMedium(color: AppColors.grey600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          
          const SizedBox(height: 48),
          
          // Content with slide-up animation
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: child,
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gender selection card with smooth animation
/// Fixed: Uses Stack + AnimatedOpacity for gradient transition to avoid color flash
class GenderCard extends StatelessWidget {
  final Gender gender;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderCard({
    super.key,
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedScale(
        scale: isSelected ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Container(
          height: 180, // Fixed height - more compact
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                    ? AppColors.hydroEnd.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08),
                blurRadius: isSelected ? 20 : 10,
                offset: Offset(0, isSelected ? 10 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Base white layer
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.grey200,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                
                // Gradient overlay with smooth fade
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      AnimatedScale(
                        scale: isSelected ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          gender == Gender.male 
                              ? Icons.male_rounded 
                              : Icons.female_rounded,
                          size: 56,
                          color: isSelected ? Colors.white : AppColors.grey400,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Label
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: AppTextStyles.titleMedium(
                          color: isSelected ? Colors.white : AppColors.deepOcean,
                        ),
                        child: Text(
                          gender == Gender.male 
                              ? 'onboarding.male'.tr() 
                              : 'onboarding.female'.tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated year picker wheel
class YearPickerWheel extends StatefulWidget {
  final int selectedYear;
  final ValueChanged<int> onChanged;
  final int startYear;
  final int endYear;

  YearPickerWheel({
    super.key,
    required this.selectedYear,
    required this.onChanged,
    this.startYear = 1940,
    int? endYear,
  }) : endYear = endYear ?? DateTime.now().year - 10;

  @override
  State<YearPickerWheel> createState() => _YearPickerWheelState();
}

class _YearPickerWheelState extends State<YearPickerWheel> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: widget.selectedYear - widget.startYear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Stack(
        children: [
          // Selection indicator
          Center(
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: AppGradients.primary.scale(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.hydroEnd.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
          ),
          
          // Wheel
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: 60,
            perspective: 0.003,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              HapticFeedback.selectionClick();
              widget.onChanged(widget.startYear + index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final year = widget.startYear + index;
                final isSelected = year == widget.selectedYear;
                final age = DateTime.now().year - year;
                
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: isSelected
                            ? AppTextStyles.headlineMedium(
                                color: AppColors.hydroEnd,
                              )
                            : AppTextStyles.titleLarge(
                                color: AppColors.grey400,
                              ),
                        child: Text('$year'),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.hydroEnd.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$age tuổi',
                            style: AppTextStyles.labelMedium(
                              color: AppColors.hydroEnd,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
              childCount: widget.endYear - widget.startYear + 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated weight slider with Puru feedback
class WeightSlider extends StatelessWidget {
  final double weight;
  final ValueChanged<double> onChanged;
  final double minWeight;
  final double maxWeight;
  final Widget? puruWidget;

  const WeightSlider({
    super.key,
    required this.weight,
    required this.onChanged,
    this.minWeight = 30,
    this.maxWeight = 150,
    this.puruWidget,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedWeight = (weight - minWeight) / (maxWeight - minWeight);
    
    return Column(
      children: [
        // Puru feedback (size changes with weight)
        if (puruWidget != null)
          AnimatedScale(
            scale: 0.7 + normalizedWeight * 0.5,
            duration: const Duration(milliseconds: 200),
            child: puruWidget,
          )
        else
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 80 + normalizedWeight * 60,
            height: 80 + normalizedWeight * 60,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.hydroEnd.withOpacity(0.3),
                  blurRadius: 20 + normalizedWeight * 10,
                  spreadRadius: normalizedWeight * 5,
                ),
              ],
            ),
            child: Icon(
              Icons.water_drop_rounded,
              color: Colors.white,
              size: 40 + normalizedWeight * 20,
            ),
          ),
        
        const SizedBox(height: 32),
        
        // Weight display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              weight.round().toString(),
              style: AppTextStyles.displayMedium(
                color: AppColors.hydroEnd,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'kg',
              style: AppTextStyles.titleLarge(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Slider
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 8,
              activeTrackColor: AppColors.hydroEnd,
              inactiveTrackColor: AppColors.grey200,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 16,
                elevation: 4,
              ),
              overlayColor: AppColors.hydroEnd.withOpacity(0.2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
            ),
            child: Slider(
              value: weight,
              min: minWeight,
              max: maxWeight,
              divisions: ((maxWeight - minWeight) * 2).round(),
              onChanged: (value) {
                HapticFeedback.selectionClick();
                onChanged(value);
              },
            ),
          ),
        ),
        
        // Min/Max labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${minWeight.round()} kg',
                style: AppTextStyles.caption(color: AppColors.grey500),
              ),
              Text(
                '${maxWeight.round()} kg',
                style: AppTextStyles.caption(color: AppColors.grey500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Time selector card
class TimeSelector extends StatelessWidget {
  final String label;
  final IconData icon;
  final int hour;
  final int minute;
  final VoidCallback onTap;
  final Color? iconColor;

  const TimeSelector({
    super.key,
    required this.label,
    required this.icon,
    required this.hour,
    required this.minute,
    required this.onTap,
    this.iconColor,
  });

  String get _formattedTime {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [AppColors.cardShadow],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.hydroEnd).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.hydroEnd,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.labelMedium(color: AppColors.grey600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formattedTime,
                      style: AppTextStyles.headlineSmall(),
                    ),
                  ],
                ),
              ),
              
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Checkbox tile for pregnancy options
class SpecialStatusTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SpecialStatusTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: value ? AppColors.hydroEnd.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value ? AppColors.hydroEnd : AppColors.grey200,
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Custom checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: value ? AppGradients.primary : null,
                color: value ? null : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: value ? Colors.transparent : AppColors.grey300,
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium(
                      color: value ? AppColors.hydroEnd : AppColors.deepOcean,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall(color: AppColors.grey600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Primary button for onboarding
class OnboardingButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const OnboardingButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: onPressed != null ? AppGradients.primary : null,
        color: onPressed == null ? AppColors.grey300 : null,
        borderRadius: BorderRadius.circular(50),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.hydroEnd.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(50),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    label,
                    style: AppTextStyles.button(
                      color: onPressed != null
                          ? Colors.white
                          : AppColors.grey500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Progress indicator for onboarding
class OnboardingProgress extends StatelessWidget {
  final double progress;
  final int currentPage;
  final int totalPages;

  const OnboardingProgress({
    super.key,
    required this.progress,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalPages, (index) {
            final isActive = index <= currentPage;
            final isCurrent = index == currentPage;
            
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isCurrent ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                gradient: isActive ? AppGradients.primary : null,
                color: isActive ? null : AppColors.grey300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ============== MASCOT SELECTION WIDGETS ==============

/// Mascot selection card for onboarding
/// Shows mascot preview with info and selection state
class MascotSelectionCard extends StatelessWidget {
  final MascotType type;
  final bool isSelected;
  final VoidCallback onTap;

  const MascotSelectionCard({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final info = MascotRegistry.getInfo(type);
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: AnimatedScale(
        scale: isSelected ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                    ? AppColors.hydroEnd.withOpacity(0.3)
                    : Colors.black.withOpacity(0.06),
                blurRadius: isSelected ? 16 : 8,
                offset: Offset(0, isSelected ? 6 : 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Base white layer
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.transparent : AppColors.grey200,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                
                // Gradient overlay with smooth fade
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                
                // Content - more compact
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mascot widget - optimized size
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: MascotWidget(
                            type: type,
                            size: 70,
                            hydrationPercent: 0.8,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Name - compact
                      Text(
                        info.nameVi,
                        style: AppTextStyles.labelMedium(
                          color: isSelected ? Colors.white : AppColors.deepOcean,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Rarity badge - smaller
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withOpacity(0.25)
                              : info.rarity.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          info.rarity.label,
                          style: AppTextStyles.caption(
                            color: isSelected 
                                ? Colors.white 
                                : info.rarity.color,
                          ).copyWith(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Selection checkmark - smaller
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColors.hydroEnd,
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Preview card showing selected mascot with quote
class MascotPreviewCard extends StatelessWidget {
  final MascotType type;
  
  const MascotPreviewCard({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final info = MascotRegistry.getInfo(type);
    final quote = info.quotes.isNotEmpty ? info.quotes.first : '';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.primary.scale(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.hydroEnd.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Mascot
          SizedBox(
            width: 60,
            height: 60,
            child: MascotWidget(
              type: type,
              size: 60,
              hydrationPercent: 0.9,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Quote bubble
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

