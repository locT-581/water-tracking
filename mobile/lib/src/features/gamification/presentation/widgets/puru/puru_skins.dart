import 'package:flutter/material.dart';

/// Available skins/themes for Puru
enum PuruSkinType {
  /// Default blue water blob
  classic,
  
  /// Orange/coral summer theme
  summer,
  
  /// Light blue winter/snow theme
  winter,
  
  /// Green nature/forest theme
  forest,
  
  /// Purple galaxy/cosmic theme
  galaxy,
  
  /// Pink cherry blossom theme
  sakura,
  
  /// Gold/premium theme
  golden,
  
  /// Rainbow gradient theme
  rainbow,
  
  /// Dark mode/midnight theme
  midnight,
  
  /// Crystal/gem theme
  crystal,
}

/// Skin configuration for Puru
class PuruSkin {
  final PuruSkinType type;
  final String nameVi;
  final String nameEn;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color glowColor;
  final Color highlightColor;
  final bool hasSpecialEffect;
  final int unlockStreakDays;
  final bool isPremium;
  
  const PuruSkin({
    required this.type,
    required this.nameVi,
    required this.nameEn,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.glowColor,
    required this.highlightColor,
    this.hasSpecialEffect = false,
    this.unlockStreakDays = 0,
    this.isPremium = false,
  });
  
  /// Get gradient colors for body
  List<Color> get bodyGradient => [
    _lightenColor(primaryColor, 0.2),
    primaryColor,
    _darkenColor(primaryColor, 0.1),
  ];
  
  Color _lightenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red + (255 - color.red) * amount).round().clamp(0, 255),
      (color.green + (255 - color.green) * amount).round().clamp(0, 255),
      (color.blue + (255 - color.blue) * amount).round().clamp(0, 255),
    );
  }
  
  Color _darkenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - amount)).round().clamp(0, 255),
      (color.green * (1 - amount)).round().clamp(0, 255),
      (color.blue * (1 - amount)).round().clamp(0, 255),
    );
  }
}

/// All available Puru skins
class PuruSkins {
  PuruSkins._();
  
  static const classic = PuruSkin(
    type: PuruSkinType.classic,
    nameVi: 'Cổ điển',
    nameEn: 'Classic',
    description: 'Puru nguyên bản với màu xanh nước biển',
    primaryColor: Color(0xFF4FC3F7),
    secondaryColor: Color(0xFF2AF598),
    glowColor: Color(0x992AF598),
    highlightColor: Color(0xCCFFFFFF),
    unlockStreakDays: 0,
  );
  
  static const summer = PuruSkin(
    type: PuruSkinType.summer,
    nameVi: 'Mùa hè',
    nameEn: 'Summer',
    description: 'Puru màu cam rực rỡ như mặt trời',
    primaryColor: Color(0xFFFF8A65),
    secondaryColor: Color(0xFFFFD54F),
    glowColor: Color(0x99FFD54F),
    highlightColor: Color(0xCCFFFFFF),
    hasSpecialEffect: true,
    unlockStreakDays: 7,
  );
  
  static const winter = PuruSkin(
    type: PuruSkinType.winter,
    nameVi: 'Mùa đông',
    nameEn: 'Winter',
    description: 'Puru băng giá lấp lánh',
    primaryColor: Color(0xFFB3E5FC),
    secondaryColor: Color(0xFFE1F5FE),
    glowColor: Color(0x99E1F5FE),
    highlightColor: Color(0xFFFFFFFF),
    hasSpecialEffect: true,
    unlockStreakDays: 14,
  );
  
  static const forest = PuruSkin(
    type: PuruSkinType.forest,
    nameVi: 'Rừng xanh',
    nameEn: 'Forest',
    description: 'Puru màu lá cây thiên nhiên',
    primaryColor: Color(0xFF81C784),
    secondaryColor: Color(0xFFA5D6A7),
    glowColor: Color(0x99A5D6A7),
    highlightColor: Color(0xCCFFFFFF),
    unlockStreakDays: 21,
  );
  
  static const galaxy = PuruSkin(
    type: PuruSkinType.galaxy,
    nameVi: 'Ngân hà',
    nameEn: 'Galaxy',
    description: 'Puru vũ trụ với ánh sao lấp lánh',
    primaryColor: Color(0xFF7C4DFF),
    secondaryColor: Color(0xFFB388FF),
    glowColor: Color(0x99B388FF),
    highlightColor: Color(0xCCFFFFFF),
    hasSpecialEffect: true,
    unlockStreakDays: 30,
  );
  
  static const sakura = PuruSkin(
    type: PuruSkinType.sakura,
    nameVi: 'Hoa anh đào',
    nameEn: 'Sakura',
    description: 'Puru hồng dịu dàng như hoa xuân',
    primaryColor: Color(0xFFF48FB1),
    secondaryColor: Color(0xFFF8BBD9),
    glowColor: Color(0x99F8BBD9),
    highlightColor: Color(0xFFFFFFFF),
    hasSpecialEffect: true,
    unlockStreakDays: 45,
  );
  
  static const golden = PuruSkin(
    type: PuruSkinType.golden,
    nameVi: 'Hoàng kim',
    nameEn: 'Golden',
    description: 'Puru vàng rực rỡ cho champion',
    primaryColor: Color(0xFFFFD700),
    secondaryColor: Color(0xFFFFF176),
    glowColor: Color(0x99FFD700),
    highlightColor: Color(0xFFFFFFFF),
    hasSpecialEffect: true,
    unlockStreakDays: 60,
  );
  
  static const rainbow = PuruSkin(
    type: PuruSkinType.rainbow,
    nameVi: 'Cầu vồng',
    nameEn: 'Rainbow',
    description: 'Puru đổi màu liên tục như cầu vồng',
    primaryColor: Color(0xFFFF5252),
    secondaryColor: Color(0xFF448AFF),
    glowColor: Color(0x99FFFFFF),
    highlightColor: Color(0xFFFFFFFF),
    hasSpecialEffect: true,
    unlockStreakDays: 90,
  );
  
  static const midnight = PuruSkin(
    type: PuruSkinType.midnight,
    nameVi: 'Nửa đêm',
    nameEn: 'Midnight',
    description: 'Puru tối màu bí ẩn với ánh neon',
    primaryColor: Color(0xFF37474F),
    secondaryColor: Color(0xFF00E5FF),
    glowColor: Color(0x9900E5FF),
    highlightColor: Color(0xCC00E5FF),
    hasSpecialEffect: true,
    unlockStreakDays: 100,
  );
  
  static const crystal = PuruSkin(
    type: PuruSkinType.crystal,
    nameVi: 'Pha lê',
    nameEn: 'Crystal',
    description: 'Puru trong suốt như pha lê quý hiếm',
    primaryColor: Color(0xFFE0E0E0),
    secondaryColor: Color(0xFFFFFFFF),
    glowColor: Color(0x66FFFFFF),
    highlightColor: Color(0xFFFFFFFF),
    hasSpecialEffect: true,
    isPremium: true,
    unlockStreakDays: 0, // Premium only
  );
  
  /// Get all skins
  static List<PuruSkin> get all => [
    classic,
    summer,
    winter,
    forest,
    galaxy,
    sakura,
    golden,
    rainbow,
    midnight,
    crystal,
  ];
  
  /// Get skin by type
  static PuruSkin getSkin(PuruSkinType type) {
    return all.firstWhere(
      (skin) => skin.type == type,
      orElse: () => classic,
    );
  }
  
  /// Get unlockable skins for given streak days
  static List<PuruSkin> getUnlockedSkins(int streakDays, {bool hasPremium = false}) {
    return all.where((skin) {
      if (skin.isPremium && !hasPremium) return false;
      return skin.unlockStreakDays <= streakDays;
    }).toList();
  }
  
  /// Get next skin to unlock
  static PuruSkin? getNextUnlockableSkin(int streakDays) {
    final locked = all.where((skin) => 
      !skin.isPremium && skin.unlockStreakDays > streakDays
    ).toList();
    
    if (locked.isEmpty) return null;
    
    locked.sort((a, b) => a.unlockStreakDays.compareTo(b.unlockStreakDays));
    return locked.first;
  }
}

/// Widget to display a skin preview
class PuruSkinPreview extends StatelessWidget {
  final PuruSkin skin;
  final bool isUnlocked;
  final bool isSelected;
  final VoidCallback? onTap;
  
  const PuruSkinPreview({
    super.key,
    required this.skin,
    this.isUnlocked = true,
    this.isSelected = false,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? skin.primaryColor.withOpacity(0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? skin.primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: skin.glowColor,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ] : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color preview circle
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: skin.bodyGradient,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: skin.glowColor,
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                if (!isUnlocked)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Name
            Text(
              skin.nameVi,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isUnlocked 
                    ? const Color(0xFF051E3E)
                    : Colors.grey,
              ),
            ),
            
            // Unlock requirement
            if (!isUnlocked)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  skin.isPremium 
                      ? 'Premium'
                      : '${skin.unlockStreakDays} ngày',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            
            // Special effect indicator
            if (skin.hasSpecialEffect && isUnlocked)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.auto_awesome,
                      size: 12,
                      color: Color(0xFFFFD700),
                    ),
                    SizedBox(width: 2),
                    Text(
                      'Đặc biệt',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFFFFD700),
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

