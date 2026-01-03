import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/bhi_constants.dart';
import '../../domain/entities/water_log.dart';
import '../models/water_log_model.dart';

/// Repository for managing WaterLog data
///
/// Handles:
/// - Creating new water logs
/// - Loading logs for a day/range
/// - Deleting logs (undo)
/// - Sync queue management
class WaterLogRepository {
  final Isar _isar;
  final String? _userId;

  WaterLogRepository({
    required Isar isar,
    String? userId,
  })  : _isar = isar,
        _userId = userId;

  String get _effectiveUserId => _userId ?? 'guest';

  /// Generate unique log ID
  String _generateLogId() {
    return const Uuid().v4();
  }

  // ============== CREATE OPERATIONS ==============

  /// Create a new water log
  Future<WaterLog> createLog({
    required BeverageType beverageType,
    required int volumeMl,
    DateTime? loggedAt,
  }) async {
    final log = WaterLog.create(
      logId: _generateLogId(),
      userId: _effectiveUserId,
      beverageType: beverageType,
      volumeMl: volumeMl,
      loggedAt: loggedAt,
    );

    final model = WaterLogModel.fromEntity(log);

    await _isar.writeTxn(() async {
      await _isar.waterLogModels.put(model);
    });

    return log;
  }

  // ============== READ OPERATIONS ==============

  /// Get all logs for today
  Future<List<WaterLog>> getTodayLogs() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getLogsInRange(startOfDay, endOfDay);
  }

  /// Get logs for a specific date
  Future<List<WaterLog>> getLogsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getLogsInRange(startOfDay, endOfDay);
  }

  /// Get logs in a date range
  Future<List<WaterLog>> getLogsInRange(DateTime start, DateTime end) async {
    final models = await _isar.waterLogModels
        .filter()
        .userIdEqualTo(_effectiveUserId)
        .loggedAtBetween(start, end)
        .sortByLoggedAt()
        .findAll();

    return models.map((m) => m.toEntity()).toList();
  }

  /// Get a specific log by ID
  Future<WaterLog?> getLogById(String logId) async {
    final model = await _isar.waterLogModels
        .filter()
        .logIdEqualTo(logId)
        .findFirst();

    return model?.toEntity();
  }

  /// Get total hydration for today
  Future<int> getTodayTotalHydration() async {
    final logs = await getTodayLogs();
    return logs.fold<int>(0, (sum, log) => sum + log.hydrationMl);
  }

  /// Get total hydration for a date
  Future<int> getTotalHydrationForDate(DateTime date) async {
    final logs = await getLogsForDate(date);
    return logs.fold<int>(0, (sum, log) => sum + log.hydrationMl);
  }

  /// Get logs that need to be synced
  Future<List<WaterLog>> getUnsyncedLogs() async {
    final models = await _isar.waterLogModels
        .filter()
        .userIdEqualTo(_effectiveUserId)
        .syncedAtIsNull()
        .findAll();

    return models.map((m) => m.toEntity()).toList();
  }

  /// Get recent logs (last N entries)
  Future<List<WaterLog>> getRecentLogs(int count) async {
    final models = await _isar.waterLogModels
        .filter()
        .userIdEqualTo(_effectiveUserId)
        .sortByLoggedAtDesc()
        .limit(count)
        .findAll();

    return models.map((m) => m.toEntity()).toList();
  }

  /// Get last log (for undo)
  Future<WaterLog?> getLastLog() async {
    final logs = await getRecentLogs(1);
    return logs.isNotEmpty ? logs.first : null;
  }

  // ============== UPDATE OPERATIONS ==============

  /// Mark log as synced
  Future<void> markAsSynced(String logId) async {
    await _isar.writeTxn(() async {
      final model = await _isar.waterLogModels
          .filter()
          .logIdEqualTo(logId)
          .findFirst();

      if (model != null) {
        model.syncedAt = DateTime.now();
        await _isar.waterLogModels.put(model);
      }
    });
  }

  /// Mark multiple logs as synced
  Future<void> markMultipleAsSynced(List<String> logIds) async {
    await _isar.writeTxn(() async {
      for (final logId in logIds) {
        final model = await _isar.waterLogModels
            .filter()
            .logIdEqualTo(logId)
            .findFirst();

        if (model != null) {
          model.syncedAt = DateTime.now();
          await _isar.waterLogModels.put(model);
        }
      }
    });
  }

  // ============== DELETE OPERATIONS ==============

  /// Delete a log by ID (for undo)
  Future<bool> deleteLog(String logId) async {
    return await _isar.writeTxn(() async {
      final model = await _isar.waterLogModels
          .filter()
          .logIdEqualTo(logId)
          .findFirst();

      if (model != null) {
        return await _isar.waterLogModels.delete(model.id);
      }
      return false;
    });
  }

  /// Delete all logs for a user (for logout/clear data)
  Future<void> deleteAllLogs() async {
    await _isar.writeTxn(() async {
      await _isar.waterLogModels
          .filter()
          .userIdEqualTo(_effectiveUserId)
          .deleteAll();
    });
  }

  // ============== STATISTICS ==============

  /// Get beverage breakdown for a date range
  Future<Map<BeverageType, int>> getBeverageBreakdown(
    DateTime start,
    DateTime end,
  ) async {
    final logs = await getLogsInRange(start, end);
    final breakdown = <BeverageType, int>{};

    for (final log in logs) {
      breakdown[log.beverageType] =
          (breakdown[log.beverageType] ?? 0) + log.hydrationMl;
    }

    return breakdown;
  }

  /// Get average daily hydration for last N days
  Future<double> getAverageDailyHydration(int days) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day - days);
    final end = DateTime(now.year, now.month, now.day + 1);

    final logs = await getLogsInRange(start, end);
    if (logs.isEmpty) return 0;

    final totalHydration = logs.fold(0, (sum, log) => sum + log.hydrationMl);
    return totalHydration / days;
  }

  /// Get daily totals for last N days
  Future<Map<DateTime, int>> getDailyTotals(int days) async {
    final now = DateTime.now();
    final totals = <DateTime, int>{};

    for (var i = 0; i < days; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      final total = await getTotalHydrationForDate(date);
      totals[date] = total;
    }

    return totals;
  }

  // ============== STREAM ==============

  /// Watch today's logs for real-time updates
  Stream<List<WaterLog>> watchTodayLogs() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _isar.waterLogModels
        .filter()
        .userIdEqualTo(_effectiveUserId)
        .loggedAtBetween(startOfDay, endOfDay)
        .sortByLoggedAt()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}
