/// Mascot Registry - Single Source of Truth
/// 
/// Đăng ký tất cả mascots của SmartHydro với metadata đầy đủ

import '../models/mascot_models.dart';

/// Mascot Registry - Quản lý tất cả mascots trong app
class MascotRegistry {
  // Private constructor để singleton
  MascotRegistry._();
  
  /// Registry map chứa tất cả mascots
  static final Map<MascotType, MascotInfo> _registry = {
    // Wave 1: Launch Mascots (3 mascots)
    MascotType.aquaAxo: MascotInfo(
      type: MascotType.aquaAxo,
      name: 'Classic Puru',
      nameVi: 'Puru Cổ Điển',
      description: 'The original and beloved SmartHydro mascot',
      descriptionVi: 'Linh vật gốc và được yêu thích nhất của SmartHydro',
      personality: 'Cheerful, Goofy, Caring',
      unlockCondition: const DefaultUnlock(),
      rarity: MascotRarity.common,
      isDefault: true,
      quotes: [
        'Ủa... bạn quên uống nước hả? 🥺',
        'Yayyy! Bạn uống nước rồi! 💧',
        'Mình đang khát nè, bạn cũng vậy không? 🤔',
        'Nước = Sức khỏe = Hạnh phúc! ✨',
      ],
      tags: ['classic', 'cute', 'friendly', 'default'],
    ),
    
    MascotType.celestialDrop: MascotInfo(
      type: MascotType.celestialDrop,
      name: 'Celestial Drop',
      nameVi: 'Giọt Thiên Hà',
      description: 'A water droplet with soft glow and subtle sparkles',
      descriptionVi: 'Giọt nước với ánh sáng mềm mại và lấp lánh tinh tế',
      personality: 'Elegant, Dreamy, Poetic',
      unlockCondition: const StreakUnlock(7),
      rarity: MascotRarity.rare,
      quotes: [
        'Bạn đẹp như dải ngân hà khi uống đủ nước~ ✨',
        'Mỗi giọt nước là một vì sao lấp lánh.',
        'Cơ thể bạn đang tỏa sáng đấy! 🌟',
        'Hãy để ánh sáng dẫn lối cho bạn.',
      ],
      tags: ['elegant', 'magical', 'artistic', 'rare'],
    ),
    
    MascotType.liquidChibiBot: MascotInfo(
      type: MascotType.liquidChibiBot,
      name: 'Liquid Chibi-Bot',
      nameVi: 'Chibi Bot Lỏng',
      description: 'A tech water creature with holographic coating',
      descriptionVi: 'Sinh vật nước công nghệ với lớp phủ holographic',
      personality: 'Smart, Efficient, Tech-savvy',
      unlockCondition: const HealthConnectUnlock(),
      rarity: MascotRarity.epic,
      quotes: [
        'Hydration level: 73%. Optimization suggested. 📊',
        'Đồng bộ dữ liệu sức khỏe thành công! ✅',
        'Phân tích: Bạn cần uống thêm 200ml. 💧',
        'System status: Optimal. Continue. 🤖',
      ],
      tags: ['tech', 'smart', 'premium', 'fitness'],
    ),
    
    // Wave 2: Seasonal & Achievement Mascots
    MascotType.coralGuardian: MascotInfo(
      type: MascotType.coralGuardian,
      name: 'Coral Guardian',
      nameVi: 'Thủ Hộ San Hô',
      description: 'A coral-shaped water being, deeply caring',
      descriptionVi: 'Sinh vật nước hình san hô, quan tâm sâu sắc',
      personality: 'Protective, Caring, Nurturing',
      unlockCondition: const StreakUnlock(30),
      rarity: MascotRarity.rare,
      quotes: [
        'Mỗi giọt nước bạn uống là món quà cho cơ thể! 🎁',
        '30 ngày! Mình tự hào về bạn lắm! 🪸',
        'Hãy để mình chăm sóc bạn nhé.',
        'Cơ thể bạn như một rạn san hô, cần nước để phát triển.',
      ],
      tags: ['caring', 'achievement', 'rare', 'long-term'],
    ),
    
    MascotType.glacierSpirit: MascotInfo(
      type: MascotType.glacierSpirit,
      name: 'Glacier Spirit',
      nameVi: 'Linh Hồn Băng Giá',
      description: 'A crystal ice spirit, calm and serene',
      descriptionVi: 'Linh hồn tinh thể băng, bình tĩnh và thanh tịnh',
      personality: 'Calm, Serene, Meditative',
      unlockCondition: const SeasonalUnlock(
        season: 'Winter',
        startMonth: 12,
        endMonth: 2,
      ),
      rarity: MascotRarity.uncommon,
      quotes: [
        'Nước mát lạnh = tâm hồn trong sáng. ❄️',
        'Hãy bình tĩnh như băng tuyết.',
        'Mùa đông đến rồi, giữ ấm và uống nước nhé! ☃️',
        'Tinh khiết như băng, trong trẻo như nước.',
      ],
      tags: ['seasonal', 'winter', 'calm', 'uncommon'],
    ),
    
    MascotType.lavaDrop: MascotInfo(
      type: MascotType.lavaDrop,
      name: 'Lava Drop',
      nameVi: 'Giọt Dung Nham',
      description: 'A fiery water drop, energetic and passionate',
      descriptionVi: 'Giọt nước như lửa, năng động và nhiệt huyết',
      personality: 'Energetic, Passionate, Intense',
      unlockCondition: EventUnlock(
        eventId: 'summer_2025',
        startDate: DateTime(2025, 6, 1),
        endDate: DateTime(2025, 8, 31),
      ),
      rarity: MascotRarity.epic,
      quotes: [
        'Đốt cháy calories! Nhưng nhớ uống nước nhé! 🔥',
        'Nhiệt huyết như lửa, mát lạnh như nước!',
        'Hè đến rồi! Uống nhiều nước thôi! ☀️',
        'Năng lượng MAX! Let\'s go! 💪',
      ],
      tags: ['seasonal', 'summer', 'energetic', 'event'],
    ),
    
    MascotType.tsunamiTitan: MascotInfo(
      type: MascotType.tsunamiTitan,
      name: 'Tsunami Titan',
      nameVi: 'Titan Sóng Thần',
      description: 'A legendary water titan, powerful and inspiring',
      descriptionVi: 'Titan nước huyền thoại, mạnh mẽ và truyền cảm hứng',
      personality: 'Powerful, Inspiring, Motivating',
      unlockCondition: const StreakUnlock(100),
      rarity: MascotRarity.legendary,
      quotes: [
        'Bạn đã chinh phục đại dương! Nothing can stop you! 🌊',
        '100 ngày! Bạn là huyền thoại! 👑',
        'Sức mạnh của sóng thần ở trong bạn!',
        'Cùng tạo nên những điều kỳ diệu nào! ⚡',
      ],
      tags: ['legendary', 'achievement', 'powerful', '100-streak'],
    ),
    
    // Wave 3: Premium & Special Edition
    MascotType.royalAquamarine: MascotInfo(
      type: MascotType.royalAquamarine,
      name: 'Royal Aquamarine',
      nameVi: 'Ngọc Lam Hoàng Gia',
      description: 'A premium sapphire water drop with diamond crown',
      descriptionVi: 'Giọt nước sapphire cao cấp với vương miện kim cương',
      personality: 'Regal, Exclusive, Sophisticated',
      unlockCondition: const PremiumUnlock(2.99),
      rarity: MascotRarity.legendary,
      quotes: [
        'Bạn xứng đáng với những điều tốt đẹp nhất! 👑',
        'Hoàng gia không bao giờ quên uống nước.',
        'Premium hydration for premium you! 💎',
        'Chất lượng vượt trội, như bạn vậy.',
      ],
      tags: ['premium', 'exclusive', 'iap', 'legendary'],
    ),
    
    MascotType.spookySplash: MascotInfo(
      type: MascotType.spookySplash,
      name: 'Spooky Splash',
      nameVi: 'Giọt Ma Quái',
      description: 'A Halloween water drop with witch hat',
      descriptionVi: 'Giọt nước Halloween với mũ phù thủy',
      personality: 'Playful, Mysterious, Fun',
      unlockCondition: EventUnlock(
        eventId: 'halloween_2025',
        startDate: DateTime(2025, 10, 25),
        endDate: DateTime(2025, 10, 31),
      ),
      rarity: MascotRarity.epic,
      quotes: [
        'Trick or treat! Nhớ uống nước nhé! 🎃',
        'Bùa phép của mình: Uống nước = Khỏe mạnh! 🔮',
        'Halloween vui vẻ! Nhưng đừng quên hydrat hóa! 👻',
        'Ma thuật nước đang hoạt động... ✨',
      ],
      tags: ['event', 'halloween', 'limited', 'seasonal'],
    ),
    
    MascotType.lunarDragon: MascotInfo(
      type: MascotType.lunarDragon,
      name: 'Lunar Dragon Drop',
      nameVi: 'Giọt Rồng Mặt Trăng',
      description: 'A mythic dragon water drop for Lunar New Year',
      descriptionVi: 'Giọt nước rồng huyền thoại cho Tết Nguyên Đán',
      personality: 'Auspicious, Lucky, Festive',
      unlockCondition: EventUnlock(
        eventId: 'tet_2026',
        startDate: DateTime(2026, 1, 20),
        endDate: DateTime(2026, 2, 10),
      ),
      rarity: MascotRarity.mythic,
      quotes: [
        'Chúc mừng năm mới! An khang thịnh vượng! 🐉',
        'Rồng bay, phượng múa, nước uống đầy đủ! 🧧',
        'May mắn sẽ đến khi bạn uống đủ nước! 🍊',
        'Tết vui vẻ! Hydrat hóa tốt! 🎆',
      ],
      tags: ['event', 'tet', 'limited', 'mythic', 'vietnam'],
    ),
  };
  
  /// Get mascot info by type
  static MascotInfo getInfo(MascotType type) {
    final info = _registry[type];
    if (info == null) {
      throw Exception('Mascot type $type not found in registry');
    }
    return info;
  }
  
  /// Get all mascots
  static List<MascotInfo> getAllMascots() {
    return _registry.values.toList();
  }
  
  /// Get mascots by rarity
  static List<MascotInfo> getMascotsByRarity(MascotRarity rarity) {
    return _registry.values
        .where((m) => m.rarity == rarity)
        .toList();
  }
  
  /// Get unlocked mascots
  static List<MascotInfo> getUnlockedMascots(List<MascotType> unlockedTypes) {
    return unlockedTypes
        .map((type) => _registry[type])
        .whereType<MascotInfo>()
        .toList();
  }
  
  /// Get locked mascots
  static List<MascotInfo> getLockedMascots(List<MascotType> unlockedTypes) {
    return _registry.values
        .where((m) => !unlockedTypes.contains(m.type))
        .toList();
  }
  
  /// Get default mascot
  static MascotInfo getDefaultMascot() {
    return _registry.values.firstWhere(
      (m) => m.isDefault,
      orElse: () => _registry[MascotType.aquaAxo]!,
    );
  }
  
  /// Get seasonal mascots currently available
  static List<MascotInfo> getSeasonalMascots() {
    return _registry.values.where((m) {
      final condition = m.unlockCondition;
      if (condition is SeasonalUnlock) {
        return condition.isCurrentlyAvailable();
      }
      return false;
    }).toList();
  }
  
  /// Get event mascots currently active
  static List<MascotInfo> getEventMascots() {
    return _registry.values.where((m) {
      final condition = m.unlockCondition;
      if (condition is EventUnlock) {
        return condition.isEventActive();
      }
      return false;
    }).toList();
  }
  
  /// Check if a mascot type exists
  static bool exists(MascotType type) {
    return _registry.containsKey(type);
  }
  
  /// Get total mascot count
  static int get totalCount => _registry.length;
  
  /// Search mascots by name or tag
  static List<MascotInfo> search(String query) {
    final lowerQuery = query.toLowerCase();
    return _registry.values.where((m) {
      return m.name.toLowerCase().contains(lowerQuery) ||
          m.nameVi.toLowerCase().contains(lowerQuery) ||
          m.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}

