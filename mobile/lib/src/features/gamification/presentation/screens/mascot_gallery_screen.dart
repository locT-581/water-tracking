/// Mascot Gallery Screen
/// 
/// Màn hình hiển thị collection của mascots, cho phép user:
/// - Xem tất cả mascots (unlocked & locked)
/// - Chọn mascot để sử dụng
/// - Xem điều kiện unlock
/// - Filter và sort

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/mascot_models.dart';
import '../../domain/services/mascot_factory.dart';
import '../providers/mascot_providers.dart';

class MascotGalleryScreen extends ConsumerStatefulWidget {
  const MascotGalleryScreen({super.key});

  @override
  ConsumerState<MascotGalleryScreen> createState() => _MascotGalleryScreenState();
}

class _MascotGalleryScreenState extends ConsumerState<MascotGalleryScreen> {
  @override
  Widget build(BuildContext context) {
    final activeMascot = ref.watch(activeMascotProvider);
    final sortedMascots = ref.watch(sortedMascotsProvider);
    final unlockedMascots = ref.watch(unlockedMascotsProvider);
    final hydrationPercent = ref.watch(hydrationPercentProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF001220),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Bộ Sưu Tập Linh Vật',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          _buildFilterButton(),
          _buildSortButton(),
        ],
      ),
      body: Column(
        children: [
          // Current active mascot
          _buildActiveMascotCard(activeMascot, hydrationPercent),
          
          const SizedBox(height: 16),
          
          // Gallery grid
          Expanded(
            child: _buildMascotGrid(
              sortedMascots,
              unlockedMascots,
              activeMascot,
              hydrationPercent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveMascotCard(MascotType activeMascot, double hydrationPercent) {
    final info = ref.watch(mascotInfoProvider(activeMascot));
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF009EFD).withOpacity(0.2),
            const Color(0xFF2AF598).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF2AF598),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Mascot preview
          SizedBox(
            width: 100,
            height: 100,
            child: MascotWidget(
              type: activeMascot,
              size: 100,
              hydrationPercent: hydrationPercent,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '✨ ĐANG SỬ DỤNG',
                      style: TextStyle(
                        color: const Color(0xFF2AF598),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  info.localizedName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info.personality,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: info.rarity.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: info.rarity.color,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    info.rarity.label,
                    style: TextStyle(
                      color: info.rarity.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascotGrid(
    List<MascotInfo> mascots,
    List<MascotType> unlockedMascots,
    MascotType activeMascot,
    double hydrationPercent,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: mascots.length,
      itemBuilder: (context, index) {
        final info = mascots[index];
        final isUnlocked = unlockedMascots.contains(info.type);
        final isActive = info.type == activeMascot;
        
        return _buildMascotCard(
          info,
          isUnlocked,
          isActive,
          hydrationPercent,
        );
      },
    );
  }

  Widget _buildMascotCard(
    MascotInfo info,
    bool isUnlocked,
    bool isActive,
    double hydrationPercent,
  ) {
    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          _showMascotDetail(info);
        } else {
          _showUnlockInfo(info);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF009EFD).withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? const Color(0xFF2AF598)
                : Colors.white.withOpacity(0.1),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mascot preview or silhouette
            if (isUnlocked)
              SizedBox(
                width: 120,
                height: 120,
                child: MascotWidget(
                  type: info.type,
                  size: 120,
                  hydrationPercent: hydrationPercent,
                ),
              )
            else
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock,
                  color: Colors.white30,
                  size: 40,
                ),
              ),
            
            const SizedBox(height: 12),
            
            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                info.localizedName,
                style: TextStyle(
                  color: isUnlocked ? Colors.white : Colors.white.withOpacity(0.4),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Rarity badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: info.rarity.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                info.rarity.label,
                style: TextStyle(
                  color: info.rarity.color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Status indicator
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2AF598),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '✓ Đang dùng',
                  style: TextStyle(
                    color: Color(0xFF051E3E),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else if (!isUnlocked)
              Text(
                _getUnlockText(info.unlockCondition),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  String _getUnlockText(UnlockCondition condition) {
    return switch (condition) {
      StreakUnlock(days: final days) => '$days ngày streak',
      HealthConnectUnlock() => 'Kết nối Health',
      PremiumUnlock(price: final price) => '\$$price',
      SeasonalUnlock() => 'Theo mùa',
      EventUnlock() => 'Event',
      _ => 'Đã mở khóa',
    };
  }

  void _showMascotDetail(MascotInfo info) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MascotDetailSheet(info: info),
    );
  }

  void _showUnlockInfo(MascotInfo info) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF001220),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: Color(0xFF2AF598),
            width: 2,
          ),
        ),
        title: Text(
          '🔒 ${info.localizedName}',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'Điều kiện mở khóa:\n${_getUnlockDescription(info.unlockCondition)}',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  String _getUnlockDescription(UnlockCondition condition) {
    return switch (condition) {
      StreakUnlock(days: final days) => 'Đạt $days ngày streak liên tục',
      HealthConnectUnlock() => 'Kết nối Apple Health hoặc Google Fit',
      PremiumUnlock(price: final price) => 'Mua premium với giá \$$price',
      SeasonalUnlock(season: final season) => 'Có sẵn trong mùa $season',
      EventUnlock() => 'Có sẵn trong event đặc biệt',
      _ => 'Đã mở khóa',
    };
  }

  Widget _buildFilterButton() {
    return PopupMenuButton<MascotFilter>(
      icon: const Icon(Icons.filter_list, color: Colors.white),
      onSelected: (filter) {
        ref.read(mascotFilterProvider.notifier).state = filter;
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: MascotFilter.all,
          child: Text('Tất cả'),
        ),
        const PopupMenuItem(
          value: MascotFilter.unlocked,
          child: Text('Đã mở khóa'),
        ),
        const PopupMenuItem(
          value: MascotFilter.locked,
          child: Text('Chưa mở khóa'),
        ),
        const PopupMenuItem(
          value: MascotFilter.seasonal,
          child: Text('Theo mùa'),
        ),
        const PopupMenuItem(
          value: MascotFilter.premium,
          child: Text('Premium'),
        ),
      ],
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<MascotSort>(
      icon: const Icon(Icons.sort, color: Colors.white),
      onSelected: (sort) {
        ref.read(mascotSortProvider.notifier).state = sort;
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: MascotSort.rarity,
          child: Text('Độ hiếm'),
        ),
        const PopupMenuItem(
          value: MascotSort.name,
          child: Text('Tên'),
        ),
        const PopupMenuItem(
          value: MascotSort.unlockDate,
          child: Text('Ngày mở khóa'),
        ),
      ],
    );
  }
}

/// Mascot detail bottom sheet
class _MascotDetailSheet extends ConsumerWidget {
  final MascotInfo info;
  
  const _MascotDetailSheet({required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeMascot = ref.watch(activeMascotProvider);
    final isActive = info.type == activeMascot;
    final hydrationPercent = ref.watch(hydrationPercentProvider);
    
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF001220),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Color(0xFF2AF598), width: 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Large preview
          SizedBox(
            width: 200,
            height: 200,
            child: MascotWidget(
              type: info.type,
              size: 200,
              hydrationPercent: hydrationPercent,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Name and rarity
          Text(
            info.localizedName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: info.rarity.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: info.rarity.color),
            ),
            child: Text(
              '⭐ ${info.rarity.label}',
              style: TextStyle(
                color: info.rarity.color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              info.localizedDescription,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Personality
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '💫 ${info.personality}',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action button
          if (!isActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  ref.read(activeMascotProvider.notifier).setActiveMascot(info.type);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã chọn ${info.localizedName}!'),
                      backgroundColor: const Color(0xFF2AF598),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2AF598),
                  foregroundColor: const Color(0xFF051E3E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Sử dụng linh vật này',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

