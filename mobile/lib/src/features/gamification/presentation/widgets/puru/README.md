# 🫧 Puru Mascot System

Hệ thống mascot Puru hoàn chỉnh cho SmartHydro app - một sinh vật nước sống động với animations mượt mà, biểu cảm phong phú, và khả năng tùy biến cao.

## 📦 Cấu trúc Files

```
puru/
├── puru.dart                   # Export library chính
├── puru_state.dart            # States, expressions, accessories enums
├── puru_colors.dart           # Color palette
├── puru_body_painter.dart     # Custom painter cho body
├── puru_face_painter.dart     # Custom painter cho face
├── puru_accessory_painter.dart # Custom painter cho accessories
├── puru_animation_controller.dart # Animation management
├── puru_effects.dart          # Visual effects (hiccup, sleep, glow)
├── puru_reactions.dart        # Messages và reactions
├── puru_widget.dart           # Main widget
├── puru_showcase.dart         # Demo/preview screen
├── puru_skins.dart            # Skin system
├── puru_evolution.dart        # Evolution system
└── README.md                  # Documentation
```

## 🚀 Quick Start

### Import

```dart
import 'package:smarthydro/src/features/gamification/presentation/widgets/puru/puru.dart';
```

### Basic Usage

```dart
// Full Puru widget với message bubble
PuruWidget(
  size: 200,
  hydrationPercent: 0.75, // 0.0 to 1.5 (0% to 150%)
  onTap: () => print('Tapped!'),
  onLongPress: () => print('Hugged!'),
)

// Mini version cho list items, widgets
PuruMini(
  size: 60,
  hydrationPercent: 0.5,
)

// Loading animation
PuruLoading(
  message: 'Đang tải...',
)
```

## 🎭 Hydration States

| State | % Range | Appearance |
|-------|---------|------------|
| `hydrated` | 100%+ | Glowing cyan-green, floating, joyful |
| `good` | 75-99% | Bright blue, bouncing, happy |
| `okay` | 50-74% | Light blue, idle, content |
| `thirsty` | 25-49% | Grayish, deflated, worried |
| `dehydrated` | 0-24% | Purple, melting, sad, SOS sign |
| `overHydrated` | 120%+ | Pale blue, bloated, dizzy, hiccup bubbles |
| `sleeping` | Sleep hours | Soft blue, Zzz effect |

## 😊 Expressions

```dart
PuruExpression.happy      // Default smile
PuruExpression.joyful     // Eyes closed, big smile
PuruExpression.excited    // Sparkly eyes
PuruExpression.confused   // One eyebrow raised
PuruExpression.worried    // Slightly sad
PuruExpression.sad        // Tears
PuruExpression.sleepy     // Half-closed eyes
PuruExpression.dizzy      // Spiral eyes
PuruExpression.determined // Focused
PuruExpression.surprised  // Wide eyes, O mouth
PuruExpression.winking    // One eye closed
```

## 🎩 Accessories

```dart
PuruAccessory.none        // No accessory
PuruAccessory.sunglasses  // For hot weather
PuruAccessory.dumbbells   // After workout
PuruAccessory.coffee      // Morning
PuruAccessory.sosSign     // Dehydrated state
PuruAccessory.crown       // Achievements
PuruAccessory.medal       // Streak milestones
PuruAccessory.sleepCap    // Night time
PuruAccessory.umbrella    // Rainy weather
PuruAccessory.scarf       // Cold weather
```

## 🎨 Skins

Skins được unlock dựa trên streak days:

| Skin | Unlock | Description |
|------|--------|-------------|
| Classic | 0 days | Default blue |
| Summer | 7 days | Orange coral |
| Winter | 14 days | Ice blue |
| Forest | 21 days | Nature green |
| Galaxy | 30 days | Purple cosmic |
| Sakura | 45 days | Pink cherry |
| Golden | 60 days | Champion gold |
| Rainbow | 90 days | Multi-color |
| Midnight | 100 days | Dark neon |
| Crystal | Premium | Transparent |

```dart
// Get available skins
final skins = PuruSkins.getUnlockedSkins(streakDays);

// Get next unlock
final next = PuruSkins.getNextUnlockableSkin(streakDays);
```

## 📈 Evolution System

Puru evolves based on consecutive streak days:

| Stage | Days | Features |
|-------|------|----------|
| Baby | 0+ | Small size |
| Toddler | 7+ | Normal size |
| Youth | 30+ | Full size |
| Adult | 90+ | Halo effect |
| Elder | 180+ | Halo + Wings |
| Legendary | 365+ | Golden aura |

```dart
// Get current evolution
final evolution = PuruEvolutions.getEvolution(streakDays);

// Show progress widget
PuruEvolutionProgress(streakDays: 45)
```

## 🎬 Animations

### Built-in Animations

- **Breathing**: Continuous subtle scale
- **Floating**: Up/down bobbing
- **Blinking**: Periodic eye blinks
- **Wobble**: Body edge wobble
- **Squish**: On tap reaction
- **Bounce**: Celebration

### Trigger Animations

```dart
// Access controller through key
final puruKey = GlobalKey<PuruWidgetState>();

PuruWidget(
  key: puruKey,
  // ...
)

// Trigger animations
puruKey.currentState?.controller.squish();
puruKey.currentState?.controller.bounce();
puruKey.currentState?.controller.playDrinkAnimation();
puruKey.currentState?.controller.playCelebration();
```

## ✨ Effects

### Automatic Effects

- **Glow**: When hydrated (100%+)
- **Hiccup Bubbles**: When over-hydrated
- **Sleep Zzz**: During sleep hours
- **Water Drips**: When dehydrated

### Sparkle Effect (manual)

```dart
SparkleEffect(
  isActive: showCelebration,
  color: Colors.gold,
)
```

## 💬 Reactions & Messages

```dart
// Get contextual messages
PuruReactions.getGreeting(DateTime.now(), hydrationPercent);
PuruReactions.getLogReaction(volumeMl, newPercent);
PuruReactions.getEncouragement(hydrationPercent);
PuruReactions.getStreakMessage(streakDays);
PuruReactions.getTapReaction();
```

## 🔧 Advanced Customization

### Custom State

```dart
PuruWidget(
  // Override auto-detected state
  expression: PuruExpression.excited,
  accessory: PuruAccessory.crown,
  customMessage: 'Chúc mừng sinh nhật!',
)
```

### Eye Tracking

```dart
PuruWidget(
  enableEyeTracking: true, // Eyes follow finger
)
```

### Disable Features

```dart
PuruWidget(
  showMessage: false,      // Hide message bubble
  showGlowEffect: false,   // Hide glow for hydrated
  enableEyeTracking: false,
)
```

## 🧪 Testing & Preview

Navigate to `PuruShowcase` to test all states:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const PuruShowcase()),
);
```

Or use `PuruAnimationDemo` for automatic cycling:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const PuruAnimationDemo()),
);
```

## 📐 Design Specifications

### Size Recommendations

| Context | Size |
|---------|------|
| Home Screen Main | 180-220px |
| Dashboard Card | 100-140px |
| List Item | 50-70px |
| Widget | 60-80px |
| Loading | 80-120px |

### Colors (from VISUAL_DESIGN.md)

- Primary: `#2AF598` → `#009EFD`
- Hydrated Glow: `#2AF598`
- Dehydrated: `#9575CD`
- Text: `#051E3E`

## 🔍 Troubleshooting

### Animation Performance

If animations are janky:
1. Reduce bubble count
2. Disable glow effect
3. Use `PuruMini` instead

### Memory Issues

Call `dispose()` on animation controller when widget is removed.

### Eye Tracking Not Working

Ensure `enableEyeTracking: true` and parent widget has proper gesture detection area.

---

*Puru là linh hồn của SmartHydro - hãy đối xử với cậu ấy thật tốt! 💧*

