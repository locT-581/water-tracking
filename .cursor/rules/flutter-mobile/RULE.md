---
description: "Flutter mobile development rules for SmartHydro app"
globs: ["**/*.dart", "lib/**", "pubspec.yaml", "android/**", "ios/**"]
alwaysApply: false
---

# Flutter Mobile Development Rules

You are developing the SmartHydro mobile app using Flutter.

## Tech Stack

- **Framework:** Flutter 3.x+
- **Language:** Dart 3.x+ (null-safety enabled)
- **State Management:** Riverpod 2.x
- **Navigation:** GoRouter
- **Local DB:** Isar (Offline-first)
- **Backend:** Supabase

## Architecture: Clean Architecture + Feature-first

```
lib/
├── main.dart
├── src/
│   ├── app/                      # App-level config
│   │   ├── app.dart
│   │   └── router.dart
│   │
│   ├── features/                 # Feature modules
│   │   ├── auth/
│   │   │   ├── data/            # Repositories, DTOs
│   │   │   ├── domain/          # Entities, Use cases
│   │   │   └── presentation/    # Screens, Widgets, Controllers
│   │   │
│   │   ├── hydration/           # Core water tracking
│   │   ├── gamification/        # Buddy, Challenges, Streaks
│   │   ├── notifications/       # Smart reminders
│   │   ├── science_hub/         # Blog articles
│   │   └── settings/            # User preferences
│   │
│   ├── core/                    # Shared utilities
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── extensions/
│   │   ├── services/            # Weather, Health services
│   │   └── utils/
│   │
│   └── shared/                  # Shared UI
│       ├── widgets/
│       └── theme/
│
├── assets/
│   ├── animations/              # Lottie files
│   ├── images/
│   └── translations/            # i18n JSON files
```

## Coding Standards

### Naming Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/Functions: `camelCase`
- Constants: `SCREAMING_SNAKE_CASE` or `kCamelCase`
- Private members: `_prefixedWithUnderscore`

### Riverpod Patterns
```dart
// Use AsyncNotifier for async operations
@riverpod
class WaterLogs extends _$WaterLogs {
  @override
  Future<List<WaterLog>> build() async {
    return await ref.watch(waterLogRepositoryProvider).getToday();
  }
  
  Future<void> addLog(WaterLog log) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(waterLogRepositoryProvider).add(log);
      return build();
    });
  }
}

// Use ref.watch for reactive, ref.read for one-time
final logs = ref.watch(waterLogsProvider);
await ref.read(waterLogsProvider.notifier).addLog(log);
```

### Widget Guidelines
```dart
// Prefer const constructors
const MyWidget({super.key});

// Extract widgets into smaller components
// Avoid deeply nested widget trees (max 3-4 levels)

// Use named parameters for clarity
WaterLogCard(
  log: log,
  onTap: () => _handleTap(log),
  showBHI: true,
);
```

## Key Packages to Use

```yaml
# State & Architecture
flutter_riverpod: ^2.4.9
go_router: ^13.0.0

# Storage
isar: ^3.1.0
flutter_secure_storage: ^9.0.0

# Supabase
supabase_flutter: ^2.3.0

# Health & Sensors
health: ^10.0.0
permission_handler: ^11.1.0
geolocator: ^10.1.0
connectivity_plus: ^5.0.2

# Notifications
flutter_local_notifications: ^16.3.0
workmanager: ^0.5.2
timezone: ^0.9.2

# UI/UX
flutter_animate: ^4.3.0
lottie: ^3.0.0
confetti: ^0.7.0
fl_chart: ^0.66.0
haptic_feedback: ^0.5.1+1

# Utils
easy_localization: ^3.0.3
intl: ^0.19.0
flutter_dotenv: ^5.1.0
```

## Hydration Engine Logic

### Base Goal Calculation
```dart
int calculateBaseGoal(int age, double weightKg) {
  if (age < 30) return (weightKg * 40).round();
  if (age <= 55) return (weightKg * 35).round();
  return (weightKg * 30).round();
}
```

### BHI Values
```dart
const Map<BeverageType, double> bhiFactors = {
  BeverageType.water: 1.0,
  BeverageType.sparklingWater: 0.95,
  BeverageType.milk: 1.10,
  BeverageType.coconutWater: 1.15,
  BeverageType.tea: 0.90,
  BeverageType.coffee: 0.85,
  BeverageType.soda: 0.70,
  BeverageType.juice: 0.80,
  BeverageType.alcohol: 0.50,
  BeverageType.energyDrink: 0.60,
};
```

### Dynamic Adjustments
```dart
int calculateWeatherAdjustment(int baseGoal, double tempC, double humidity) {
  int adjustment = 0;
  if (tempC > 35) adjustment += (baseGoal * 0.15).round();
  else if (tempC > 30) adjustment += (baseGoal * 0.10).round();
  if (humidity < 40) adjustment += (baseGoal * 0.05).round();
  return adjustment;
}
```

## Offline-First Strategy

1. Always write to local Isar DB first
2. Queue changes for sync when online
3. Use `connectivity_plus` to detect network status
4. Sync with `workmanager` in background

```dart
Future<void> logWater(WaterLog log) async {
  // 1. Save locally
  await isarDb.writeTxn(() => isarDb.waterLogs.put(log));
  
  // 2. Queue for sync
  await syncQueue.add(SyncAction.create(log));
  
  // 3. Try immediate sync if online
  if (await connectivity.isConnected) {
    await syncService.processQueue();
  }
}
```

## Performance Requirements

- Cold start: < 2 seconds
- Log action: < 100ms response
- Animation: 60fps
- Battery usage: < 2% per day (background)

## Testing

- Unit tests required for Hydration Engine
- Widget tests for critical UI components
- Use `mocktail` for mocking
- Golden tests for UI regression

```dart
void main() {
  test('calculateBaseGoal returns correct value for age < 30', () {
    expect(calculateBaseGoal(25, 70), equals(2800));
  });
}
```

