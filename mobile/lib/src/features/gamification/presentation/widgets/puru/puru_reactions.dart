import 'dart:math' as math;

import 'puru_state.dart';

/// Puru reaction messages and behaviors
class PuruReactions {
  PuruReactions._();
  
  static final _random = math.Random();
  
  /// Get a random greeting message based on time of day
  static String getGreeting(DateTime now, double hydrationPercent) {
    final hour = now.hour;
    
    if (hour >= 5 && hour < 12) {
      // Morning
      return _pickRandom(_morningGreetings);
    } else if (hour >= 12 && hour < 17) {
      // Afternoon
      return _pickRandom(_afternoonGreetings);
    } else if (hour >= 17 && hour < 21) {
      // Evening
      return _pickRandom(_eveningGreetings);
    } else {
      // Night
      return _pickRandom(_nightGreetings);
    }
  }
  
  /// Get reaction message when user logs water
  static String getLogReaction(int volumeMl, double newHydrationPercent) {
    if (newHydrationPercent >= 1.0) {
      return _pickRandom(_goalReachedReactions);
    } else if (volumeMl >= 500) {
      return _pickRandom(_bigDrinkReactions);
    } else if (volumeMl >= 250) {
      return _pickRandom(_normalDrinkReactions);
    } else {
      return _pickRandom(_smallDrinkReactions);
    }
  }
  
  /// Get encouragement based on current hydration level
  static String getEncouragement(double hydrationPercent) {
    if (hydrationPercent >= 1.0) {
      return _pickRandom(_excellentEncouragements);
    } else if (hydrationPercent >= 0.75) {
      return _pickRandom(_goodEncouragements);
    } else if (hydrationPercent >= 0.5) {
      return _pickRandom(_okayEncouragements);
    } else if (hydrationPercent >= 0.25) {
      return _pickRandom(_lowEncouragements);
    } else {
      return _pickRandom(_criticalEncouragements);
    }
  }
  
  /// Get streak message
  static String getStreakMessage(int streakDays) {
    if (streakDays == 0) {
      return "Hãy bắt đầu chuỗi mới hôm nay! 🌱";
    } else if (streakDays == 1) {
      return "Ngày đầu tiên! Tuyệt vời! 🎉";
    } else if (streakDays < 7) {
      return "Chuỗi $streakDays ngày! Cố lên! 💪";
    } else if (streakDays < 30) {
      return "Wow! $streakDays ngày liên tiếp! 🔥";
    } else if (streakDays < 100) {
      return "Siêu sao! $streakDays ngày! 🌟";
    } else {
      return "Huyền thoại! $streakDays ngày! 👑";
    }
  }
  
  /// Get weather-related message
  static String getWeatherMessage(double tempC, double humidity) {
    if (tempC > 35) {
      return "Nóng quá! Puru cần nhiều nước hơn! ☀️";
    } else if (tempC > 30) {
      return "Trời nắng đẹp! Nhớ uống nước nhé! 🌤️";
    } else if (humidity < 40) {
      return "Không khí khô quá! Bổ sung nước thôi! 💨";
    } else if (tempC < 15) {
      return "Trời lạnh nhưng vẫn cần nước nhé! 🧣";
    }
    return "Thời tiết đẹp quá! 🌈";
  }
  
  /// Get activity-related message
  static String getActivityMessage(int activeMinutes) {
    if (activeMinutes > 60) {
      return "Vận động nhiều quá! Bù nước ngay! 🏃‍♂️";
    } else if (activeMinutes > 30) {
      return "Tập luyện tốt lắm! Nhớ uống nước! 💪";
    } else if (activeMinutes > 0) {
      return "Đã vận động rồi! Thưởng cho mình 1 cốc! 🎯";
    }
    return "Hãy vận động và uống nước nhé! 🌟";
  }
  
  /// Get tap reaction
  static String getTapReaction() {
    return _pickRandom(_tapReactions);
  }
  
  /// Get long press reaction
  static String getLongPressReaction() {
    return _pickRandom(_longPressReactions);
  }
  
  /// Get idle message (when user hasn't interacted for a while)
  static String getIdleMessage(Duration idleTime) {
    if (idleTime.inMinutes > 60) {
      return _pickRandom(_longIdleMessages);
    } else if (idleTime.inMinutes > 30) {
      return _pickRandom(_mediumIdleMessages);
    }
    return _pickRandom(_shortIdleMessages);
  }
  
  /// Get expression based on state
  static PuruExpression getExpressionForState(
    PuruHydrationState hydrationState,
    PuruAction action,
  ) {
    switch (action) {
      case PuruAction.drink:
        return PuruExpression.joyful;
      case PuruAction.bounce:
      case PuruAction.spin:
        return PuruExpression.excited;
      case PuruAction.hiccup:
        return PuruExpression.dizzy;
      case PuruAction.sleep:
        return PuruExpression.sleepy;
      case PuruAction.melt:
        return PuruExpression.sad;
      case PuruAction.deflate:
        return PuruExpression.worried;
      default:
        break;
    }
    
    switch (hydrationState) {
      case PuruHydrationState.hydrated:
        return PuruExpression.joyful;
      case PuruHydrationState.good:
        return PuruExpression.happy;
      case PuruHydrationState.okay:
        return PuruExpression.happy;
      case PuruHydrationState.thirsty:
        return PuruExpression.worried;
      case PuruHydrationState.dehydrated:
        return PuruExpression.sad;
      case PuruHydrationState.overHydrated:
        return PuruExpression.dizzy;
      case PuruHydrationState.sleeping:
        return PuruExpression.sleepy;
    }
  }
  
  static String _pickRandom(List<String> messages) {
    return messages[_random.nextInt(messages.length)];
  }
  
  // Message collections
  static const _morningGreetings = [
    "Chào buổi sáng! ☀️ Uống nước đi nào!",
    "Ngày mới tuyệt vời! Nạp năng lượng thôi! 🌅",
    "Good morning! Puru đã sẵn sàng! 💧",
    "Khởi động ngày mới với 1 cốc nước nhé! 🌞",
  ];
  
  static const _afternoonGreetings = [
    "Buổi chiều vui vẻ! 🌤️",
    "Đã đến giờ nghỉ ngơi và uống nước! ☕",
    "Chiều rồi! Kiểm tra lượng nước nào! 💦",
    "Halfway through! Cố lên! 🎯",
  ];
  
  static const _eveningGreetings = [
    "Buổi tối thư giãn! 🌙",
    "Gần xong rồi! Chút nữa thôi! ✨",
    "Tối nay bạn làm tốt lắm! 🌟",
    "Evening check! Còn thiếu bao nhiêu? 🤔",
  ];
  
  static const _nightGreetings = [
    "Khuya rồi! Nghỉ ngơi thôi! 😴",
    "Zzz... Puru buồn ngủ quá... 💤",
    "Uống 1 ít nước rồi ngủ nhé! 🌜",
    "Đêm khuya! Nhớ ngủ sớm! 🛏️",
  ];
  
  static const _goalReachedReactions = [
    "YAYYY! Đạt mục tiêu rồi! 🎉🎊",
    "Tuyệt vời! Bạn là ngôi sao! ⭐",
    "100%! Puru tự hào về bạn! 🏆",
    "CHAMPION! Goal completed! 👑",
    "Xuất sắc! Cơ thể đang cảm ơn bạn đó! 💪",
  ];
  
  static const _bigDrinkReactions = [
    "Wow! Uống khỏe thế! 💪",
    "Big gulp! Tuyệt vời! 🌊",
    "Hydration boost! Nice! 💧💧",
    "Khủng! Puru thích điều này! 😍",
  ];
  
  static const _normalDrinkReactions = [
    "Tốt lắm! +1 cốc! ✓",
    "Nice! Cứ thế nhé! 👍",
    "Good job! Tiếp tục nào! 💙",
    "Puru vui quá! 😊",
    "Đã ghi nhận! Keep going! 📝",
  ];
  
  static const _smallDrinkReactions = [
    "Cũng tốt thôi! Mỗi giọt đều quý! 💧",
    "A little sip! Nice! 🤏",
    "Nhỏ nhưng có võ! 😄",
    "Every drop counts! ✨",
  ];
  
  static const _excellentEncouragements = [
    "Bạn là tấm gương về hydration! 🏆",
    "Perfect! Cứ duy trì nhé! 💯",
    "Puru hạnh phúc nhất hôm nay! 🌟",
  ];
  
  static const _goodEncouragements = [
    "Sắp đạt goal rồi! Cố lên! 🎯",
    "Chỉ còn một chút nữa thôi! 💪",
    "You're doing great! 👏",
  ];
  
  static const _okayEncouragements = [
    "Halfway there! Tiếp tục nào! 🚀",
    "50%! Cố gắng thêm nhé! 💧",
    "Còn nửa ngày! Bạn làm được! 💙",
  ];
  
  static const _lowEncouragements = [
    "Puru hơi lo... Uống nước đi! 😟",
    "Cơ thể cần nước đó! 💦",
    "Đừng quên Puru nhé! 🙏",
  ];
  
  static const _criticalEncouragements = [
    "SOS! Puru sắp khô héo mất! 🆘",
    "Khẩn cấp! Cần nước ngay! 💧",
    "Help! Puru cần bạn! 😢",
  ];
  
  static const _tapReactions = [
    "Hehe! Nhột quá! 😆",
    "Hi hi! 👋",
    "Bloop bloop! 💦",
    "Có chuyện gì không? 🤔",
    "*Boing* 🔵",
    "Xin chào! 😊",
  ];
  
  static const _longPressReactions = [
    "Ôi! Bạn đang ôm Puru! 🥰",
    "Warm hug! 💙",
    "Aww! Puru thích! 😍",
    "Squeeze! *happy bubble sounds* 💕",
  ];
  
  static const _shortIdleMessages = [
    "Làm gì đó? 🤔",
    "Puru ở đây nè! 👋",
    "Hello? 👀",
  ];
  
  static const _mediumIdleMessages = [
    "Bạn quên Puru rồi sao? 😢",
    "Nhớ uống nước nhé! 💧",
    "Puru đang chờ... ⏰",
  ];
  
  static const _longIdleMessages = [
    "Bạn đâu rồiiiii? 😭",
    "Puru buồn quá... 💔",
    "Đã lâu không gặp! Miss you! 🥺",
  ];
}

