import 'package:isar/isar.dart';

import '../../../../core/constants/bhi_constants.dart';
import '../../domain/entities/water_log.dart';

part 'water_log_model.g.dart';

/// Isar model for WaterLog entity
@collection
class WaterLogModel {
  WaterLogModel();

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String logId;

  @Index()
  late String userId;

  @Index()
  late DateTime loggedAt;

  @enumerated
  late BeverageTypeModel beverageType;

  late int volumeMl;
  late double bhiFactor;
  late int hydrationMl;

  DateTime? syncedAt;
  late DateTime createdAt;

  /// Whether this log needs to be synced to server
  bool get needsSync => syncedAt == null;

  /// Convert to domain entity
  WaterLog toEntity() {
    return WaterLog(
      logId: logId,
      userId: userId,
      loggedAt: loggedAt,
      beverageType: beverageType.toBeverageType(),
      volumeMl: volumeMl,
      bhiFactor: bhiFactor,
      hydrationMl: hydrationMl,
      syncedAt: syncedAt,
      createdAt: createdAt,
    );
  }

  /// Create from domain entity
  static WaterLogModel fromEntity(WaterLog entity) {
    return WaterLogModel()
      ..logId = entity.logId
      ..userId = entity.userId
      ..loggedAt = entity.loggedAt
      ..beverageType = BeverageTypeModel.fromBeverageType(entity.beverageType)
      ..volumeMl = entity.volumeMl
      ..bhiFactor = entity.bhiFactor
      ..hydrationMl = entity.hydrationMl
      ..syncedAt = entity.syncedAt
      ..createdAt = entity.createdAt;
  }

  /// Create from Supabase JSON
  factory WaterLogModel.fromJson(Map<String, dynamic> json) {
    return WaterLogModel()
      ..logId = json['log_id'] as String
      ..userId = json['user_id'] as String
      ..loggedAt = DateTime.parse(json['logged_at'] as String)
      ..beverageType = BeverageTypeModel.values.firstWhere(
        (e) => e.name == json['beverage_type'],
        orElse: () => BeverageTypeModel.water,
      )
      ..volumeMl = json['volume_ml'] as int
      ..bhiFactor = (json['bhi_factor'] as num).toDouble()
      ..hydrationMl = (json['hydration_ml'] as num).toInt()
      ..syncedAt = json['synced_at'] != null
          ? DateTime.parse(json['synced_at'] as String)
          : null
      ..createdAt = DateTime.parse(json['created_at'] as String);
  }

  /// Convert to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'log_id': logId,
      'user_id': userId,
      'logged_at': loggedAt.toUtc().toIso8601String(),
      'beverage_type': beverageType.name,
      'volume_ml': volumeMl,
      'bhi_factor': bhiFactor,
      'hydration_ml': hydrationMl,
      'synced_at': syncedAt?.toUtc().toIso8601String(),
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}

/// Enum model for Isar storage
enum BeverageTypeModel {
  water,
  sparklingWater,
  milk,
  coconutWater,
  tea,
  coffee,
  juice,
  soda,
  alcohol,
  energyDrink,
  other;

  BeverageType toBeverageType() {
    switch (this) {
      case BeverageTypeModel.water:
        return BeverageType.water;
      case BeverageTypeModel.sparklingWater:
        return BeverageType.sparklingWater;
      case BeverageTypeModel.milk:
        return BeverageType.milk;
      case BeverageTypeModel.coconutWater:
        return BeverageType.coconutWater;
      case BeverageTypeModel.tea:
        return BeverageType.tea;
      case BeverageTypeModel.coffee:
        return BeverageType.coffee;
      case BeverageTypeModel.juice:
        return BeverageType.juice;
      case BeverageTypeModel.soda:
        return BeverageType.soda;
      case BeverageTypeModel.alcohol:
        return BeverageType.alcohol;
      case BeverageTypeModel.energyDrink:
        return BeverageType.energyDrink;
      case BeverageTypeModel.other:
        return BeverageType.other;
    }
  }

  static BeverageTypeModel fromBeverageType(BeverageType type) {
    switch (type) {
      case BeverageType.water:
        return BeverageTypeModel.water;
      case BeverageType.sparklingWater:
        return BeverageTypeModel.sparklingWater;
      case BeverageType.milk:
        return BeverageTypeModel.milk;
      case BeverageType.coconutWater:
        return BeverageTypeModel.coconutWater;
      case BeverageType.tea:
        return BeverageTypeModel.tea;
      case BeverageType.coffee:
        return BeverageTypeModel.coffee;
      case BeverageType.juice:
        return BeverageTypeModel.juice;
      case BeverageType.soda:
        return BeverageTypeModel.soda;
      case BeverageType.alcohol:
        return BeverageTypeModel.alcohol;
      case BeverageType.energyDrink:
        return BeverageTypeModel.energyDrink;
      case BeverageType.other:
        return BeverageTypeModel.other;
    }
  }
}

