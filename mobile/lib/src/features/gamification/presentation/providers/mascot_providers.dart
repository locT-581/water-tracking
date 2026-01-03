/// Mascot Providers - State management cho mascot system
/// 
/// Sử dụng Riverpod để quản lý state của mascots

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/mascot_models.dart';
import '../../domain/services/mascot_registry.dart';

/// Key để lưu active mascot trong SharedPreferences
const String _activeMascotKey = 'active_mascot';

/// Provider cho SharedPreferences (phải được override trong main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

/// Provider cho active mascot (mascot đang được sử dụng)
final activeMascotProvider = StateNotifierProvider<ActiveMascotNotifier, MascotType>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ActiveMascotNotifier(prefs);
});

class ActiveMascotNotifier extends StateNotifier<MascotType> {
  final SharedPreferences _prefs;
  
  ActiveMascotNotifier(this._prefs) : super(MascotType.aquaAxo) {
    _loadFromStorage();
  }
  
  void _loadFromStorage() {
    final savedMascot = _prefs.getString(_activeMascotKey);
    if (savedMascot != null) {
      try {
        state = MascotType.values.firstWhere(
          (m) => m.name == savedMascot,
          orElse: () => MascotType.aquaAxo,
        );
      } catch (_) {
        state = MascotType.aquaAxo;
      }
    }
    // Note: If no saved mascot, it will use the default (aquaAxo)
    // The mascot will be set when user completes onboarding
  }
  
  Future<void> setActiveMascot(MascotType type) async {
    state = type;
    await _prefs.setString(_activeMascotKey, type.name);
  }
}

/// Provider cho danh sách mascots đã unlock
final unlockedMascotsProvider = StateNotifierProvider<UnlockedMascotsNotifier, List<MascotType>>((ref) {
  return UnlockedMascotsNotifier();
});

class UnlockedMascotsNotifier extends StateNotifier<List<MascotType>> {
  UnlockedMascotsNotifier() : super([MascotType.aquaAxo]) {
    _loadUnlockedMascots();
  }
  
  Future<void> _loadUnlockedMascots() async {
    // TODO: Load from Supabase
    // For now, just default
    state = [MascotType.aquaAxo];
  }
  
  Future<void> unlockMascot(MascotType type) async {
    if (!state.contains(type)) {
      state = [...state, type];
      // TODO: Save to Supabase
      // TODO: Show unlock notification
    }
  }
  
  bool isUnlocked(MascotType type) {
    return state.contains(type);
  }
}

/// Provider để check điều kiện unlock
final mascotUnlockStatusProvider = Provider.family<bool, MascotType>((ref, type) {
  final info = MascotRegistry.getInfo(type);
  final unlockedMascots = ref.watch(unlockedMascotsProvider);
  
  // Already unlocked
  if (unlockedMascots.contains(type)) {
    return true;
  }
  
  // Check unlock condition
  // TODO: Get real data from user profile
  final currentStreak = 0; // ref.watch(streakProvider)
  final healthConnected = false; // ref.watch(healthConnectedProvider)
  final completedChallenges = <String>[]; // ref.watch(completedChallengesProvider)
  final purchasedMascots = <String>[]; // ref.watch(purchasedMascotsProvider)
  
  return info.canUnlock(
    currentStreak: currentStreak,
    healthConnected: healthConnected,
    completedChallenges: completedChallenges,
    purchasedMascots: purchasedMascots,
  );
});

/// Provider cho hydration percent (để mascot hiển thị đúng state)
final hydrationPercentProvider = StateProvider<double>((ref) {
  // TODO: Calculate from today's water intake
  return 0.75; // 75% as default
});

/// Provider cho mascot info by type
final mascotInfoProvider = Provider.family<MascotInfo, MascotType>((ref, type) {
  return MascotRegistry.getInfo(type);
});

/// Provider cho tất cả mascots (for gallery)
final allMascotsProvider = Provider<List<MascotInfo>>((ref) {
  return MascotRegistry.getAllMascots();
});

/// Provider cho unlocked mascot infos
final unlockedMascotInfosProvider = Provider<List<MascotInfo>>((ref) {
  final unlockedTypes = ref.watch(unlockedMascotsProvider);
  return MascotRegistry.getUnlockedMascots(unlockedTypes);
});

/// Provider cho locked mascot infos
final lockedMascotInfosProvider = Provider<List<MascotInfo>>((ref) {
  final unlockedTypes = ref.watch(unlockedMascotsProvider);
  return MascotRegistry.getLockedMascots(unlockedTypes);
});

/// Provider cho seasonal mascots
final seasonalMascotsProvider = Provider<List<MascotInfo>>((ref) {
  return MascotRegistry.getSeasonalMascots();
});

/// Provider cho event mascots
final eventMascotsProvider = Provider<List<MascotInfo>>((ref) {
  return MascotRegistry.getEventMascots();
});

/// Provider để filter mascots
enum MascotFilter {
  all,
  unlocked,
  locked,
  seasonal,
  premium,
}

final mascotFilterProvider = StateProvider<MascotFilter>((ref) {
  return MascotFilter.all;
});

final filteredMascotsProvider = Provider<List<MascotInfo>>((ref) {
  final filter = ref.watch(mascotFilterProvider);
  final allMascots = ref.watch(allMascotsProvider);
  final unlockedTypes = ref.watch(unlockedMascotsProvider);
  
  switch (filter) {
    case MascotFilter.all:
      return allMascots;
    case MascotFilter.unlocked:
      return allMascots.where((m) => unlockedTypes.contains(m.type)).toList();
    case MascotFilter.locked:
      return allMascots.where((m) => !unlockedTypes.contains(m.type)).toList();
    case MascotFilter.seasonal:
      return MascotRegistry.getSeasonalMascots();
    case MascotFilter.premium:
      return allMascots.where((m) {
        return m.unlockCondition is PremiumUnlock;
      }).toList();
  }
});

/// Provider để sort mascots
enum MascotSort {
  name,
  rarity,
  unlockDate,
}

final mascotSortProvider = StateProvider<MascotSort>((ref) {
  return MascotSort.rarity;
});

final sortedMascotsProvider = Provider<List<MascotInfo>>((ref) {
  final mascots = ref.watch(filteredMascotsProvider);
  final sort = ref.watch(mascotSortProvider);
  
  final sortedList = List<MascotInfo>.from(mascots);
  
  switch (sort) {
    case MascotSort.name:
      sortedList.sort((a, b) => a.nameVi.compareTo(b.nameVi));
      break;
    case MascotSort.rarity:
      sortedList.sort((a, b) => b.rarity.index.compareTo(a.rarity.index));
      break;
    case MascotSort.unlockDate:
      // TODO: Sort by actual unlock date from database
      break;
  }
  
  return sortedList;
});

