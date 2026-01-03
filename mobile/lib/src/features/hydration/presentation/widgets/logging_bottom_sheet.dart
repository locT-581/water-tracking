import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/bhi_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../shared/theme/app_gradients.dart';
import '../../../../shared/widgets/toast_overlay.dart';
import '../providers/hydration_providers.dart';

/// Glassmorphism logging bottom sheet
/// Opens when user taps FAB to log water intake
class LoggingBottomSheet extends ConsumerStatefulWidget {
  const LoggingBottomSheet({super.key});

  @override
  ConsumerState<LoggingBottomSheet> createState() => _LoggingBottomSheetState();

  /// Show the logging bottom sheet
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LoggingBottomSheet(),
    );
  }
}

class _LoggingBottomSheetState extends ConsumerState<LoggingBottomSheet>
    with SingleTickerProviderStateMixin {
  BeverageType _selectedBeverage = BeverageType.water;
  int _selectedVolume = 250;
  bool _isLogging = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + bottomPadding,
          top: 100,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.hydroEnd.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  _buildHandle(),
                  
                  // Header
                  _buildHeader(),

                  // Beverage Grid
                  _buildBeverageGrid(),

                  // Volume Slider
                  _buildVolumeSection(),

                  // Quick Add Buttons
                  _buildQuickAddButtons(),

                  // BHI Info
                  if (_selectedBeverage.hasWarning) _buildBhiWarning(),

                  // Confirm Button
                  _buildConfirmButton(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.grey300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final hydrationMl = (_selectedVolume * _selectedBeverage.bhi).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ghi chép nước',
                style: AppTextStyles.titleLarge().bold,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.water_drop,
                    size: 16,
                    color: AppColors.hydroEnd,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Hydration: ${hydrationMl}ml',
                    style: AppTextStyles.labelMedium(color: AppColors.hydroEnd),
                  ),
                  if (_selectedBeverage.bhi < 1.0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${(_selectedBeverage.bhi * 100).round()}%',
                        style: AppTextStyles.labelSmall(color: AppColors.warning),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          // Close button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            color: AppColors.grey500,
          ),
        ],
      ),
    );
  }

  Widget _buildBeverageGrid() {
    // Common beverages first
    final beverages = [
      BeverageType.water,
      BeverageType.tea,
      BeverageType.coffee,
      BeverageType.milk,
      BeverageType.juice,
      BeverageType.coconutWater,
      BeverageType.sparklingWater,
      BeverageType.soda,
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.9,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: beverages.length,
        itemBuilder: (context, index) {
          final beverage = beverages[index];
          final isSelected = beverage == _selectedBeverage;

          return _BeverageItem(
            beverage: beverage,
            isSelected: isSelected,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedBeverage = beverage);
            },
          );
        },
      ),
    );
  }

  Widget _buildVolumeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Volume display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: _selectedVolume, end: _selectedVolume),
                duration: const Duration(milliseconds: 200),
                builder: (context, value, child) {
                  return Text(
                    '$value',
                    style: AppTextStyles.displayMedium().bold.withColor(
                          AppColors.hydroEnd,
                        ),
                  );
                },
              ),
              const SizedBox(width: 4),
              Text(
                'ml',
                style: AppTextStyles.titleLarge(color: AppColors.grey500),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.hydroEnd,
              inactiveTrackColor: AppColors.grey200,
              thumbColor: Colors.white,
              overlayColor: AppColors.hydroEnd.withValues(alpha: 0.2),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 14,
                elevation: 4,
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            ),
            child: Slider(
              value: _selectedVolume.toDouble(),
              min: 50,
              max: 1000,
              divisions: 19,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() => _selectedVolume = value.round());
              },
            ),
          ),
          // Min/Max labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('50ml', style: AppTextStyles.labelSmall(color: AppColors.grey400)),
                Text('1000ml', style: AppTextStyles.labelSmall(color: AppColors.grey400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: AppConstants.quickAddPresets.map((preset) {
          final isSelected = _selectedVolume == preset;
          return _QuickAddButton(
            volume: preset,
            isSelected: isSelected,
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _selectedVolume = preset);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBhiWarning() {
    final tip = _selectedBeverage.tip;
    if (tip == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.bodySmall(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    final hydrationMl = (_selectedVolume * _selectedBeverage.bhi).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLogging ? null : _logWater,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.hydroEnd.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              alignment: Alignment.center,
              child: _isLogging
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_rounded, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Uống ${_selectedVolume}ml (+${hydrationMl}ml)',
                          style: AppTextStyles.button(),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logWater() async {
    setState(() => _isLogging = true);
    HapticFeedback.mediumImpact();

    // Capture notifier BEFORE any async operation
    final logsNotifier = ref.read(todayLogsProvider.notifier);

    try {
      // Add log via provider
      await logsNotifier.addLog(
        beverageType: _selectedBeverage,
        volumeMl: _selectedVolume,
      );

      // Get last log for undo (before closing)
      final lastLog = logsNotifier.getLastLog();
      
      if (mounted) {
        Navigator.pop(context);
      }
      
      // Show toast (works even after widget dispose)
      if (lastLog != null) {
        toast.success(
          '+${lastLog.hydrationMl}ml ${lastLog.beverageType.nameVi} 💧',
          onUndo: () => logsNotifier.removeLog(lastLog.logId),
        );
      }
    } catch (e) {
      toast.error('Không thể ghi chép: $e');
    } finally {
      if (mounted) {
        setState(() => _isLogging = false);
      }
    }
  }
}

/// Individual beverage item in the grid
class _BeverageItem extends StatelessWidget {
  final BeverageType beverage;
  final bool isSelected;
  final VoidCallback onTap;

  const _BeverageItem({
    required this.beverage,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.hydroEnd : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.hydroEnd : AppColors.grey200,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.hydroEnd.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                beverage.icon,
                size: 28,
                color: isSelected ? Colors.white : AppColors.grey600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              beverage.nameVi,
              style: AppTextStyles.labelSmall(
                color: isSelected ? Colors.white : AppColors.grey700,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (beverage.bhi < 1.0) ...[
              const SizedBox(height: 2),
              Text(
                '${(beverage.bhi * 100).round()}%',
                style: AppTextStyles.labelSmall(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.8)
                      : AppColors.warning,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Quick add preset button
class _QuickAddButton extends StatelessWidget {
  final int volume;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.volume,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.hydroEnd : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.hydroEnd : AppColors.grey300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.hydroEnd.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          '${volume}ml',
          style: AppTextStyles.labelLarge(
            color: isSelected ? Colors.white : AppColors.grey700,
          ).semibold,
        ),
      ),
    );
  }
}

