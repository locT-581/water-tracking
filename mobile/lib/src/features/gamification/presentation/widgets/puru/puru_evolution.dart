import 'package:flutter/material.dart';

/// Evolution stages for Puru buddy
enum PuruEvolutionStage {
  /// Baby/Egg stage (0-6 days streak)
  baby,
  
  /// Toddler stage (7-29 days streak)
  toddler,
  
  /// Youth stage (30-89 days streak)
  youth,
  
  /// Adult stage (90-179 days streak)
  adult,
  
  /// Elder/Wise stage (180+ days streak)
  elder,
  
  /// Legendary stage (365+ days streak)
  legendary,
}

/// Evolution configuration
class PuruEvolution {
  final PuruEvolutionStage stage;
  final String nameVi;
  final String nameEn;
  final String description;
  final int minStreakDays;
  final double sizeMultiplier;
  final double bubbleCount;
  final bool hasHalo;
  final bool hasWings;
  final Color? auraColor;
  
  const PuruEvolution({
    required this.stage,
    required this.nameVi,
    required this.nameEn,
    required this.description,
    required this.minStreakDays,
    this.sizeMultiplier = 1.0,
    this.bubbleCount = 8,
    this.hasHalo = false,
    this.hasWings = false,
    this.auraColor,
  });
}

/// All Puru evolution stages
class PuruEvolutions {
  PuruEvolutions._();
  
  static const baby = PuruEvolution(
    stage: PuruEvolutionStage.baby,
    nameVi: 'Puru Bé Nhỏ',
    nameEn: 'Baby Puru',
    description: 'Mới bắt đầu hành trình hydration!',
    minStreakDays: 0,
    sizeMultiplier: 0.8,
    bubbleCount: 4,
  );
  
  static const toddler = PuruEvolution(
    stage: PuruEvolutionStage.toddler,
    nameVi: 'Puru Tinh Nghịch',
    nameEn: 'Toddler Puru',
    description: 'Đã biết đi và hay tò mò!',
    minStreakDays: 7,
    sizeMultiplier: 0.9,
    bubbleCount: 6,
  );
  
  static const youth = PuruEvolution(
    stage: PuruEvolutionStage.youth,
    nameVi: 'Puru Năng Động',
    nameEn: 'Youth Puru',
    description: 'Tràn đầy năng lượng và sức sống!',
    minStreakDays: 30,
    sizeMultiplier: 1.0,
    bubbleCount: 8,
  );
  
  static const adult = PuruEvolution(
    stage: PuruEvolutionStage.adult,
    nameVi: 'Puru Trưởng Thành',
    nameEn: 'Adult Puru',
    description: 'Khỏe mạnh và đáng tin cậy!',
    minStreakDays: 90,
    sizeMultiplier: 1.1,
    bubbleCount: 10,
    hasHalo: true,
    auraColor: Color(0x332AF598),
  );
  
  static const elder = PuruEvolution(
    stage: PuruEvolutionStage.elder,
    nameVi: 'Puru Hiền Triết',
    nameEn: 'Elder Puru',
    description: 'Thông thái và an nhiên tự tại!',
    minStreakDays: 180,
    sizeMultiplier: 1.15,
    bubbleCount: 12,
    hasHalo: true,
    hasWings: true,
    auraColor: Color(0x4D7C4DFF),
  );
  
  static const legendary = PuruEvolution(
    stage: PuruEvolutionStage.legendary,
    nameVi: 'Puru Huyền Thoại',
    nameEn: 'Legendary Puru',
    description: 'Đạt tới cảnh giới tối cao!',
    minStreakDays: 365,
    sizeMultiplier: 1.2,
    bubbleCount: 15,
    hasHalo: true,
    hasWings: true,
    auraColor: Color(0x66FFD700),
  );
  
  /// Get all evolutions
  static List<PuruEvolution> get all => [
    baby,
    toddler,
    youth,
    adult,
    elder,
    legendary,
  ];
  
  /// Get evolution for streak days
  static PuruEvolution getEvolution(int streakDays) {
    for (final evolution in all.reversed) {
      if (streakDays >= evolution.minStreakDays) {
        return evolution;
      }
    }
    return baby;
  }
  
  /// Get next evolution
  static PuruEvolution? getNextEvolution(int streakDays) {
    for (final evolution in all) {
      if (streakDays < evolution.minStreakDays) {
        return evolution;
      }
    }
    return null; // Already at max
  }
  
  /// Get progress to next evolution (0.0 to 1.0)
  static double getProgressToNext(int streakDays) {
    final current = getEvolution(streakDays);
    final next = getNextEvolution(streakDays);
    
    if (next == null) return 1.0;
    
    final range = next.minStreakDays - current.minStreakDays;
    final progress = streakDays - current.minStreakDays;
    
    return (progress / range).clamp(0.0, 1.0);
  }
  
  /// Get days remaining to next evolution
  static int? getDaysToNextEvolution(int streakDays) {
    final next = getNextEvolution(streakDays);
    if (next == null) return null;
    return next.minStreakDays - streakDays;
  }
}

/// Widget to display evolution progress
class PuruEvolutionProgress extends StatelessWidget {
  final int streakDays;
  final bool showDetails;
  
  const PuruEvolutionProgress({
    super.key,
    required this.streakDays,
    this.showDetails = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final current = PuruEvolutions.getEvolution(streakDays);
    final next = PuruEvolutions.getNextEvolution(streakDays);
    final progress = PuruEvolutions.getProgressToNext(streakDays);
    final daysRemaining = PuruEvolutions.getDaysToNextEvolution(streakDays);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current evolution
          Row(
            children: [
              // Evolution icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      current.auraColor ?? const Color(0xFF4FC3F7),
                      const Color(0xFF2AF598),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getEvolutionEmoji(current.stage),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Evolution name and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current.nameVi,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF051E3E),
                      ),
                    ),
                    if (showDetails)
                      Text(
                        current.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          if (next != null) ...[
            const SizedBox(height: 16),
            
            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tiến hóa tiếp theo: ${next.nameVi}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      'Còn $daysRemaining ngày',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF009EFD),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      next.auraColor ?? const Color(0xFF2AF598),
                    ),
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Progress percentage
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            
            // Max level reached
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Cấp độ tối đa!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  String _getEvolutionEmoji(PuruEvolutionStage stage) {
    switch (stage) {
      case PuruEvolutionStage.baby: return '🥚';
      case PuruEvolutionStage.toddler: return '🫧';
      case PuruEvolutionStage.youth: return '💧';
      case PuruEvolutionStage.adult: return '💎';
      case PuruEvolutionStage.elder: return '🌟';
      case PuruEvolutionStage.legendary: return '👑';
    }
  }
}

/// Evolution timeline widget
class PuruEvolutionTimeline extends StatelessWidget {
  final int currentStreakDays;
  
  const PuruEvolutionTimeline({
    super.key,
    required this.currentStreakDays,
  });
  
  @override
  Widget build(BuildContext context) {
    final evolutions = PuruEvolutions.all;
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: evolutions.length,
        itemBuilder: (context, index) {
          final evolution = evolutions[index];
          final isUnlocked = currentStreakDays >= evolution.minStreakDays;
          final isCurrent = PuruEvolutions.getEvolution(currentStreakDays) == evolution;
          
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                // Evolution circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Connection line
                    if (index > 0)
                      Positioned(
                        left: -50,
                        child: Container(
                          width: 50,
                          height: 2,
                          color: isUnlocked 
                              ? const Color(0xFF2AF598)
                              : Colors.grey.shade300,
                        ),
                      ),
                    
                    // Circle
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? (evolution.auraColor ?? const Color(0xFF4FC3F7))
                            : Colors.grey.shade200,
                        shape: BoxShape.circle,
                        border: isCurrent
                            ? Border.all(
                                color: const Color(0xFF2AF598),
                                width: 3,
                              )
                            : null,
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF2AF598).withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _getStageEmoji(evolution.stage, isUnlocked),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Name
                Text(
                  evolution.nameVi,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isUnlocked
                        ? const Color(0xFF051E3E)
                        : Colors.grey,
                  ),
                ),
                
                // Days requirement
                Text(
                  evolution.minStreakDays == 0
                      ? 'Bắt đầu'
                      : '${evolution.minStreakDays} ngày',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  String _getStageEmoji(PuruEvolutionStage stage, bool isUnlocked) {
    if (!isUnlocked) return '🔒';
    
    switch (stage) {
      case PuruEvolutionStage.baby: return '🥚';
      case PuruEvolutionStage.toddler: return '🫧';
      case PuruEvolutionStage.youth: return '💧';
      case PuruEvolutionStage.adult: return '💎';
      case PuruEvolutionStage.elder: return '🌟';
      case PuruEvolutionStage.legendary: return '👑';
    }
  }
}

