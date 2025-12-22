---
description: "Gamification system rules for SmartHydro - Buddy, Streaks, Challenges"
globs: ["**/gamification/**", "**/buddy/**", "**/challenge/**", "**/streak/**"]
alwaysApply: false
---

# SmartHydro Gamification System

Rules for implementing the gamification features including Puru (buddy), streaks, challenges, and rewards.

## Puru - The Hydration Buddy

### Character Design
- **Name:** Puru (sound of water bubble popping)
- **Form:** Soft-body water sphere, transparent, bouncy
- **Features:** 
  - Large round black glossy eyes (highly expressive)
  - Small mouth
  - Tiny air bubbles floating inside body

### State Machine

```dart
enum PuruState {
  hydrated,      // 100%+ goal
  good,          // 75-99%
  okay,          // 50-74%
  thirsty,       // 25-49%
  dehydrated,    // 0-24%
  sleeping,      // During sleep hours
  overHydrated,  // 120%+ (rare state)
}

PuruState calculatePuruState(int achieved, int goal, bool isSleepTime) {
  if (isSleepTime) return PuruState.sleeping;
  
  final percentage = (achieved / goal) * 100;
  
  if (percentage >= 120) return PuruState.overHydrated;
  if (percentage >= 100) return PuruState.hydrated;
  if (percentage >= 75) return PuruState.good;
  if (percentage >= 50) return PuruState.okay;
  if (percentage >= 25) return PuruState.thirsty;
  return PuruState.dehydrated;
}
```

### Visual States

| State | Body | Color | Face | Animation | Accessories |
|-------|------|-------|------|-----------|-------------|
| **Hydrated** | Full, bouncy | Bright blue gradient, glowing | Closed-eye smile | Floating, bouncing | Sunglasses (hot day), Weights (post-workout) |
| **Good** | Normal | Normal blue | Gentle smile | Gentle floating | None |
| **Okay** | Slightly flat | Lighter blue | Neutral | Slow floating | None |
| **Thirsty** | Deflated | Grayish blue | Worried eyes | Wobbling | None |
| **Dehydrated** | Melting/Jelly | Purple-gray | Sad, teary | Drooping | Holding "SOS" sign |
| **Sleeping** | Curled up | Dim blue | Peaceful closed eyes | Zzz bubbles | Nightcap |
| **Over-hydrated** | Bloated | Pale blue | Dizzy, hiccup | Floating high, slow | Hiccup bubbles |

### Contextual Accessories
```dart
List<PuruAccessory> getContextualAccessories(WeatherData weather, ActivityData activity) {
  final accessories = <PuruAccessory>[];
  
  if (weather.temperature > 32) {
    accessories.add(PuruAccessory.sunglasses);
  }
  if (activity.recentWorkout) {
    accessories.add(PuruAccessory.sweatband);
  }
  if (weather.isRaining) {
    accessories.add(PuruAccessory.umbrella);
  }
  
  return accessories;
}
```

## Streak System

### Streak Rules
1. Complete daily goal (100%) to count as a successful day
2. Streak continues if yesterday was completed
3. Streak resets to 0 if a day is missed
4. Grace period: None (strict for gamification impact)

### Streak Milestones & Rewards

| Streak Days | Reward | Type |
|-------------|--------|------|
| 3 | "Getting Started" badge | Badge |
| 7 | New skin: "Ocean Breeze" | Skin |
| 14 | "Two Weeks Strong" badge | Badge |
| 21 | New skin: "Tropical" | Skin |
| 30 | New buddy: "Golden Puru" | Buddy |
| 60 | "Two Months!" badge | Badge |
| 90 | New skin: "Diamond" | Skin |
| 100 | "Century Club" badge + Special animation | Badge |
| 365 | "Year of Hydration" badge + Exclusive buddy | Buddy |

### Implementation
```dart
class StreakService {
  Future<void> checkAndUpdateStreak(String userId) async {
    final today = DateTime.now().toDateOnly();
    final yesterday = today.subtract(Duration(days: 1));
    
    final todayGoal = await getDailyGoal(userId, today);
    if (!todayGoal.isCompleted) return;
    
    final streak = await getStreak(userId);
    
    if (streak.lastCompletedDate == yesterday) {
      // Continue streak
      await updateStreak(userId, 
        currentStreak: streak.currentStreak + 1,
        longestStreak: max(streak.longestStreak, streak.currentStreak + 1),
        lastCompletedDate: today,
      );
    } else if (streak.lastCompletedDate != today) {
      // Reset streak (missed a day)
      await updateStreak(userId,
        currentStreak: 1,
        lastCompletedDate: today,
      );
    }
    
    // Check for milestone rewards
    await checkMilestoneRewards(userId, streak.currentStreak + 1);
  }
}
```

## Challenge System

### Challenge Types

| Challenge | Duration | Goal | Reward |
|-----------|----------|------|--------|
| **Detox Challenge** | 7 days | 100% daily for 7 days | "Detox Master" badge |
| **Summer Hydration** | 14 days | 100% daily in summer | "Sunny" skin |
| **Consistency King** | 30 days | No missed days | "Golden Puru" buddy |
| **Coffee Cutter** | 7 days | Max 1 coffee/day | "Tea Lover" badge |
| **Morning Starter** | 7 days | 500ml before 10am daily | "Early Bird" badge |
| **Weekend Warrior** | 2 days | 120% on Sat & Sun | Bonus points |

### Challenge States
```dart
enum ChallengeStatus {
  available,    // Can be started
  inProgress,   // Currently active
  completed,    // Successfully finished
  failed,       // Did not complete in time
  locked,       // Requires prerequisite
}
```

### Challenge Progress Calculation
```dart
class ChallengeProgress {
  final Challenge challenge;
  final int currentDay;
  final int totalDays;
  final bool todayCompleted;
  final List<bool> dailyResults;
  
  double get progressPercentage => currentDay / totalDays;
  
  bool get isOnTrack {
    // For streak challenges, all days must be completed
    if (challenge.goalType == ChallengeGoalType.streak) {
      return dailyResults.every((day) => day == true);
    }
    // For total challenges, check cumulative progress
    return currentProgress >= expectedProgress;
  }
}
```

## Points & Rewards System

### Points Earning
| Action | Points |
|--------|--------|
| Log water | 5 |
| Complete daily goal | 50 |
| 7-day streak | 100 |
| Complete challenge | 200-500 |
| First log of the day | 10 |
| Log before 9am | 15 |

### Points Spending (Future Phase)
| Item | Cost |
|------|------|
| Common skin | 500 |
| Rare skin | 1500 |
| Epic skin | 3000 |
| New buddy | 5000 |

## Achievement System

### Achievement Categories

**Hydration Achievements**
- First Drop: Log first water
- Century: Log 100 times
- Thousand Club: Log 1000 times
- Variety Pack: Log 5 different beverages

**Streak Achievements**
- Week Warrior: 7-day streak
- Monthly Master: 30-day streak
- Quarterly Queen/King: 90-day streak

**Challenge Achievements**
- Challenger: Complete first challenge
- Champion: Complete 5 challenges
- Legend: Complete all challenges

**Special Achievements**
- Early Bird: Log before 7am, 7 days in a row
- Night Owl: Log after 10pm, 7 days in a row
- Weather Warrior: Hit goal on 5 hot days (>35°C)

### Achievement Notification
```dart
void showAchievementUnlocked(Achievement achievement) {
  // Full screen celebration
  showDialog(
    context: context,
    builder: (_) => AchievementDialog(
      achievement: achievement,
      animation: ConfettiAnimation(),
      puruReaction: PuruAnimation.celebrate,
    ),
  );
  
  // Haptic feedback
  HapticFeedback.heavyImpact();
  
  // Sound effect
  AudioService.play('achievement_unlocked.mp3');
}
```

## Skin & Buddy Collection

### Default Buddy: Puru
- Basic skin (free)
- Ocean Breeze (7-day streak)
- Tropical (21-day streak)
- Diamond (90-day streak)

### Unlockable Buddies
- Golden Puru (30-day streak)
- Ninja Puru (Complete "Consistency King")
- Astronaut Puru (365-day streak)
- Rainbow Puru (All achievements)

### Skin Showcase UI
```dart
class SkinShowcase extends StatelessWidget {
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final skin = skins[index];
        return SkinCard(
          skin: skin,
          isUnlocked: unlockedSkins.contains(skin.id),
          isEquipped: currentSkin == skin.id,
          // Locked skins show silhouette
          child: skin.isUnlocked 
            ? PuruWithSkin(skin: skin)
            : PuruSilhouette(),
        );
      },
    );
  }
}
```

## Celebration Animations

### Goal Complete (100%)
1. Water fills to top with splash
2. Confetti burst (water droplets + bubbles)
3. Puru does backflip
4. "Goal Complete!" banner slides in
5. Points earned popup

### Streak Milestone
1. Special full-screen animation
2. Puru transforms/evolves
3. Reward reveal with sparkles
4. Share prompt

### Challenge Complete
1. Challenge card flips
2. "COMPLETED" stamp animation
3. Reward unlock animation
4. Confetti celebration
5. Next challenge suggestion

## Lottie Animation Files Needed

```
assets/animations/
├── puru/
│   ├── puru_hydrated.json
│   ├── puru_good.json
│   ├── puru_okay.json
│   ├── puru_thirsty.json
│   ├── puru_dehydrated.json
│   ├── puru_sleeping.json
│   ├── puru_celebrate.json
│   ├── puru_backflip.json
│   └── puru_drinking.json
├── effects/
│   ├── water_splash.json
│   ├── confetti.json
│   ├── bubbles.json
│   ├── sparkles.json
│   └── unlock.json
└── badges/
    ├── badge_unlock.json
    └── streak_fire.json
```

## Data Persistence

```dart
// Local cache for quick access
class GamificationCache {
  late Box<Streak> streakBox;
  late Box<Achievement> achievementBox;
  late Box<BuddyStatus> buddyBox;
  
  Future<void> init() async {
    streakBox = await Hive.openBox('streaks');
    achievementBox = await Hive.openBox('achievements');
    buddyBox = await Hive.openBox('buddy');
  }
}

// Sync with Supabase
class GamificationSync {
  Future<void> syncToCloud() async {
    await supabase.from('streaks').upsert(localStreak.toJson());
    await supabase.from('buddy_status').upsert(localBuddy.toJson());
  }
}
```

