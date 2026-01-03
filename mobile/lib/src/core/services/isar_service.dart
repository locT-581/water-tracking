import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/hydration/data/models/daily_goal_model.dart';
import '../../features/hydration/data/models/water_log_model.dart';

/// Service for managing Isar database
class IsarService {
  static Isar? _isar;
  
  /// Get the Isar instance (singleton)
  static Isar? get instance => _isar;
  
  /// Check if Isar is initialized
  static bool get isInitialized => _isar != null;
  
  /// Initialize Isar database
  /// Must be called before using any database operations
  static Future<Isar> initialize() async {
    if (_isar != null) {
      return _isar!;
    }
    
    final dir = await getApplicationDocumentsDirectory();
    
    _isar = await Isar.open(
      [
        DailyGoalModelSchema,
        WaterLogModelSchema,
      ],
      directory: dir.path,
      name: 'smarthydro',
    );
    
    return _isar!;
  }
  
  /// Close database
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
  
  /// Clear all data (for testing/development)
  static Future<void> clearAll() async {
    if (_isar == null) return;
    
    await _isar!.writeTxn(() async {
      await _isar!.clear();
    });
  }
}

