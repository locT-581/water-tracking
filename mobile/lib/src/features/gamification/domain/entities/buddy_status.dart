import 'package:equatable/equatable.dart';

/// Puru buddy status entity
class BuddyStatus extends Equatable {
  final String userId;
  final String buddyType;
  final String currentSkin;
  final List<String> unlockedSkins;
  final List<String> unlockedBuddies;
  final List<Badge> badges;
  final int totalPoints;
  final DateTime updatedAt;

  const BuddyStatus({
    required this.userId,
    this.buddyType = 'default_puru',
    this.currentSkin = 'basic',
    this.unlockedSkins = const ['basic'],
    this.unlockedBuddies = const ['default_puru'],
    this.badges = const [],
    this.totalPoints = 0,
    required this.updatedAt,
  });

  /// Get Puru state based on hydration percentage
  PuruState getPuruState(double hydrationPercent) {
    if (hydrationPercent >= 1.0) return PuruState.hydrated;
    if (hydrationPercent >= 0.75) return PuruState.good;
    if (hydrationPercent >= 0.50) return PuruState.okay;
    if (hydrationPercent >= 0.25) return PuruState.thirsty;
    return PuruState.dehydrated;
  }

  /// Check if a skin is unlocked
  bool hasSkin(String skinId) => unlockedSkins.contains(skinId);

  /// Check if a buddy is unlocked
  bool hasBuddy(String buddyId) => unlockedBuddies.contains(buddyId);

  /// Check if a badge is earned
  bool hasBadge(String badgeId) => badges.any((b) => b.id == badgeId);

  /// Unlock a new skin
  BuddyStatus unlockSkin(String skinId) {
    if (hasSkin(skinId)) return this;
    return copyWith(
      unlockedSkins: [...unlockedSkins, skinId],
      updatedAt: DateTime.now(),
    );
  }

  /// Unlock a new buddy
  BuddyStatus unlockBuddy(String buddyId) {
    if (hasBuddy(buddyId)) return this;
    return copyWith(
      unlockedBuddies: [...unlockedBuddies, buddyId],
      updatedAt: DateTime.now(),
    );
  }

  /// Earn a badge
  BuddyStatus earnBadge(Badge badge) {
    if (hasBadge(badge.id)) return this;
    return copyWith(
      badges: [...badges, badge],
      updatedAt: DateTime.now(),
    );
  }

  /// Add points
  BuddyStatus addPoints(int points) {
    return copyWith(
      totalPoints: totalPoints + points,
      updatedAt: DateTime.now(),
    );
  }

  /// Equip a skin
  BuddyStatus equipSkin(String skinId) {
    if (!hasSkin(skinId)) return this;
    return copyWith(
      currentSkin: skinId,
      updatedAt: DateTime.now(),
    );
  }

  BuddyStatus copyWith({
    String? userId,
    String? buddyType,
    String? currentSkin,
    List<String>? unlockedSkins,
    List<String>? unlockedBuddies,
    List<Badge>? badges,
    int? totalPoints,
    DateTime? updatedAt,
  }) {
    return BuddyStatus(
      userId: userId ?? this.userId,
      buddyType: buddyType ?? this.buddyType,
      currentSkin: currentSkin ?? this.currentSkin,
      unlockedSkins: unlockedSkins ?? this.unlockedSkins,
      unlockedBuddies: unlockedBuddies ?? this.unlockedBuddies,
      badges: badges ?? this.badges,
      totalPoints: totalPoints ?? this.totalPoints,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        buddyType,
        currentSkin,
        unlockedSkins,
        unlockedBuddies,
        badges,
        totalPoints,
        updatedAt,
      ];
}

/// Puru visual state
enum PuruState {
  hydrated,    // 100%+ - Glowing, happy
  good,        // 75-99% - Normal, content
  okay,        // 50-74% - Slight concern
  thirsty,     // 25-49% - Deflated, worried
  dehydrated,  // 0-24% - Melting, sad
  sleeping,    // During sleep hours
  overHydrated; // Way over 100%

  String get animationName {
    switch (this) {
      case PuruState.hydrated:
        return 'puru_hydrated';
      case PuruState.good:
        return 'puru_good';
      case PuruState.okay:
        return 'puru_okay';
      case PuruState.thirsty:
        return 'puru_thirsty';
      case PuruState.dehydrated:
        return 'puru_dehydrated';
      case PuruState.sleeping:
        return 'puru_sleeping';
      case PuruState.overHydrated:
        return 'puru_overhydrated';
    }
  }

  String get messageVi {
    switch (this) {
      case PuruState.hydrated:
        return 'Tuyệt vời! Bạn đã đạt mục tiêu! 🎉';
      case PuruState.good:
        return 'Rất tốt! Còn một chút nữa thôi!';
      case PuruState.okay:
        return 'Cố lên! Bạn đang làm tốt lắm!';
      case PuruState.thirsty:
        return 'Hơi khát rồi... uống nước đi nào!';
      case PuruState.dehydrated:
        return 'Ối, cần uống nước gấp!';
      case PuruState.sleeping:
        return 'Zzz... Hẹn gặp bạn sáng mai!';
      case PuruState.overHydrated:
        return 'Wow! Bạn uống nhiều quá đấy! 😅';
    }
  }
}

/// Achievement badge
class Badge extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final DateTime earnedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.earnedAt,
  });

  @override
  List<Object?> get props => [id, name, description, iconUrl, earnedAt];
}

