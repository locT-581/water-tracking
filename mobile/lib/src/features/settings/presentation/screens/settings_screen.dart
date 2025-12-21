import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../app/router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [AppColors.cardShadow],
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.hydroGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Người dùng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'user@email.com',
                        style: TextStyle(color: AppColors.grey600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Settings sections
          _SettingsSection(
            title: 'Cá nhân hóa',
            items: [
              _SettingsItem(
                icon: Icons.water_drop,
                title: 'Mục tiêu nước',
                subtitle: '2,500 ml/ngày',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.schedule,
                title: 'Giờ sinh hoạt',
                subtitle: '7:00 - 23:00',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.notifications,
                title: 'Nhắc nhở',
                subtitle: 'Đang bật',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Gamification',
            items: [
              _SettingsItem(
                icon: Icons.pets,
                title: 'Puru của tôi',
                subtitle: 'Xem và đổi skin',
                onTap: () => context.push(AppRoutes.buddy),
              ),
              _SettingsItem(
                icon: Icons.emoji_events,
                title: 'Thử thách',
                subtitle: '2 đang tiến hành',
                onTap: () => context.push(AppRoutes.challenges),
              ),
              _SettingsItem(
                icon: Icons.workspace_premium,
                title: 'Thành tựu',
                subtitle: '15/30 đã mở',
                onTap: () => context.push(AppRoutes.achievements),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Ứng dụng',
            items: [
              _SettingsItem(
                icon: Icons.language,
                title: 'Ngôn ngữ',
                subtitle: 'Tiếng Việt',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.dark_mode,
                title: 'Giao diện',
                subtitle: 'Theo hệ thống',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.download,
                title: 'Xuất dữ liệu',
                subtitle: 'PDF Report',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Khác',
            items: [
              _SettingsItem(
                icon: Icons.help,
                title: 'Trợ giúp & FAQ',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.privacy_tip,
                title: 'Chính sách bảo mật',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.info,
                title: 'Về SmartHydro',
                subtitle: 'v1.0.0',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Logout button
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement logout
              context.go(AppRoutes.login);
            },
            icon: const Icon(Icons.logout, color: AppColors.danger),
            label: const Text('Đăng xuất'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.grey600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [AppColors.cardShadow],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: AppColors.grey200,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.hydroEnd.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.hydroEnd, size: 20),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey400),
      onTap: onTap,
    );
  }
}

