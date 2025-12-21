import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly summary card
            _SummaryCard(
              title: 'Tuần này',
              value: '85%',
              subtitle: 'Đạt mục tiêu',
              icon: Icons.trending_up,
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            // Weekly chart placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [AppColors.cardShadow],
              ),
              child: const Center(
                child: Text(
                  '📊 Biểu đồ tuần\n(fl_chart)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey500),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Beverage breakdown
            const Text(
              'Phân loại đồ uống',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [AppColors.cardShadow],
              ),
              child: const Center(
                child: Text(
                  '🥧 Pie Chart\nNước 70% | Cà phê 20% | Trà 10%',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey500),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Streak calendar
            const Text(
              'Lịch streak',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [AppColors.cardShadow],
              ),
              child: const Center(
                child: Text(
                  '📅 Streak Calendar Heatmap\n(GitHub-style)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey500),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Insights
            const Text(
              'Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _InsightCard(
              icon: Icons.trending_up,
              title: 'Tuần này tốt hơn tuần trước 15%!',
              color: AppColors.success,
            ),
            const SizedBox(height: 12),
            _InsightCard(
              icon: Icons.coffee,
              title: 'Bạn uống ít cà phê hơn 20%',
              color: AppColors.hydroEnd,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: AppColors.grey600),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _InsightCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
        ],
      ),
    );
  }
}

