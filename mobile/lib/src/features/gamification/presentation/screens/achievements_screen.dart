import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thành tựu'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Progress summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.hydroGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '15 / 30',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Thành tựu đã mở',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '50%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Hydration achievements
          _AchievementSection(
            title: '💧 Hydration',
            achievements: [
              _AchievementData('First Drop', 'Log nước lần đầu', true),
              _AchievementData('Century', 'Log 100 lần', true),
              _AchievementData('Thousand Club', 'Log 1000 lần', false),
              _AchievementData('Variety Pack', 'Thử 5 loại đồ uống', true),
            ],
          ),
          const SizedBox(height: 24),
          // Streak achievements
          _AchievementSection(
            title: '🔥 Streak',
            achievements: [
              _AchievementData('Week Warrior', 'Streak 7 ngày', true),
              _AchievementData('Monthly Master', 'Streak 30 ngày', false),
              _AchievementData('Quarterly Champion', 'Streak 90 ngày', false),
              _AchievementData('Year Legend', 'Streak 365 ngày', false),
            ],
          ),
          const SizedBox(height: 24),
          // Challenge achievements
          _AchievementSection(
            title: '🏆 Challenge',
            achievements: [
              _AchievementData('Challenger', 'Hoàn thành 1 challenge', true),
              _AchievementData('Champion', 'Hoàn thành 5 challenge', false),
              _AchievementData('Legend', 'Hoàn thành tất cả', false),
            ],
          ),
          const SizedBox(height: 24),
          // Special achievements
          _AchievementSection(
            title: '⭐ Đặc biệt',
            achievements: [
              _AchievementData('Early Bird', 'Log trước 7h, 7 ngày', true),
              _AchievementData('Night Owl', 'Log sau 22h, 7 ngày', false),
              _AchievementData('Weather Warrior', 'Đạt goal 5 ngày nóng', true),
              _AchievementData('Gym Rat', 'Bù nước sau workout 10 lần', false),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchievementData {
  final String title;
  final String description;
  final bool isUnlocked;

  _AchievementData(this.title, this.description, this.isUnlocked);
}

class _AchievementSection extends StatelessWidget {
  final String title;
  final List<_AchievementData> achievements;

  const _AchievementSection({
    required this.title,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...achievements.map((a) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _AchievementCard(
            title: a.title,
            description: a.description,
            isUnlocked: a.isUnlocked,
          ),
        )),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isUnlocked;

  const _AchievementCard({
    required this.title,
    required this.description,
    required this.isUnlocked,
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppColors.warning.withOpacity(0.2)
                  : AppColors.grey200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnlocked ? Icons.emoji_events : Icons.lock,
              color: isUnlocked ? AppColors.warning : AppColors.grey400,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? AppColors.deepOcean : AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isUnlocked ? AppColors.grey600 : AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
            ),
        ],
      ),
    );
  }
}

