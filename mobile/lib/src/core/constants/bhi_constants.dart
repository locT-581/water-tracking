/// Beverage Hydration Index (BHI) Constants
/// Based on scientific research on how different beverages hydrate the body
library;

import 'package:flutter/material.dart';

enum BeverageType {
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
  other,
}

/// BHI factors for each beverage type
/// 1.0 = same hydration as water
/// >1.0 = better hydration (contains electrolytes)
/// <1.0 = less hydration (diuretic effect)
const Map<BeverageType, double> bhiFactors = {
  BeverageType.water: 1.00,
  BeverageType.sparklingWater: 0.95,
  BeverageType.milk: 1.10,
  BeverageType.coconutWater: 1.15,
  BeverageType.tea: 0.90,
  BeverageType.coffee: 0.85,
  BeverageType.juice: 0.80,
  BeverageType.soda: 0.70,
  BeverageType.alcohol: 0.50,
  BeverageType.energyDrink: 0.60,
  BeverageType.other: 1.00,
};

/// Human-readable names for beverages
const Map<BeverageType, String> beverageNames = {
  BeverageType.water: 'Nước lọc',
  BeverageType.sparklingWater: 'Nước có gas',
  BeverageType.milk: 'Sữa',
  BeverageType.coconutWater: 'Nước dừa',
  BeverageType.tea: 'Trà',
  BeverageType.coffee: 'Cà phê',
  BeverageType.juice: 'Nước ép',
  BeverageType.soda: 'Nước ngọt',
  BeverageType.alcohol: 'Rượu/Bia',
  BeverageType.energyDrink: 'Nước tăng lực',
  BeverageType.other: 'Khác',
};

/// English names for beverages
const Map<BeverageType, String> beverageNamesEn = {
  BeverageType.water: 'Water',
  BeverageType.sparklingWater: 'Sparkling Water',
  BeverageType.milk: 'Milk',
  BeverageType.coconutWater: 'Coconut Water',
  BeverageType.tea: 'Tea',
  BeverageType.coffee: 'Coffee',
  BeverageType.juice: 'Juice',
  BeverageType.soda: 'Soda',
  BeverageType.alcohol: 'Alcohol',
  BeverageType.energyDrink: 'Energy Drink',
  BeverageType.other: 'Other',
};

/// Icons for beverages (Material Icons names)
const Map<BeverageType, String> beverageIcons = {
  BeverageType.water: 'water_drop',
  BeverageType.sparklingWater: 'bubble_chart',
  BeverageType.milk: 'local_cafe',
  BeverageType.coconutWater: 'eco',
  BeverageType.tea: 'emoji_food_beverage',
  BeverageType.coffee: 'coffee',
  BeverageType.juice: 'local_bar',
  BeverageType.soda: 'local_drink',
  BeverageType.alcohol: 'wine_bar',
  BeverageType.energyDrink: 'bolt',
  BeverageType.other: 'local_drink',
};

/// Tips for low-hydration beverages
const Map<BeverageType, String> beverageTips = {
  BeverageType.coffee: 'Cà phê làm bạn mất nước nhẹ, nhớ uống thêm nước lọc nhé!',
  BeverageType.tea: 'Trà có tác dụng lợi tiểu nhẹ, hãy bổ sung thêm nước.',
  BeverageType.soda: 'Nước ngọt chứa nhiều đường, hạn chế sử dụng nhé!',
  BeverageType.alcohol: '⚠️ Rượu bia gây mất nước nghiêm trọng!',
  BeverageType.energyDrink: '⚠️ Caffeine cao, uống có chừng mực!',
  BeverageType.juice: 'Nước ép chứa nhiều đường tự nhiên, uống vừa phải.',
};

/// Extension methods for BeverageType
extension BeverageTypeExtension on BeverageType {
  double get bhi => bhiFactors[this] ?? 1.0;
  String get nameVi => beverageNames[this] ?? 'Khác';
  String get nameEn => beverageNamesEn[this] ?? 'Other';
  String get iconName => beverageIcons[this] ?? 'local_drink';
  String? get tip => beverageTips[this];
  bool get hasWarning => bhi < 0.7;

  /// Get Material Icon for this beverage type
  IconData get icon {
    switch (this) {
      case BeverageType.water:
        return Icons.water_drop;
      case BeverageType.sparklingWater:
        return Icons.bubble_chart;
      case BeverageType.milk:
        return Icons.local_cafe;
      case BeverageType.coconutWater:
        return Icons.eco;
      case BeverageType.tea:
        return Icons.emoji_food_beverage;
      case BeverageType.coffee:
        return Icons.coffee;
      case BeverageType.juice:
        return Icons.local_bar;
      case BeverageType.soda:
        return Icons.local_drink;
      case BeverageType.alcohol:
        return Icons.wine_bar;
      case BeverageType.energyDrink:
        return Icons.bolt;
      case BeverageType.other:
        return Icons.local_drink;
    }
  }

  /// Calculate actual hydration value
  int calculateHydration(int volumeMl) {
    return (volumeMl * bhi).round();
  }
}

