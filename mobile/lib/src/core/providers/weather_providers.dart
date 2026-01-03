import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/weather_service.dart';

/// WeatherService provider
final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

/// Current weather data provider
/// Auto-refreshes when accessed and cache is stale
/// Has auto-refresh mechanism
final currentWeatherProvider = FutureProvider.autoDispose<WeatherData?>((ref) async {
  final weatherService = ref.watch(weatherServiceProvider);
  
  // Keep provider alive for 5 minutes to prevent refetching
  final link = ref.keepAlive();
  Future.delayed(const Duration(minutes: 5), () => link.close());
  
  return await weatherService.getCurrentWeather();
});

/// Weather adjustment info for display
final weatherAdjustmentInfoProvider = Provider<WeatherAdjustmentInfo>((ref) {
  final weatherAsync = ref.watch(currentWeatherProvider);
  
  return weatherAsync.when(
    data: (weather) {
      if (weather == null) {
        return const WeatherAdjustmentInfo(
          hasData: false,
          temperature: null,
          humidity: null,
          adjustmentMl: 0,
          adjustmentReason: null,
        );
      }
      
      // Calculate adjustment reason
      String? reason;
      int adjustmentPercent = 0;
      
      if (weather.isVeryHot) {
        adjustmentPercent = 15;
        reason = 'Trời rất nóng';
      } else if (weather.isHot) {
        adjustmentPercent = 10;
        reason = 'Trời nóng';
      }
      
      if (weather.isDry) {
        adjustmentPercent += 5;
        reason = reason != null 
            ? '$reason & khô' 
            : 'Độ ẩm thấp';
      }
      
      return WeatherAdjustmentInfo(
        hasData: true,
        temperature: weather.temperatureC,
        humidity: weather.humidityPercent,
        adjustmentMl: 0, // Will be set by goal provider
        adjustmentPercent: adjustmentPercent,
        adjustmentReason: reason,
        description: weather.description,
        icon: weather.icon,
      );
    },
    loading: () => const WeatherAdjustmentInfo(
      hasData: false,
      isLoading: true,
    ),
    error: (_, __) => const WeatherAdjustmentInfo(
      hasData: false,
      hasError: true,
    ),
  );
});

/// Weather adjustment info model
class WeatherAdjustmentInfo {
  final bool hasData;
  final bool isLoading;
  final bool hasError;
  final double? temperature;
  final double? humidity;
  final int adjustmentMl;
  final int adjustmentPercent;
  final String? adjustmentReason;
  final String? description;
  final String? icon;

  const WeatherAdjustmentInfo({
    this.hasData = false,
    this.isLoading = false,
    this.hasError = false,
    this.temperature,
    this.humidity,
    this.adjustmentMl = 0,
    this.adjustmentPercent = 0,
    this.adjustmentReason,
    this.description,
    this.icon,
  });

  /// Get weather icon for display
  String get weatherEmoji {
    if (!hasData || icon == null) return '🌤️';
    
    // OpenWeatherMap icon codes
    switch (icon) {
      case '01d': return '☀️'; // clear day
      case '01n': return '🌙'; // clear night
      case '02d':
      case '02n': return '⛅'; // few clouds
      case '03d':
      case '03n': return '☁️'; // scattered clouds
      case '04d':
      case '04n': return '☁️'; // broken clouds
      case '09d':
      case '09n': return '🌧️'; // shower rain
      case '10d':
      case '10n': return '🌦️'; // rain
      case '11d':
      case '11n': return '⛈️'; // thunderstorm
      case '13d':
      case '13n': return '❄️'; // snow
      case '50d':
      case '50n': return '🌫️'; // mist
      default: return '🌤️';
    }
  }

  /// Get formatted temperature string
  String get temperatureString {
    if (temperature == null) return '--°C';
    return '${temperature!.round()}°C';
  }

  /// Get adjustment display text
  String? get adjustmentDisplayText {
    if (adjustmentMl > 0) {
      return '+${adjustmentMl}ml';
    }
    if (adjustmentPercent > 0) {
      return '+$adjustmentPercent%';
    }
    return null;
  }
}

