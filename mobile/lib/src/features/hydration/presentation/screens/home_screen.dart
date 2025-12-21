import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../../../../shared/theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual data from providers
    const currentMl = 1250;
    const goalMl = 2500;
    const percentage = currentMl / goalMl;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getBackgroundGradient(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Weather indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.orange, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '32°C',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '+200ml',
                            style: TextStyle(
                              color: AppColors.hydroEnd,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Streak indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '7 ngày',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Main progress area
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Progress Ring with Puru
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Progress ring
                            CustomPaint(
                              size: const Size(280, 280),
                              painter: _WaterProgressPainter(
                                progress: percentage,
                              ),
                            ),
                            // Center content
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Puru placeholder
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.hydroGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.water_drop,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Current value
                                Text(
                                  '$currentMl',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deepOcean,
                                  ),
                                ),
                                Text(
                                  '/ $goalMl ml',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Status message
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [AppColors.cardShadow],
                        ),
                        child: const Text(
                          '🎯 Còn 1,250ml nữa thôi! Cố lên!',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Fact of the day
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [AppColors.cardShadow],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.science.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.lightbulb,
                        color: AppColors.science,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sự thật trong ngày',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.science,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Cơ thể bạn mất khoảng 2.5L nước mỗi ngày qua mồ hôi, hơi thở và tiểu tiện.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Today's logs preview
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [AppColors.cardShadow],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hôm nay',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Xem tất cả'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _LogChip(icon: Icons.water_drop, label: '500ml', time: '8:00'),
                        _LogChip(icon: Icons.coffee, label: '250ml', time: '10:30'),
                        _LogChip(icon: Icons.water_drop, label: '500ml', time: '13:00'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Space for FAB
            ],
          ),
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
  final IconData icon;
  final String label;
  final String time;

  const _LogChip({
    required this.icon,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.hydroEnd.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.hydroEnd),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(time, style: TextStyle(fontSize: 12, color: AppColors.grey500)),
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

