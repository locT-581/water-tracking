import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';

class ScienceHubScreen extends ConsumerWidget {
  const ScienceHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Science Hub'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _CategoryChip(label: 'Tất cả', isSelected: true),
                _CategoryChip(label: '💧 Cơ bản'),
                _CategoryChip(label: '🥗 Dinh dưỡng'),
                _CategoryChip(label: '⚖️ Giảm cân'),
                _CategoryChip(label: '🏃 Thể thao'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Articles grid
          ...List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ArticleCard(
                title: _sampleTitles[index % _sampleTitles.length],
                summary: 'Tìm hiểu về cách hydration ảnh hưởng đến sức khỏe của bạn...',
                category: _sampleCategories[index % _sampleCategories.length],
                readTime: '${3 + index} phút',
                imageUrl: null,
                onTap: () => context.push('/science/$index'),
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

const _sampleTitles = [
  'Tại sao màu nước tiểu quan trọng?',
  '5 dấu hiệu cơ thể đang thiếu nước',
  'Uống nước đúng cách khi tập gym',
  'Cà phê có thực sự gây mất nước?',
  'Nước dừa vs nước lọc: Loại nào tốt hơn?',
];

const _sampleCategories = [
  '💧 Cơ bản',
  '🥗 Dinh dưỡng',
  '🏃 Thể thao',
  '💧 Cơ bản',
  '🥗 Dinh dưỡng',
];

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _CategoryChip({
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {},
        selectedColor: AppColors.hydroEnd.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.hydroEnd : AppColors.grey700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final String title;
  final String summary;
  final String category;
  final String readTime;
  final String? imageUrl;
  final VoidCallback onTap;

  const _ArticleCard({
    required this.title,
    required this.summary,
    required this.category,
    required this.readTime,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [AppColors.cardShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.science.withOpacity(0.3),
                    AppColors.hydroEnd.withOpacity(0.3),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.article,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.science.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.science,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.access_time, size: 14, color: AppColors.grey500),
                      const SizedBox(width: 4),
                      Text(
                        readTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.grey600,
                      height: 1.5,
                    ),
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

