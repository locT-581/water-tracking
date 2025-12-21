/// Domain models cho Mascot System
/// 
/// Định nghĩa các enums, classes cho mascot collection system

import 'package:flutter/material.dart';

/// Enum định nghĩa tất cả các loại mascots
enum MascotType {
  // Wave 1: Launch Mascots
  aquaAxo,
  celestialDrop,
  liquidChibiBot,
  
  // Wave 2: Seasonal & Achievement Mascots
  coralGuardian,
  glacierSpirit,
  lavaDrop,
  tsunamiTitan,
  
  // Wave 3: Premium & Special Edition
  royalAquamarine,
  spookySplash,
  lunarDragon,
}

/// Rarity levels cho mascots
enum MascotRarity {
  common(color: Color(0xFF9E9E9E), label: 'Common'),
  uncommon(color: Color(0xFF4CAF50), label: 'Uncommon'),
  rare(color: Color(0xFF2196F3), label: 'Rare'),
  epic(color: Color(0xFF9C27B0), label: 'Epic'),
  legendary(color: Color(0xFFFFD700), label: 'Legendary'),
  mythic(color: Color(0xFFFF1744), label: 'Mythic');

  const MascotRarity({required this.color, required this.label});
  
  final Color color;
  final String label;
}

/// Điều kiện để unlock mascot
sealed class UnlockCondition {
  const UnlockCondition();
}

class DefaultUnlock extends UnlockCondition {
  const DefaultUnlock();
}

class StreakUnlock extends UnlockCondition {
  final int days;
  const StreakUnlock(this.days);
  
  String get description => 'Đạt $days ngày streak';
}

class ChallengeUnlock extends UnlockCondition {
  final String challengeId;
  const ChallengeUnlock(this.challengeId);
  
  String get description => 'Hoàn thành challenge';
}

class SeasonalUnlock extends UnlockCondition {
  final String season;
  final int startMonth;
  final int endMonth;
  
  const SeasonalUnlock({
    required this.season,
    required this.startMonth,
    required this.endMonth,
  });
  
  String get description => 'Có sẵn trong mùa $season';
  
  bool isCurrentlyAvailable() {
    final now = DateTime.now();
    final month = now.month;
    
    if (startMonth <= endMonth) {
      return month >= startMonth && month <= endMonth;
    } else {
      // Cross-year season (e.g., Dec-Feb)
      return month >= startMonth || month <= endMonth;
    }
  }
}

class HealthConnectUnlock extends UnlockCondition {
  const HealthConnectUnlock();
  
  String get description => 'Kết nối Apple Health/Google Fit';
}

class PremiumUnlock extends UnlockCondition {
  final double price;
  const PremiumUnlock(this.price);
  
  String get description => 'Premium - \$$price';
}

class EventUnlock extends UnlockCondition {
  final String eventId;
  final DateTime startDate;
  final DateTime endDate;
  
  const EventUnlock({
    required this.eventId,
    required this.startDate,
    required this.endDate,
  });
  
  String get description => 'Event đặc biệt';
  
  bool isEventActive() {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }
}

/// Thông tin chi tiết về một mascot
class MascotInfo {
  final MascotType type;
  final String name;
  final String nameVi;
  final String description;
  final String descriptionVi;
  final String personality;
  final UnlockCondition unlockCondition;
  final MascotRarity rarity;
  final List<String> quotes;
  final List<String> tags;
  final bool isDefault;
  final String? iconAsset; // Path to icon asset
  
  const MascotInfo({
    required this.type,
    required this.name,
    required this.nameVi,
    required this.description,
    required this.descriptionVi,
    required this.personality,
    required this.unlockCondition,
    required this.rarity,
    required this.quotes,
    required this.tags,
    this.isDefault = false,
    this.iconAsset,
  });
  
  /// Get localized name (for now, just return Vietnamese)
  String get localizedName => nameVi;
  
  /// Get localized description
  String get localizedDescription => descriptionVi;
  
  /// Check if mascot can be unlocked
  bool canUnlock({
    required int currentStreak,
    required bool healthConnected,
    required List<String> completedChallenges,
    required List<String> purchasedMascots,
  }) {
    final condition = unlockCondition;
    
    return switch (condition) {
      DefaultUnlock() => true,
      StreakUnlock(days: final days) => currentStreak >= days,
      HealthConnectUnlock() => healthConnected,
      ChallengeUnlock(challengeId: final id) => completedChallenges.contains(id),
      PremiumUnlock() => purchasedMascots.contains(type.name),
      SeasonalUnlock() => condition.isCurrentlyAvailable(),
      EventUnlock() => condition.isEventActive(),
    };
  }
}

/// User's mascot collection data
class UserMascot {
  final String id;
  final String userId;
  final MascotType mascotType;
  final DateTime unlockedAt;
  final bool isFavorite;
  final int usageCount;
  final DateTime? lastUsedAt;
  
  const UserMascot({
    required this.id,
    required this.userId,
    required this.mascotType,
    required this.unlockedAt,
    this.isFavorite = false,
    this.usageCount = 0,
    this.lastUsedAt,
  });
  
  /// Create from Supabase JSON
  factory UserMascot.fromJson(Map<String, dynamic> json) {
    return UserMascot(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mascotType: MascotType.values.byName(json['mascot_type'] as String),
      unlockedAt: DateTime.parse(json['unlocked_at'] as String),
      isFavorite: json['is_favorite'] as bool? ?? false,
      usageCount: json['usage_count'] as int? ?? 0,
      lastUsedAt: json['last_used_at'] != null
          ? DateTime.parse(json['last_used_at'] as String)
          : null,
    );
  }
  
  /// Convert to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'mascot_type': mascotType.name,
      'unlocked_at': unlockedAt.toIso8601String(),
      'is_favorite': isFavorite,
      'usage_count': usageCount,
      'last_used_at': lastUsedAt?.toIso8601String(),
    };
  }
  
  /// Copy with
  UserMascot copyWith({
    String? id,
    String? userId,
    MascotType? mascotType,
    DateTime? unlockedAt,
    bool? isFavorite,
    int? usageCount,
    DateTime? lastUsedAt,
  }) {
    return UserMascot(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mascotType: mascotType ?? this.mascotType,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      usageCount: usageCount ?? this.usageCount,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }
}

/// Achievement related to mascot collection
enum MascotAchievement {
  collector(
    id: 'collector',
    name: 'Collector',
    description: 'Unlock 5 mascots',
    requiredCount: 5,
  ),
  masterCollector(
    id: 'master_collector',
    name: 'Master Collector',
    description: 'Unlock 10 mascots',
    requiredCount: 10,
  ),
  completionist(
    id: 'completionist',
    name: 'Completionist',
    description: 'Unlock all mascots',
    requiredCount: 999, // Will check against total available
  ),
  loyalist(
    id: 'loyalist',
    name: 'Loyalist',
    description: 'Use 1 mascot for 30 days straight',
    requiredCount: 30,
  ),
  explorer(
    id: 'explorer',
    name: 'Explorer',
    description: 'Try all unlocked mascots',
    requiredCount: 1, // Special logic
  );

  const MascotAchievement({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredCount,
  });
  
  final String id;
  final String name;
  final String description;
  final int requiredCount;
}

