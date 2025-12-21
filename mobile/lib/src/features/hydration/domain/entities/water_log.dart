import 'package:equatable/equatable.dart';

import '../../../../core/constants/bhi_constants.dart';

/// Water log entity representing a single hydration entry
class WaterLog extends Equatable {
  final String logId;
  final String userId;
  final DateTime loggedAt;
  final BeverageType beverageType;
  final int volumeMl;
  final double bhiFactor;
  final int hydrationMl;
  final DateTime? syncedAt;
  final DateTime createdAt;

  const WaterLog({
    required this.logId,
    required this.userId,
    required this.loggedAt,
    required this.beverageType,
    required this.volumeMl,
    required this.bhiFactor,
    required this.hydrationMl,
    this.syncedAt,
    required this.createdAt,
  });

  /// Factory constructor to create a new water log with BHI calculation
  factory WaterLog.create({
    required String logId,
    required String userId,
    required BeverageType beverageType,
    required int volumeMl,
    DateTime? loggedAt,
  }) {
    final bhi = beverageType.bhi;
    return WaterLog(
      logId: logId,
      userId: userId,
      loggedAt: loggedAt ?? DateTime.now(),
      beverageType: beverageType,
      volumeMl: volumeMl,
      bhiFactor: bhi,
      hydrationMl: (volumeMl * bhi).round(),
      syncedAt: null,
      createdAt: DateTime.now(),
    );
  }

  /// Check if log has been synced to server
  bool get isSynced => syncedAt != null;

  /// Get formatted time string
  String get timeString {
    final hour = loggedAt.hour.toString().padLeft(2, '0');
    final minute = loggedAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  WaterLog copyWith({
    String? logId,
    String? userId,
    DateTime? loggedAt,
    BeverageType? beverageType,
    int? volumeMl,
    double? bhiFactor,
    int? hydrationMl,
    DateTime? syncedAt,
    DateTime? createdAt,
  }) {
    return WaterLog(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      loggedAt: loggedAt ?? this.loggedAt,
      beverageType: beverageType ?? this.beverageType,
      volumeMl: volumeMl ?? this.volumeMl,
      bhiFactor: bhiFactor ?? this.bhiFactor,
      hydrationMl: hydrationMl ?? this.hydrationMl,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Mark as synced
  WaterLog markAsSynced() {
    return copyWith(syncedAt: DateTime.now());
  }

  @override
  List<Object?> get props => [
        logId,
        userId,
        loggedAt,
        beverageType,
        volumeMl,
        bhiFactor,
        hydrationMl,
        syncedAt,
        createdAt,
      ];
}

