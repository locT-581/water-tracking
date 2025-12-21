import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/app_constants.dart';

/// Weather data model
class WeatherData {
  final double temperatureC;
  final double humidityPercent;
  final String description;
  final String icon;
  final DateTime fetchedAt;

  const WeatherData({
    required this.temperatureC,
    required this.humidityPercent,
    required this.description,
    required this.icon,
    required this.fetchedAt,
  });

  /// Check if data is still fresh (within cache duration)
  bool get isFresh {
    return DateTime.now().difference(fetchedAt) < AppConstants.weatherCacheDuration;
  }

  /// Check if weather is hot (triggers hydration adjustment)
  bool get isHot => temperatureC > AppConstants.hotTempThreshold;

  /// Check if weather is very hot
  bool get isVeryHot => temperatureC > AppConstants.veryHotTempThreshold;

  /// Check if humidity is low
  bool get isDry => humidityPercent < AppConstants.lowHumidityThreshold;
}

/// Weather service for fetching current weather data
class WeatherService {
  final Dio _dio;
  WeatherData? _cachedData;

  WeatherService({Dio? dio}) : _dio = dio ?? Dio();

  /// Get current weather data
  /// Returns cached data if still fresh, otherwise fetches new data
  Future<WeatherData?> getCurrentWeather() async {
    // Return cached data if still fresh
    if (_cachedData != null && _cachedData!.isFresh) {
      return _cachedData;
    }

    try {
      // Get current position
      final position = await _getCurrentPosition();
      if (position == null) return null;

      // Fetch weather data
      final data = await _fetchWeatherData(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      _cachedData = data;
      return data;
    } catch (e) {
      // Return cached data even if stale, better than nothing
      return _cachedData;
    }
  }

  /// Get current position with permission handling
  Future<Position?> _getCurrentPosition() async {
    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
  }

  /// Fetch weather data from OpenWeatherMap API
  Future<WeatherData?> _fetchWeatherData({
    required double latitude,
    required double longitude,
  }) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      return null;
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${AppConstants.openWeatherBaseUrl}/weather',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        final main = data['main'] as Map<String, dynamic>?;
        final weatherList = data['weather'] as List<dynamic>?;
        
        if (main != null && weatherList != null && weatherList.isNotEmpty) {
          final weather = weatherList[0] as Map<String, dynamic>;
          return WeatherData(
            temperatureC: (main['temp'] as num).toDouble(),
            humidityPercent: (main['humidity'] as num).toDouble(),
            description: weather['description'] as String? ?? '',
            icon: weather['icon'] as String? ?? '',
            fetchedAt: DateTime.now(),
          );
        }
      }
    } catch (e) {
      // Silently fail, return null
    }

    return null;
  }

  /// Clear cached data
  void clearCache() {
    _cachedData = null;
  }

  /// Set weather data manually (for fallback when location is denied)
  void setManualWeather({
    required double temperatureC,
    required double humidityPercent,
  }) {
    _cachedData = WeatherData(
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
      description: 'Manual input',
      icon: '',
      fetchedAt: DateTime.now(),
    );
  }
}

