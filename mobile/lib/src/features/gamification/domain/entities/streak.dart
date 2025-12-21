import 'package:equatable/equatable.dart';

/// User streak entity
class Streak extends Equatable {
  final String usreId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;
  final DateTime updatedAt;

  const Streak({
    required this.usreId,
    required this.currentStreak,
    required this.longestStreak,
    this.lastCompletedDate,
    required this.updatedAt,
  });

  /// Check if streak is active (completed yesterday or today)
  bool get isActive {
    if (lastCompletedDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final lastDate = DateTime(
      lastCompletedDate!.year,
      lastCompletedDate!.month,
      lastCompletedDate!.day,
    );
    return lastDate == today || lastDate == yesterday;
  }

  /// Check if completed today
  bool get completedToday {
    if (lastCompletedDate == null) return false;
    final now = DateTime.now();
    return lastCompletedDate!.year == now.year &&
        lastCompletedDate!.month == now.month &&
        lastCompletedDate!.day == now.day;
  }

  /// Create updated streak when goal is completed
  Streak completeToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Don't increment if already completed today
    if (completedToday) return this;

    // Check if this continues the streak
    int newStreak;
    if (isActive) {
      newStreak = currentStreak + 1;
    } else {
      newStreak = 1; // Start new streak
    }

    return Streak(
      usreId: usreId,
      currentStreak: newStreak,
      longestStreak: newStreak > longestStreak ? newStreak : longestStreak,
      lastCompletedDate: today,
      updatedAt: now,
    );
  }

  /// Reset streak (when goal is missed)
  Streak reset() {
    return Streak(
      usreId: usreId,
      currentStreak: 0,
      longestStreak: longestStreak,
      lastCompletedDate: lastCompletedDate,
      updatedAt: DateTime.now(),
    );
  }

  /// Check if streak milestone is reached
  bool isMilestone(int milestone) {
    return currentStreak == milestone;
  }

  /// Get next milestone
  int getNextMilestone() {
    const milestones = [3, 7, 14, 21, 30, 60, 90, 100, 365];
    for (final m in milestones) {
      if (currentStreak < m) return m;
    }
    return 365;
  }

  Streak copyWith({
    String? usreId,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCompletedDate,
    DateTime? updatedAt,
  }) {
    return Streak(
      usreId: usreId ?? this.usreId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        usreId,
        currentStreak,
        longestStreak,
        lastCompletedDate,
        updatedAt,
      ];
}

