# 🎭 SMARTHYDRO MASCOT SYSTEM DESIGN

**Version:** 2.0  
**Ngày:** 22/12/2025  
**Mục đích:** Hệ thống mascot có khả năng mở rộng, cho phép user chọn và thay đổi mascot theo ý thích.

---

## 1. TỔNG QUAN HỆ THỐNG

### 1.1. Concept Core

SmartHydro không chỉ có **1 mascot duy nhất**, mà là một **"Water Creature Universe"** với nhiều sinh vật nước khác nhau, mỗi con có:
- Tính cách riêng biệt
- Animation style độc đáo
- Câu nói/reactions khác nhau
- Điều kiện unlock đặc biệt

### 1.2. Lợi ích chiến lược

| Aspect | Benefit |
|--------|---------|
| **User Engagement** | User quay lại app để "thăm" mascot yêu thích |
| **Gamification** | Streak/Challenge → Unlock mascot mới |
| **Personalization** | Mỗi user cảm thấy app "của riêng mình" |
| **Content Updates** | Thêm mascot mới mỗi mùa/event |
| **Monetization** | Premium mascots, limited edition |
| **Social Sharing** | User chia sẻ mascot độc trên social |

---

## 2. KIẾN TRÚC HỆ THỐNG

### 2.1. Mascot Registry Pattern

```dart
// Enum định nghĩa tất cả mascots
enum MascotType {
  celestialDrop,     // Option 1
  aquaAxo,           // Option 2
  liquidChibiBot,    // Option 3
  
  // Future mascots
  coralGuardian,     // Unlock at 30-day streak
  glacierSpirit,     // Unlock in winter
  steamPunk,         // Premium mascot
  // ... có thể thêm vô hạn
}

// Mascot Metadata
class MascotInfo {
  final MascotType type;
  final String name;
  final String description;
  final String personality;
  final UnlockCondition unlockCondition;
  final MascotRarity rarity;
  final List<String> tags;
  
  // Factory để tạo Painter tương ứng
  CustomPainter createPainter({...});
}
```

### 2.2. Unlock System

```dart
enum UnlockCondition {
  default_,              // Có sẵn từ đầu
  streak(days: 7),      // Đạt X ngày streak
  challenge(id: 'xyz'), // Hoàn thành challenge
  seasonal(season: 'summer'), // Theo mùa
  premium,              // Mua IAP
  event(eventId: 'tet2025'), // Event đặc biệt
}

enum MascotRarity {
  common,    // Màu xám
  uncommon,  // Màu xanh lá
  rare,      // Màu xanh dương
  epic,      // Màu tím
  legendary, // Màu vàng
  mythic,    // Màu đỏ gradient
}
```

### 2.3. Database Schema

```sql
-- Supabase: Bảng theo dõi mascots của user
CREATE TABLE user_mascots (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  mascot_type TEXT NOT NULL,
  unlocked_at TIMESTAMP DEFAULT NOW(),
  is_favorite BOOLEAN DEFAULT false,
  usage_count INT DEFAULT 0,
  last_used_at TIMESTAMP,
  
  UNIQUE(user_id, mascot_type)
);

-- Bảng mascot đang dùng
ALTER TABLE users ADD COLUMN active_mascot TEXT DEFAULT 'aquaAxo';

-- Index
CREATE INDEX idx_user_mascots_user ON user_mascots(user_id);
CREATE INDEX idx_user_mascots_unlocked ON user_mascots(user_id, unlocked_at);
```

---

## 3. MASCOT ROSTER (LINE-UP)

### 3.1. Wave 1 - Launch Mascots (3 mascots)

#### 🌟 Celestial Drop
- **Rarity:** Rare
- **Unlock:** 7-day streak
- **Personality:** Sang trọng, mơ mộng, thích thơ
- **Quote:** "Bạn đẹp như dải ngân hà khi uống đủ nước~"
- **Best for:** Users thích aesthetic, nghệ thuật

#### 🦎 Aqua-Axo (DEFAULT)
- **Rarity:** Common
- **Unlock:** Default (có sẵn)
- **Personality:** Vui vẻ, hài hước, hơi ngố
- **Quote:** "Ủa... bạn quên uống nước hả? 🥺"
- **Best for:** Mọi user, dễ thương nhất

#### 💎 Liquid Chibi-Bot
- **Rarity:** Epic
- **Unlock:** Connect Apple Health/Google Fit
- **Personality:** Thông minh, tech-savvy, hiệu quả
- **Quote:** "Hydration level: 73%. Optimization suggested."
- **Best for:** Users yêu công nghệ, fitness

---

### 3.2. Wave 2 - Seasonal & Achievement Mascots

#### 🪸 Coral Guardian
- **Rarity:** Rare
- **Unlock:** 30-day streak
- **Design:** Hình san hô sống, có nhiều xúc tu, màu hồng-cam
- **Personality:** Bảo vệ, quan tâm sâu sắc
- **Quote:** "Mỗi giọt nước bạn uống là món quà cho cơ thể!"

#### ❄️ Glacier Spirit
- **Rarity:** Uncommon
- **Unlock:** Seasonal (Dec-Feb)
- **Design:** Tinh thể băng trong suốt, lấp lánh
- **Personality:** Bình tĩnh, thanh tịnh
- **Quote:** "Nước mát lạnh = tâm hồn trong sáng."

#### 🔥 Lava Drop
- **Rarity:** Epic
- **Unlock:** Summer Event (Jun-Aug) + Drink 3L/day for 7 days
- **Design:** Giọt nước màu đỏ cam, có hiệu ứng lửa
- **Personality:** Nhiệt huyết, năng động
- **Quote:** "Đốt cháy calories! Nhưng nhớ uống nước nhé! 🔥"

#### 🌊 Tsunami Titan
- **Rarity:** Legendary
- **Unlock:** 100-day streak
- **Design:** Giọt nước khổng lồ với sóng thần bên trong
- **Personality:** Mạnh mẽ, truyền cảm hứng
- **Quote:** "Bạn đã chinh phục đại dương! Nothing can stop you!"

---

### 3.3. Wave 3 - Premium & Special Edition

#### 👑 Royal Aquamarine
- **Rarity:** Legendary
- **Unlock:** Premium IAP ($2.99)
- **Design:** Màu xanh sapphire, đeo vương miện kim cương
- **Exclusive:** Có exclusive animations + voice lines

#### 🎃 Spooky Splash (Halloween)
- **Rarity:** Epic
- **Unlock:** Halloween Event (Oct 25-31)
- **Design:** Màu cam-tím, có mũ phù thủy
- **Limited:** Chỉ unlock được trong event

#### 🐉 Lunar Dragon Drop (Tết)
- **Rarity:** Mythic
- **Unlock:** Tết Event (Lunar New Year)
- **Design:** Hình rồng nước, màu đỏ-vàng may mắn
- **Limited:** Chỉ có trong Tết Việt Nam

---

## 4. USER EXPERIENCE FLOW

### 4.1. First-time Setup (Onboarding)

```
Bước 1: Sau khi nhập thông tin (age, weight, gender)
   ↓
Bước 2: Màn hình "Chọn người bạn đồng hành!"
   - Show 3 mascots (Celestial, Axo, Chibi-Bot)
   - User tap để xem preview animation
   - User chọn 1 làm default
   ↓
Bước 3: "Awesome! [Mascot Name] sẽ đồng hành cùng bạn!"
   - Short intro animation
```

### 4.2. Mascot Gallery Screen

```
📍 Vị trí: Settings → Mascot Gallery

Layout:
┌─────────────────────────────┐
│  🎭 Your Mascot Collection  │
├─────────────────────────────┤
│  Active: [Aqua-Axo] 💧     │  ← Currently using
│  [Change]                   │
├─────────────────────────────┤
│  Grid View (2 columns):     │
│  ┌───────┬───────┐          │
│  │ 🦎    │ 🌟    │ Unlocked│
│  │ Axo   │Celestial│         │
│  └───────┴───────┘          │
│  ┌───────┬───────┐          │
│  │ 🔒💎  │ 🔒🪸  │ Locked  │
│  │Chibi  │Coral  │          │
│  │Connect│30-day │ Condition│
│  │Health │streak │          │
│  └───────┴───────┘          │
├─────────────────────────────┤
│  Filters: [All][Unlocked]   │
│  Sort: [Rarity][Name][Date] │
└─────────────────────────────┘
```

### 4.3. Mascot Detail View (Khi tap vào 1 mascot)

```
┌─────────────────────────────┐
│     [Large Mascot Preview]  │  ← Live animation
│         [Aqua-Axo]          │
├─────────────────────────────┤
│  Rarity: ⭐ Common          │
│  Personality: Vui vẻ, Hài hước│
│                             │
│  "Ủa... bạn quên uống nước  │
│   hả? 🥺"                   │
│                             │
│  📊 Stats:                  │
│  • Đã dùng: 45 ngày         │
│  • Lần cuối: 2 giờ trước    │
│                             │
│  [Set as Active] [Favorite⭐]│
└─────────────────────────────┘
```

### 4.4. Unlock Notification

```
Khi unlock mascot mới:
┌─────────────────────────────┐
│  🎉 NEW MASCOT UNLOCKED!    │
│                             │
│   [Mascot animation xuất    │
│    hiện với confetti]       │
│                             │
│   🪸 Coral Guardian         │
│   "Hello friend!"           │
│                             │
│   Chúc mừng! Bạn đã duy trì │
│   streak 30 ngày!           │
│                             │
│   [Try it now] [Later]      │
└─────────────────────────────┘
```

---

## 5. KỸ THUẬT IMPLEMENTATION

### 5.1. Mascot Factory Pattern

```dart
class MascotFactory {
  static CustomPainter createPainter({
    required MascotType type,
    required double animationValue,
    required JellyPhysics physics,
    required double hydrationPercent,
    Map<String, dynamic>? extraParams,
  }) {
    switch (type) {
      case MascotType.celestialDrop:
        return PuruCelestialPainter(
          animationValue: animationValue,
          rotationY: extraParams?['rotationY'] ?? 0,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      case MascotType.aquaAxo:
        return PuruAxoPainter(
          animationValue: animationValue,
          tailWagAngle: extraParams?['tailWagAngle'] ?? 0,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      case MascotType.liquidChibiBot:
        return PuruChibiBotPainter(
          animationValue: animationValue,
          hueShift: extraParams?['hueShift'] ?? 0,
          physics: physics,
          hydrationPercent: hydrationPercent,
        );
      
      // Easy to add more!
      case MascotType.coralGuardian:
        return CoralGuardianPainter(...);
      
      default:
        return PuruAxoPainter(...); // Fallback
    }
  }
}
```

### 5.2. Mascot Registry (Single Source of Truth)

```dart
class MascotRegistry {
  static final Map<MascotType, MascotInfo> _registry = {
    MascotType.celestialDrop: MascotInfo(
      type: MascotType.celestialDrop,
      name: 'Celestial Drop',
      nameVi: 'Giọt Thiên Hà',
      description: 'A magical water droplet containing the cosmos',
      descriptionVi: 'Giọt nước ma thuật chứa cả vũ trụ',
      personality: 'Elegant, Dreamy, Poetic',
      unlockCondition: UnlockCondition.streak(days: 7),
      rarity: MascotRarity.rare,
      quotes: [
        'Bạn đẹp như dải ngân hà khi uống đủ nước~',
        'Mỗi giọt nước là một vì sao lấp lánh.',
      ],
      tags: ['elegant', 'magical', 'artistic'],
    ),
    
    MascotType.aquaAxo: MascotInfo(
      type: MascotType.aquaAxo,
      name: 'Aqua-Axo',
      nameVi: 'Cá Kỳ Lân',
      description: 'The cutest water creature you\'ll ever meet',
      descriptionVi: 'Sinh vật nước đáng yêu nhất bạn từng gặp',
      personality: 'Cheerful, Goofy, Caring',
      unlockCondition: UnlockCondition.default_,
      rarity: MascotRarity.common,
      isDefault: true,
      quotes: [
        'Ủa... bạn quên uống nước hả? 🥺',
        'Yayyy! Bạn uống nước rồi! *vẫy đuôi*',
      ],
      tags: ['cute', 'friendly', 'pet-like'],
    ),
    
    // ... more mascots
  };
  
  static MascotInfo getInfo(MascotType type) => _registry[type]!;
  static List<MascotInfo> getAllMascots() => _registry.values.toList();
  static List<MascotInfo> getUnlockedMascots(List<MascotType> unlockedTypes) {
    return unlockedTypes.map((t) => _registry[t]!).toList();
  }
}
```

### 5.3. State Management (Riverpod)

```dart
// Provider lưu mascot đang dùng
final activeMascotProvider = StateNotifierProvider<ActiveMascotNotifier, MascotType>((ref) {
  return ActiveMascotNotifier(ref);
});

class ActiveMascotNotifier extends StateNotifier<MascotType> {
  ActiveMascotNotifier(this.ref) : super(MascotType.aquaAxo) {
    _loadFromStorage();
  }
  
  final Ref ref;
  
  Future<void> _loadFromStorage() async {
    // Load từ Supabase hoặc local storage
    final user = await ref.read(userProvider.future);
    state = user?.activeMascot ?? MascotType.aquaAxo;
  }
  
  Future<void> setActiveMascot(MascotType type) async {
    state = type;
    // Save to Supabase
    await ref.read(supabaseProvider).from('users').update({
      'active_mascot': type.name,
    }).eq('id', currentUserId);
    
    // Analytics
    logEvent('mascot_changed', {'new_mascot': type.name});
  }
}

// Provider danh sách mascots đã unlock
final unlockedMascotsProvider = StreamProvider<List<MascotType>>((ref) {
  return ref.watch(supabaseProvider)
    .from('user_mascots')
    .stream(primaryKey: ['id'])
    .eq('user_id', currentUserId)
    .map((data) => data.map((m) => MascotType.values.byName(m['mascot_type'])).toList());
});
```

---

## 6. GAMIFICATION & PROGRESSION

### 6.1. Mascot Collection Achievements

```dart
enum MascotAchievement {
  collector('Collector', 'Unlock 5 mascots'),
  masterCollector('Master Collector', 'Unlock 10 mascots'),
  completionist('Completionist', 'Unlock all mascots'),
  loyalist('Loyalist', 'Use 1 mascot for 30 days straight'),
  explorer('Explorer', 'Try all unlocked mascots'),
}
```

### 6.2. Mascot Progression System (Phase 2)

**Concept:** Mascots có thể "lớn lên" theo thời gian dùng

```dart
enum MascotLevel {
  baby(0),      // 0-7 days
  child(7),     // 7-30 days
  teen(30),     // 30-90 days
  adult(90),    // 90-180 days
  master(180),  // 180+ days
}

// Mỗi level unlock:
// - New animations
// - New quotes/reactions
// - Appearance changes (bigger, more details)
// - Special abilities (better reminders, etc.)
```

---

## 7. MONETIZATION STRATEGY

### 7.1. Free vs Premium

**Free Mascots:**
- 3 starter mascots (Celestial, Axo, Chibi)
- 4 seasonal mascots (unlock by playing)
- 2 achievement mascots (30-day, 100-day streak)

**Premium Mascots ($1.99 - $4.99 each):**
- Royal Aquamarine (Premium exclusive)
- Mythic Dragon Drop (Tết exclusive)
- Future celebrity collaborations

### 7.2. Mascot Pass (Subscription)

**$4.99/month:**
- Unlock all premium mascots
- Early access to new mascots (1 week before F2P)
- Exclusive mascot variants (color changes)
- Mascot customization (change colors, accessories)

---

## 8. CONTENT ROADMAP

### Month 1-3: Foundation
- 3 launch mascots ✅
- Basic gallery system
- Unlock mechanics

### Month 4-6: Expansion
- +3 seasonal mascots
- +2 achievement mascots
- Mascot favorites

### Month 7-12: Advanced Features
- Mascot progression system
- Mascot customization
- +5 premium mascots
- Mascot Pass subscription

### Year 2+: Community
- User-submitted mascot designs (contest)
- Collaborations (với brands, artists)
- AR mascots (integrate with ARKit/ARCore)
- Mascot mini-games

---

## 9. TECHNICAL CONSIDERATIONS

### 9.1. Performance

**Challenge:** Nhiều mascots = nhiều CustomPainters = tốn memory?

**Solution:**
- Lazy loading: Chỉ load painter khi cần
- Asset caching: Cache animation frames
- Widget pooling: Reuse painters
- LOD (Level of Detail): Gallery view dùng simplified version

### 9.2. Scalability

**Design cho 50+ mascots:**
```dart
// Không hard-code switch-case cho từng mascot
// Dùng reflection hoặc dynamic loading

class MascotInfo {
  final String painterClassName; // 'PuruCelestialPainter'
  
  CustomPainter createPainter(...) {
    // Dynamic instantiation
    return reflectClass(painterClassName).newInstance(...);
  }
}
```

### 9.3. A/B Testing

Test xem mascots nào được user yêu thích nhất:
- Track usage time per mascot
- Track unlock rate
- Surveys: "Why do you love this mascot?"

---

## 10. FUTURE INNOVATIONS

### 10.1. Mascot Interactions
- **Tap:** Mascot phản ứng (giggle, bounce)
- **Shake phone:** Mascot ngã (funny animation)
- **Swipe:** Mascot dodge
- **Long press:** Mascot falls asleep

### 10.2. Mascot Moods
Mascot thay đổi mood theo:
- Time of day (buổi sáng energetic, đêm sleepy)
- Weather (mưa thì buồn, nắng thì vui)
- User's hydration level
- User's activity (workout → excited)

### 10.3. Mascot Social Features
- **Mascot Battle:** Compare mascots với friends (who has rarer?)
- **Mascot Trading:** Trade mascots với friends (nếu duplicate)
- **Mascot Meetup:** AR feature - 2 users gặp nhau, mascots tương tác

### 10.4. Voice & Sound
Mỗi mascot có:
- Unique voice (text-to-speech với personality)
- Sound effects (splash, giggle, etc.)
- Theme music (background ambience)

---

Mascot Interactions (Phase 2):
Tap → mascot giggle
Shake phone → mascot ngã
Long press → mascot sleep
Mascot Moods (Phase 3):
Thay đổi mood theo thời gian, thời tiết
Morning energetic, night sleepy
AR Mascots (Phase 4):
Integrate ARKit/ARCore
Mascot xuất hiện trong không gian thực
Mascot Social (Phase 5):
Mascot Battle với friends
Mascot Trading (nếu duplicate)
Mascot Meetup (AR)
⚠️ KHÓ KHĂN & GIẢI PHÁP:
Khó khăn 1: Nhiều mascots = tốn memory?
Giải pháp: Lazy loading, asset caching, widget pooling
Khó khăn 2: Khó maintain khi có 50+ mascots?
Giải pháp: Registry + Factory Pattern (đã implement)
Khó khăn 3: User không biết cách unlock?
Giải pháp: Locked mascots hiển thị rõ unlock condition

## 11. KẾT LUẬN

Hệ thống Mascot là **"Soul of SmartHydro"**. Đây không chỉ là decoration, mà là:
- **Emotional anchor** (neo cảm xúc) giữa user và app
- **Gamification engine** (động cơ chơi game)
- **Revenue driver** (nguồn doanh thu) qua premium mascots
- **Brand identity** (bản sắc thương hiệu)

Với kiến trúc mở rộng này, SmartHydro có thể:
✅ Thêm vô hạn mascots mới mà không refactor code  
✅ Test A/B dễ dàng  
✅ Monetize linh hoạt  
✅ Tạo viral content (user share mascots)  

**Next Steps:**
1. ✅ Implement Mascot Registry
2. ✅ Implement Factory Pattern
3. ✅ Create Mascot Gallery UI
4. ✅ Integrate với Settings
5. Add 3 more mascots (Coral, Glacier, Lava)
6. Launch Beta testing

---

*"Every drop has a personality. Choose yours."* 💧✨

