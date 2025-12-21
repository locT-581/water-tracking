import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';

class BuddyScreen extends ConsumerWidget {
  const BuddyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puru của tôi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Current Puru display
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: AppColors.hydroGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  // Puru placeholder
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      size: 80,
                      color: AppColors.hydroEnd,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Puru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '🎨 Basic Skin',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stats
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department,
                    value: '7',
                    label: 'Ngày streak',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.star,
                    value: '850',
                    label: 'Điểm',
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Skins collection
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bộ sưu tập Skin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final isUnlocked = index < 3;
                final isEquipped = index == 0;
                return _SkinCard(
                  name: _skinNames[index],
                  isUnlocked: isUnlocked,
                  isEquipped: isEquipped,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

const _skinNames = [
  'Basic',
  'Ocean Breeze',
  'Tropical',
  'Diamond',
  'Ninja',
  'Astronaut',
  'Golden',
  'Rainbow',
  'Night Sky',
];

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class _SkinCard extends StatelessWidget {
  final String name;
  final bool isUnlocked;
  final bool isEquipped;

  const _SkinCard({
    required this.name,
    required this.isUnlocked,
    required this.isEquipped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isEquipped
            ? Border.all(color: AppColors.hydroEnd, width: 2)
            : null,
        boxShadow: [AppColors.cardShadow],
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.water_drop,
                  size: 40,
                  color: isUnlocked ? AppColors.hydroEnd : AppColors.grey300,
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnlocked ? AppColors.deepOcean : AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          if (!isUnlocked)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.lock, color: Colors.white),
              ),
            ),
          if (isEquipped)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.hydroEnd,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

