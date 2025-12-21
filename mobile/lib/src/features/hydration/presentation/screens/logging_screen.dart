import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../core/constants/bhi_constants.dart';

class LoggingScreen extends ConsumerStatefulWidget {
  const LoggingScreen({super.key});

  @override
  ConsumerState<LoggingScreen> createState() => _LoggingScreenState();
}

class _LoggingScreenState extends ConsumerState<LoggingScreen> {
  BeverageType _selectedBeverage = BeverageType.water;
  int _volume = 250;

  @override
  Widget build(BuildContext context) {
    final bhi = _selectedBeverage.bhi;
    final hydrationValue = _selectedBeverage.calculateHydration(_volume);
    final tip = _selectedBeverage.tip;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: GestureDetector(
            onTap: () {}, // Prevent tap propagation
            child: DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text('Hủy'),
                            ),
                            const Text(
                              'Ghi chép',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),
                      const Divider(),
                      // Content
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Beverage type selector
                              const Text(
                                'Loại đồ uống',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.85,
                                ),
                                itemCount: BeverageType.values.length - 1,
                                itemBuilder: (context, index) {
                                  final type = BeverageType.values[index];
                                  final isSelected = _selectedBeverage == type;
                                  return _BeverageItem(
                                    type: type,
                                    isSelected: isSelected,
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      setState(() => _selectedBeverage = type);
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              // BHI info
                              if (bhi != 1.0)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _selectedBeverage.hasWarning
                                        ? AppColors.warning.withOpacity(0.1)
                                        : AppColors.hydroEnd.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _selectedBeverage.hasWarning
                                            ? Icons.warning
                                            : Icons.info,
                                        color: _selectedBeverage.hasWarning
                                            ? AppColors.warning
                                            : AppColors.hydroEnd,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Hydration: ${(bhi * 100).toInt()}% - ${tip ?? ""}',
                                          style: TextStyle(
                                            color: _selectedBeverage.hasWarning
                                                ? AppColors.warning
                                                : AppColors.hydroEnd,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 24),
                              // Volume selector
                              const Text(
                                'Dung tích',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Quick presets
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [150, 250, 500].map((preset) {
                                  final isSelected = _volume == preset;
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 8),
                                    child: ChoiceChip(
                                      label: Text('${preset}ml'),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        if (selected) {
                                          HapticFeedback.selectionClick();
                                          setState(() => _volume = preset);
                                        }
                                      },
                                      selectedColor:
                                          AppColors.hydroEnd.withOpacity(0.2),
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? AppColors.hydroEnd
                                            : AppColors.grey600,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 24),
                              // Custom slider
                              Center(
                                child: Text(
                                  '${_volume}ml',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.hydroEnd,
                                  ),
                                ),
                              ),
                              Slider(
                                value: _volume.toDouble(),
                                min: 50,
                                max: 1000,
                                divisions: 19,
                                activeColor: AppColors.hydroEnd,
                                onChanged: (value) {
                                  setState(() => _volume = value.round());
                                },
                              ),
                              // Hydration value
                              Center(
                                child: Text(
                                  '= ${hydrationValue}ml cấp nước thực tế',
                                  style: TextStyle(
                                    color: AppColors.grey600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Confirm button
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              // TODO: Save log to repository
                              _showSuccessAnimation(context);
                            },
                            child: Text('Uống ${_volume}ml'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessAnimation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              'Đã ghi +${_selectedBeverage.calculateHydration(_volume)}ml',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        action: SnackBarAction(
          label: 'Hoàn tác',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Implement undo
          },
        ),
      ),
    );
    context.pop();
  }
}

class _BeverageItem extends StatelessWidget {
  final BeverageType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _BeverageItem({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.hydroEnd.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.hydroEnd : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconData(type),
              color: isSelected ? AppColors.hydroEnd : AppColors.grey600,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              type.nameVi,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.hydroEnd : AppColors.grey700,
              ),
            ),
            Text(
              '${(type.bhi * 100).toInt()}%',
              style: TextStyle(
                fontSize: 10,
                color: type.hasWarning
                    ? AppColors.warning
                    : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(BeverageType type) {
    switch (type) {
      case BeverageType.water:
        return Icons.water_drop;
      case BeverageType.sparklingWater:
        return Icons.bubble_chart;
      case BeverageType.milk:
        return Icons.local_cafe;
      case BeverageType.coconutWater:
        return Icons.eco;
      case BeverageType.tea:
        return Icons.emoji_food_beverage;
      case BeverageType.coffee:
        return Icons.coffee;
      case BeverageType.juice:
        return Icons.local_bar;
      case BeverageType.soda:
        return Icons.local_drink;
      case BeverageType.alcohol:
        return Icons.wine_bar;
      case BeverageType.energyDrink:
        return Icons.bolt;
      case BeverageType.other:
        return Icons.local_drink;
    }
  }
}

