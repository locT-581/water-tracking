import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../app/router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form data
  String? _gender;
  int _birthYear = 1990;
  double _weight = 70;
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _sleepTime = const TimeOfDay(hour: 23, minute: 0);
  bool _isPregnant = false;
  bool _isBreastfeeding = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _completeOnboarding() {
    // TODO: Save user profile to Supabase and Isar
    // Calculate and show base goal
    final age = DateTime.now().year - _birthYear;
    final baseGoal = _calculateBaseGoal(age, _weight);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Mục tiêu của bạn'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.hydroGradient,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$baseGoal',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ml / ngày',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Mục tiêu này sẽ tự động điều chỉnh theo thời tiết và hoạt động của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey600),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.home);
            },
            child: const Text('Bắt đầu!'),
          ),
        ],
      ),
    );
  }

  int _calculateBaseGoal(int age, double weightKg) {
    if (age < 30) {
      return (weightKg * 40).round();
    } else if (age <= 55) {
      return (weightKg * 35).round();
    } else {
      return (weightKg * 30).round();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back),
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / 5,
                      backgroundColor: AppColors.grey200,
                      valueColor: const AlwaysStoppedAnimation(AppColors.hydroEnd),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _GenderPage(
                    selected: _gender,
                    onSelected: (gender) => setState(() => _gender = gender),
                  ),
                  _BirthYearPage(
                    year: _birthYear,
                    onChanged: (year) => setState(() => _birthYear = year),
                  ),
                  _WeightPage(
                    weight: _weight,
                    onChanged: (weight) => setState(() => _weight = weight),
                  ),
                  _TimePage(
                    wakeTime: _wakeTime,
                    sleepTime: _sleepTime,
                    onWakeTimeChanged: (time) => setState(() => _wakeTime = time),
                    onSleepTimeChanged: (time) => setState(() => _sleepTime = time),
                  ),
                  if (_gender == 'female')
                    _PregnancyPage(
                      isPregnant: _isPregnant,
                      isBreastfeeding: _isBreastfeeding,
                      onPregnantChanged: (v) => setState(() => _isPregnant = v),
                      onBreastfeedingChanged: (v) => setState(() => _isBreastfeeding = v),
                    )
                  else
                    _SummaryPage(
                      gender: _gender ?? '',
                      birthYear: _birthYear,
                      weight: _weight,
                    ),
                ],
              ),
            ),
            // Next button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canProceed() ? _nextPage : null,
                  child: Text(_currentPage == 4 ? 'Hoàn tất' : 'Tiếp tục'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return _gender != null;
      default:
        return true;
    }
  }
}

// Gender selection page
class _GenderPage extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  const _GenderPage({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Bạn là?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: _GenderCard(
                  icon: Icons.male,
                  label: 'Nam',
                  isSelected: selected == 'male',
                  onTap: () => onSelected('male'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _GenderCard(
                  icon: Icons.female,
                  label: 'Nữ',
                  isSelected: selected == 'female',
                  onTap: () => onSelected('female'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.hydroEnd.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.hydroEnd : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 64,
              color: isSelected ? AppColors.hydroEnd : AppColors.grey500,
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.hydroEnd : AppColors.deepOcean,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Birth year page
class _BirthYearPage extends StatelessWidget {
  final int year;
  final ValueChanged<int> onChanged;

  const _BirthYearPage({required this.year, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Năm sinh của bạn?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 200,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 60,
              perspective: 0.005,
              diameterRatio: 1.5,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                onChanged(1940 + index);
              },
              controller: FixedExtentScrollController(
                initialItem: year - 1940,
              ),
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  final itemYear = 1940 + index;
                  final isSelected = itemYear == year;
                  return Center(
                    child: Text(
                      '$itemYear',
                      style: TextStyle(
                        fontSize: isSelected ? 32 : 24,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.hydroEnd : AppColors.grey400,
                      ),
                    ),
                  );
                },
                childCount: DateTime.now().year - 1940 + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Weight page
class _WeightPage extends StatelessWidget {
  final double weight;
  final ValueChanged<double> onChanged;

  const _WeightPage({required this.weight, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Cân nặng của bạn?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 48),
          // Puru size indicator placeholder
          Container(
            width: 80 + (weight - 40) * 1.5,
            height: 80 + (weight - 40) * 1.5,
            decoration: BoxDecoration(
              gradient: AppColors.hydroGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.water_drop, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 32),
          Text(
            '${weight.round()} kg',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.hydroEnd,
            ),
          ),
          const SizedBox(height: 24),
          Slider(
            value: weight,
            min: 30,
            max: 150,
            divisions: 120,
            activeColor: AppColors.hydroEnd,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// Wake/Sleep time page
class _TimePage extends StatelessWidget {
  final TimeOfDay wakeTime;
  final TimeOfDay sleepTime;
  final ValueChanged<TimeOfDay> onWakeTimeChanged;
  final ValueChanged<TimeOfDay> onSleepTimeChanged;

  const _TimePage({
    required this.wakeTime,
    required this.sleepTime,
    required this.onWakeTimeChanged,
    required this.onSleepTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Thời gian sinh hoạt',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Để chúng tôi không làm phiền bạn vào giờ ngủ',
            style: TextStyle(color: AppColors.grey600),
          ),
          const SizedBox(height: 48),
          _TimeSelector(
            label: 'Giờ thức dậy',
            icon: Icons.wb_sunny,
            time: wakeTime,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: wakeTime,
              );
              if (picked != null) onWakeTimeChanged(picked);
            },
          ),
          const SizedBox(height: 24),
          _TimeSelector(
            label: 'Giờ đi ngủ',
            icon: Icons.bedtime,
            time: sleepTime,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: sleepTime,
              );
              if (picked != null) onSleepTimeChanged(picked);
            },
          ),
        ],
      ),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  final String label;
  final IconData icon;
  final TimeOfDay time;
  final VoidCallback onTap;

  const _TimeSelector({
    required this.label,
    required this.icon,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.hydroEnd),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: AppColors.grey600)),
                Text(
                  time.format(context),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

// Pregnancy page (only for female)
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Trạng thái đặc biệt',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Phụ nữ mang thai và cho con bú cần uống nhiều nước hơn',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey600),
          ),
          const SizedBox(height: 48),
          CheckboxListTile(
            value: isPregnant,
            onChanged: (v) => onPregnantChanged(v ?? false),
            title: const Text('Đang mang thai'),
            subtitle: const Text('+300ml/ngày'),
            activeColor: AppColors.hydroEnd,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: isBreastfeeding,
            onChanged: (v) => onBreastfeedingChanged(v ?? false),
            title: const Text('Đang cho con bú'),
            subtitle: const Text('+500ml/ngày'),
            activeColor: AppColors.hydroEnd,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }
}

// Summary page
class _SummaryPage extends StatelessWidget {
  final String gender;
  final int birthYear;
  final double weight;

  const _SummaryPage({
    required this.gender,
    required this.birthYear,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Xác nhận thông tin',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 48),
          _InfoRow(label: 'Giới tính', value: gender == 'male' ? 'Nam' : 'Nữ'),
          _InfoRow(label: 'Năm sinh', value: '$birthYear'),
          _InfoRow(label: 'Cân nặng', value: '${weight.round()} kg'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.grey600)),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

