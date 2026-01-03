import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/bhi_constants.dart';
import '../../../../core/providers/weather_providers.dart';
import '../../../../core/services/location_permission_service.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../gamification/presentation/widgets/puru/puru_widget.dart';
import '../../domain/entities/daily_goal.dart';
import '../../domain/entities/water_log.dart';
import '../providers/hydration_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasRequestedPermission = false;
  LocationPermissionStatus? _permissionStatus;

  @override
  void initState() {
    super.initState();
    // Request location permission after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  Future<void> _checkLocationPermission() async {
    if (_hasRequestedPermission) return;
    _hasRequestedPermission = true;

    final status = await LocationPermissionService.checkAndRequestPermission();
    
    if (mounted) {
      setState(() {
        _permissionStatus = status;
      });

      // If permission granted, refresh weather
      if (status == LocationPermissionStatus.granted) {
        ref.read(todayGoalProvider.notifier).refreshWeatherAdjustment();
      }
    }
  }

  void _handleWeatherTap() async {
    HapticFeedback.lightImpact();

    // Check current permission status
    if (_permissionStatus == LocationPermissionStatus.deniedForever) {
      if (mounted) {
        await LocationPermissionService.showPermissionDeniedDialog(
          context,
          isDeniedForever: true,
        );
        // User went to settings, we'll check again when they come back
      }
    } else if (_permissionStatus == LocationPermissionStatus.denied) {
      if (mounted) {
        final shouldRetry = await LocationPermissionService.showPermissionDeniedDialog(
          context,
          isDeniedForever: false,
        );
        
        if (shouldRetry && mounted) {
          // User wants to grant permission, request it
          final newStatus = await LocationPermissionService.checkAndRequestPermission();
          setState(() => _permissionStatus = newStatus);
          
          if (newStatus == LocationPermissionStatus.granted) {
            ref.read(todayGoalProvider.notifier).refreshWeatherAdjustment();
          }
        }
      }
    } else if (_permissionStatus == LocationPermissionStatus.serviceDisabled) {
      if (mounted) {
        LocationPermissionService.showServiceDisabledSnackbar(context);
      }
    } else {
      // Permission granted, just refresh weather
      ref.read(todayGoalProvider.notifier).refreshWeatherAdjustment();
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalAsync = ref.watch(todayGoalProvider);
    final logsAsync = ref.watch(todayLogsProvider);
    final progress = ref.watch(todayProgressProvider);
    final totalHydration = ref.watch(todayTotalHydrationProvider);
    final hydrationStatus = ref.watch(hydrationStatusProvider);
    final weatherInfo = ref.watch(weatherAdjustmentInfoProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getBackgroundGradient(),
        ),
        child: SafeArea(
          child: goalAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
                  const SizedBox(height: 16),
                  Text('Không thể tải mục tiêu', style: AppTextStyles.bodyLarge()),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(todayGoalProvider.notifier).refresh();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            data: (goal) => CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(context, goal, weatherInfo),
                ),
                
                // Main progress area
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Progress Ring with Puru
                          _buildProgressRing(
                            context, 
                            totalHydration, 
                            goal.totalGoalMl, 
                            progress,
                            hydrationStatus,
                          ),
                          const SizedBox(height: 24),
                          // Status message
                          _buildStatusMessage(hydrationStatus, goal.remainingMl),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Fact of the day
                SliverToBoxAdapter(
                  child: _buildFactOfDay(context),
                ),
                
                // Today's logs preview
                SliverToBoxAdapter(
                  child: logsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (logs) => _buildTodayLogsPreview(context, logs),
                  ),
                ),
                
                // Space for FAB
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, 
    DailyGoal goal,
    WeatherAdjustmentInfo weatherInfo,
  ) {
    // Determine weather display state
    final hasWeatherData = weatherInfo.hasData;
    final isLoading = weatherInfo.isLoading && !hasWeatherData;
    
    // Show location hint when: no data, not loading, and permission not granted
    final needsLocationPermission = !hasWeatherData && 
        !isLoading &&
        _permissionStatus != LocationPermissionStatus.granted;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Weather indicator
          GestureDetector(
            onTap: _handleWeatherTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: needsLocationPermission 
                    ? AppColors.warning.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [AppColors.cardShadow],
                border: needsLocationPermission 
                    ? Border.all(color: AppColors.warning, width: 1)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (needsLocationPermission)
                    const Icon(
                      Icons.location_off,
                      color: AppColors.warning,
                      size: 18,
                    )
                  else
                    Text(
                      weatherInfo.weatherEmoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                  const SizedBox(width: 4),
                  Text(
                    needsLocationPermission 
                        ? 'Bật vị trí' 
                        : weatherInfo.temperatureString,
                    style: AppTextStyles.labelLarge(
                      color: needsLocationPermission ? AppColors.warning : AppColors.deepOcean,
                    ).bold,
                  ),
                  if (goal.weatherAdjustmentMl > 0 && !needsLocationPermission) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.hydroEnd.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '+${goal.weatherAdjustmentMl}ml',
                        style: AppTextStyles.labelSmall(color: AppColors.hydroEnd).semibold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Goal breakdown chip
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _showGoalBreakdown(context, goal);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [AppColors.cardShadow],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.water_drop, color: AppColors.hydroEnd, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${goal.totalGoalMl}ml',
                    style: AppTextStyles.labelLarge().bold,
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.info_outline, color: AppColors.grey500, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRing(
    BuildContext context,
    int currentMl,
    int goalMl,
    double progress,
    HydrationStatus status,
  ) {
    // Responsive size based on screen
    final screenWidth = MediaQuery.of(context).size.width;
    final ringSize = (screenWidth * 0.65).clamp(200.0, 260.0);
    final puruSize = (ringSize * 0.28).clamp(50.0, 70.0);
    
    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated progress ring
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return CustomPaint(
                size: Size(ringSize, ringSize),
                painter: _WaterProgressPainter(progress: value),
              );
            },
          ),
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Puru mascot
              PuruWidget(
                size: puruSize,
                hydrationPercent: progress.clamp(0.0, 1.0),
                showMessage: false,
                showGlowEffect: progress >= 1.0,
              ),
              const SizedBox(height: 8),
              // Current value with animation
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: currentMl),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Text(
                    NumberFormat('#,###').format(value),
                    style: AppTextStyles.displayMedium().bold,
                  );
                },
              ),
              Text(
                '/ ${NumberFormat('#,###').format(goalMl)} ml',
                style: AppTextStyles.bodyMedium(color: AppColors.grey600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessage(HydrationStatus status, int remainingMl) {
    String message;
    String emoji;

    switch (status) {
      case HydrationStatus.hydrated:
        message = 'Tuyệt vời! Bạn đã đạt mục tiêu!';
        emoji = '🎉';
      case HydrationStatus.good:
        message = 'Còn ${NumberFormat('#,###').format(remainingMl)}ml nữa!';
        emoji = '💪';
      case HydrationStatus.okay:
        message = 'Cố lên! Còn ${NumberFormat('#,###').format(remainingMl)}ml';
        emoji = '🎯';
      case HydrationStatus.thirsty:
        message = 'Puru đang khát! Uống nước đi!';
        emoji = '💧';
      case HydrationStatus.dehydrated:
        message = 'Cơ thể cần nước ngay!';
        emoji = '🆘';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Text(
        '$emoji $message',
        style: AppTextStyles.bodyLarge().semibold,
      ),
    );
  }

  Widget _buildFactOfDay(BuildContext context) {
    // TODO: Get from API or local database
    const facts = [
      'Cơ thể mất ~2.5L nước mỗi ngày qua mồ hôi và hơi thở.',
      'Uống nước trước ăn 30 phút giúp kiểm soát cân nặng.',
      'Nước chiếm 60% trọng lượng cơ thể người trưởng thành.',
      'Thiếu 2% nước có thể giảm 25% hiệu suất tập luyện.',
      'Não bộ gồm 73% nước, thiếu nước khiến khó tập trung.',
    ];
    
    final todayFact = facts[DateTime.now().day % facts.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.science.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.science,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sự thật trong ngày',
                  style: AppTextStyles.caption(color: AppColors.science).bold,
                ),
                Text(
                  todayFact,
                  style: AppTextStyles.caption(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayLogsPreview(BuildContext context, List<WaterLog> logs) {
    if (logs.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppColors.cardShadow],
        ),
        child: Row(
          children: [
            Icon(Icons.water_drop_outlined, color: AppColors.grey400, size: 20),
            const SizedBox(width: 8),
            Text(
              'Chưa có ghi chép nào hôm nay',
              style: AppTextStyles.caption(color: AppColors.grey500),
            ),
          ],
        ),
      );
    }

    // Show last 5 logs in horizontal scroll
    final recentLogs = logs.reversed.take(5).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hôm nay',
                style: AppTextStyles.labelMedium().bold,
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // TODO: Navigate to full history
                },
                child: Text(
                  'Xem tất cả',
                  style: AppTextStyles.labelSmall(color: AppColors.hydroEnd).semibold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 58,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recentLogs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) => _LogChip(log: recentLogs[index]),
            ),
          ),
        ],
      ),
    );
  }

  void _showGoalBreakdown(BuildContext context, DailyGoal goal) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Chi tiết mục tiêu',
              style: AppTextStyles.titleLarge().bold,
            ),
            const SizedBox(height: 20),
            _GoalBreakdownRow(
              icon: Icons.person,
              label: 'Mục tiêu cơ bản',
              value: '${NumberFormat('#,###').format(goal.baseGoalMl)}ml',
              color: AppColors.deepOcean,
            ),
            if (goal.weatherAdjustmentMl > 0) ...[
              const SizedBox(height: 12),
              _GoalBreakdownRow(
                icon: Icons.wb_sunny,
                label: 'Điều chỉnh thời tiết',
                value: '+${goal.weatherAdjustmentMl}ml',
                color: Colors.orange,
                subtitle: goal.temperatureC != null 
                    ? '${goal.temperatureC!.round()}°C' 
                    : null,
              ),
            ],
            if (goal.activityAdjustmentMl > 0) ...[
              const SizedBox(height: 12),
              _GoalBreakdownRow(
                icon: Icons.directions_run,
                label: 'Vận động',
                value: '+${goal.activityAdjustmentMl}ml',
                color: AppColors.success,
              ),
            ],
            if (goal.biologyAdjustmentMl > 0) ...[
              const SizedBox(height: 12),
              _GoalBreakdownRow(
                icon: Icons.favorite,
                label: 'Sinh học',
                value: '+${goal.biologyAdjustmentMl}ml',
                color: Colors.pink,
              ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _GoalBreakdownRow(
              icon: Icons.water_drop,
              label: 'Tổng mục tiêu',
              value: '${NumberFormat('#,###').format(goal.totalGoalMl)}ml',
              color: AppColors.hydroEnd,
              isTotal: true,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  LinearGradient _getBackgroundGradient() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      // Morning
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFF9C4), AppColors.lightBackground],
      );
    } else if (hour >= 12 && hour < 17) {
      // Afternoon
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE3F2FD), AppColors.lightBackground],
      );
    } else if (hour >= 17 && hour < 20) {
      // Evening
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFE0B2), AppColors.lightBackground],
      );
    } else {
      // Night
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A237E), Color(0xFF283593)],
      );
    }
  }
}

class _LogChip extends StatelessWidget {
  final WaterLog log;

  const _LogChip({required this.log});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    
    return SizedBox(
      width: 52,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.hydroEnd.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(log.beverageType.icon, color: AppColors.hydroEnd, size: 14),
          ),
          const SizedBox(height: 1),
          Text(
            '${log.volumeMl}ml',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            timeFormat.format(log.loggedAt),
            style: TextStyle(fontSize: 9, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

class _GoalBreakdownRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? subtitle;
  final bool isTotal;

  const _GoalBreakdownRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.subtitle,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: isTotal
                    ? AppTextStyles.titleMedium().bold
                    : AppTextStyles.bodyMedium(),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTextStyles.labelSmall(color: AppColors.grey500),
                ),
            ],
          ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.titleLarge(color: color).bold
              : AppTextStyles.bodyLarge(color: color).semibold,
        ),
      ],
    );
  }
}

class _WaterProgressPainter extends CustomPainter {
  final double progress;

  _WaterProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.grey200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.hydroStart, AppColors.hydroEnd],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WaterProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
