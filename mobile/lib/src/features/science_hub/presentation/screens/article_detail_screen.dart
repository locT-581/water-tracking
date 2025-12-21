import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final String articleId;

  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.science.withOpacity(0.8),
                      AppColors.hydroEnd.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ],
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & read time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.science.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '💧 Kiến thức cơ bản',
                          style: TextStyle(
                            color: AppColors.science,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time, size: 16, color: AppColors.grey500),
                      const SizedBox(width: 4),
                      Text(
                        '5 phút đọc',
                        style: TextStyle(color: AppColors.grey500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Title
                  const Text(
                    'Tại sao màu nước tiểu quan trọng?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Content
                  const Text(
                    'Màu sắc nước tiểu là một trong những chỉ số đơn giản nhất để đánh giá tình trạng hydration của cơ thể.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '''Khi cơ thể được cung cấp đủ nước, nước tiểu thường có màu vàng nhạt như rơm hoặc gần như trong suốt. Đây là dấu hiệu cho thấy thận đang hoạt động tốt và cơ thể được hydrat hóa đầy đủ.

Ngược lại, khi nước tiểu có màu vàng đậm hoặc màu hổ phách, đây có thể là dấu hiệu cơ thể đang thiếu nước. Trong trường hợp này, thận phải cô đặc nước tiểu để giữ lại nước cho cơ thể.

Một số yếu tố khác cũng có thể ảnh hưởng đến màu nước tiểu:
• Thực phẩm: Củ cải đường, cà rốt có thể làm đổi màu
• Thuốc: Một số loại vitamin B làm nước tiểu có màu vàng neon
• Bệnh lý: Nhiễm trùng, bệnh gan có thể gây thay đổi màu sắc bất thường''',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Highlight box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb, color: AppColors.warning),
                            SizedBox(width: 8),
                            Text(
                              'Mẹo hay',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Kiểm tra màu nước tiểu vào buổi sáng khi thức dậy để có đánh giá chính xác nhất về tình trạng hydration.',
                          style: TextStyle(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Sources
                  const Text(
                    'Nguồn tham khảo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• American Journal of Clinical Nutrition, 2016\n• Mayo Clinic - Urine color and health',
                    style: TextStyle(
                      color: AppColors.grey600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

