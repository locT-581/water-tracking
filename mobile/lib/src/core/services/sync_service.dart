import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sync status enum
enum SyncStatus {
  idle,
  syncing,
  success,
  error,
}

/// Sync service for offline-first data synchronization
/// Uses Last-Write-Wins strategy for conflict resolution
class SyncService {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _isOnline = false;
  SyncStatus _status = SyncStatus.idle;
  DateTime? _lastSyncTime;

  SyncService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Whether device is online
  bool get isOnline => _isOnline;

  /// Current sync status
  SyncStatus get status => _status;

  /// Last successful sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Initialize connectivity listener
  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _updateOnlineStatus(result);

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateOnlineStatus,
    );
  }

  void _updateOnlineStatus(List<ConnectivityResult> result) {
    _isOnline = result.isNotEmpty && !result.contains(ConnectivityResult.none);

    // Trigger sync when coming online
    if (_isOnline && _status == SyncStatus.idle) {
      // syncAll() would be called here
    }
  }

  /// Perform full sync of all data
  Future<SyncResult> syncAll({
    required Future<int> Function() syncLogs,
    required Future<int> Function() syncGoals,
  }) async {
    if (!_isOnline) {
      return SyncResult(
        success: false,
        message: 'Device is offline',
        logsCount: 0,
        goalsCount: 0,
      );
    }

    _status = SyncStatus.syncing;

    try {
      final logsCount = await syncLogs();
      final goalsCount = await syncGoals();

      _status = SyncStatus.success;
      _lastSyncTime = DateTime.now();

      return SyncResult(
        success: true,
        message: 'Sync completed',
        logsCount: logsCount,
        goalsCount: goalsCount,
      );
    } catch (e) {
      _status = SyncStatus.error;
      return SyncResult(
        success: false,
        message: e.toString(),
        logsCount: 0,
        goalsCount: 0,
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

/// Result of a sync operation
class SyncResult {
  final bool success;
  final String message;
  final int logsCount;
  final int goalsCount;

  const SyncResult({
    required this.success,
    required this.message,
    required this.logsCount,
    required this.goalsCount,
  });

  int get totalCount => logsCount + goalsCount;
}

/// Provider for sync service
final syncServiceProvider = Provider<SyncService>((ref) {
  final service = SyncService();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for online status
final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(syncServiceProvider).isOnline;
});

/// Provider for sync status
final syncStatusProvider = Provider<SyncStatus>((ref) {
  return ref.watch(syncServiceProvider).status;
});

