import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thử thách'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active challenges
          const Text(
            'Đang tham gia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _ChallengeCard(
            title: 'Detox Challenge',
            description: 'Uống đủ 100% mỗi ngày trong 7 ngày',
            progress: 5,
            total: 7,
            reward: 'Badge "Detox Master"',
            isActive: true,
          ),
          const SizedBox(height: 12),
          _ChallengeCard(
            title: 'Morning Starter',
            description: 'Uống 500ml trước 10h sáng trong 7 ngày',
            progress: 3,
            total: 7,
            reward: 'Badge "Early Bird"',
            isActive: true,
          ),
          const SizedBox(height: 24),
          // Available challenges
          const Text(
            'Có thể tham gia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _ChallengeCard(
            title: 'Summer Hydration',
            description: 'Uống đủ nước trong 14 ngày mùa hè',
            progress: 0,
            total: 14,
            reward: 'Skin "Sunny Buddy"',
            isActive: false,
          ),
          const SizedBox(height: 12),
          _ChallengeCard(
            title: 'Consistency King',
            description: 'Duy trì streak 30 ngày liên tục',
            progress: 0,
            total: 30,
            reward: 'Buddy "Golden Puru"',
            isActive: false,
          ),
          const SizedBox(height: 12),
          _ChallengeCard(
            title: 'Coffee Cutter',
            description: 'Tối đa 1 ly cà phê/ngày trong 7 ngày',
            progress: 0,
            total: 7,
            reward: 'Badge "Tea Lover"',
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final int progress;
  final int total;
  final String reward;
  final bool isActive;

  const _ChallengeCard({
    required this.title,
    required this.description,
    required this.progress,
    required this.total,
    required this.reward,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = progress / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? Border.all(color: AppColors.hydroEnd, width: 2)
            : null,
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.hydroEnd.withOpacity(0.1)
                      : AppColors.grey200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: isActive ? AppColors.hydroEnd : AppColors.grey500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 16),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressPercent,
                backgroundColor: AppColors.grey200,
                valueColor: const AlwaysStoppedAnimation(AppColors.hydroEnd),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$progress / $total ngày',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.hydroEnd,
                  ),
                ),
                Text(
                  '${(progressPercent * 100).toInt()}%',
                  style: TextStyle(color: AppColors.grey600),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          // Reward
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.card_giftcard, size: 16, color: AppColors.warning),
                const SizedBox(width: 8),
                Text(
                  reward,
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (!isActive) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Tham gia'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

