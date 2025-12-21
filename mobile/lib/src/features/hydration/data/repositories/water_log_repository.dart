import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/bhi_constants.dart';
import '../../domain/entities/water_log.dart';
import '../models/water_log_model.dart';

/// Repository for water logs with offline-first support
class WaterLogRepository {
  final Isar _isar;
  final SupabaseClient _supabase;

  WaterLogRepository({
    required Isar isar,
    required SupabaseClient supabase,
  })  : _isar = isar,
        _supabase = supabase;

  /// Get all logs for today
  Future<List<WaterLog>> getTodayLogs(String userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final models = await _isar.waterLogModels
        .filter()
        .userIdEqualTo(userId)
        .loggedAtBetween(startOfDay, endOfDay)
        .sortByLoggedAt()
        .findAll();

    return models.map((WaterLogModel m) => m.toEntity()).toList();
  }

  /// Get logs for a specific date range
  Future<List<WaterLog>> getLogsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final models = await _isar.waterLogModels
        .filter()
        .userIdEqualTo(userId)
        .loggedAtBetween(startDate, endDate)
        .sortByLoggedAt()
        .findAll();

    return models.map((WaterLogModel m) => m.toEntity()).toList();
  }

  /// Add a new water log (offline-first)
  Future<WaterLog> addLog({
    required String userId,
    required BeverageType beverageType,
    required int volumeMl,
    DateTime? loggedAt,
  }) async {
    // Create the log entity
    final log = WaterLog.create(
      logId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      beverageType: beverageType,
      volumeMl: volumeMl,
      loggedAt: loggedAt,
    );

    // Save to local database immediately
    final model = WaterLogModel.fromEntity(log);
    await _isar.writeTxn(() async {
      await _isar.waterLogModels.put(model);
    });

    // Queue for sync (will be synced by SyncManager)
    return log;
  }

  /// Delete a water log
  Future<void> deleteLog(String logId) async {
    await _isar.writeTxn(() async {
      await _isar.waterLogModels.filter().logIdEqualTo(logId).deleteFirst();
    });

    // Also try to delete from server if online
    try {
      await _supabase.from('water_logs').delete().eq('log_id', logId);
    } catch (_) {
      // Silently fail, will be handled by sync
    }
  }

  /// Get logs that need to be synced
  Future<List<WaterLogModel>> getUnsyncedLogs() async {
    return await _isar.waterLogModels
        .filter()
        .syncedAtIsNull()
        .findAll();
  }

  /// Sync a log to the server
  Future<void> syncLog(WaterLogModel model) async {
    try {
      await _supabase.from('water_logs').upsert(model.toJson());

      // Mark as synced
      model.syncedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.waterLogModels.put(model);
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Sync all unsynced logs
  Future<int> syncAllLogs() async {
    final unsyncedLogs = await getUnsyncedLogs();
    int syncedCount = 0;

    for (final log in unsyncedLogs) {
      try {
        await syncLog(log);
        syncedCount++;
      } catch (_) {
        // Continue with other logs
      }
    }

    return syncedCount;
  }

  /// Fetch and merge logs from server
  Future<void> fetchFromServer(String userId, {DateTime? since}) async {
    try {
      var query = _supabase
          .from('water_logs')
          .select()
          .eq('user_id', userId);

      if (since != null) {
        query = query.gte('synced_at', since.toUtc().toIso8601String());
      }

      final response = await query;

      if (response.isNotEmpty) {
        await _isar.writeTxn(() async {
          for (final json in response) {
            final model = WaterLogModel.fromJson(json);
            await _isar.waterLogModels.put(model);
          }
        });
      }
    } catch (_) {
      // Silently fail, data already in local DB
    }
  }

  /// Get total hydration for today
  Future<int> getTodayTotalHydration(String userId) async {
    final logs = await getTodayLogs(userId);
    return logs.fold<int>(0, (int sum, WaterLog log) => sum + log.hydrationMl);
  }

  /// Get log count for today
  Future<int> getTodayLogCount(String userId) async {
    final logs = await getTodayLogs(userId);
    return logs.length;
  }
}

