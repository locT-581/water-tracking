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

  WeatherService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Get current weather data
  /// Returns cached data if still fresh, otherwise fetches new data
  /// Has a timeout to prevent hanging forever
  Future<WeatherData?> getCurrentWeather() async {
    // Return cached data if still fresh
    if (_cachedData != null && _cachedData!.isFresh) {
      return _cachedData;
    }

    try {
      // Add timeout to prevent hanging forever
      return await _fetchCurrentWeatherWithTimeout();
    } catch (e) {
      // Return cached data even if stale, better than nothing
      return _cachedData;
    }
  }
  
  Future<WeatherData?> _fetchCurrentWeatherWithTimeout() async {
    return await Future.any([
      _fetchCurrentWeatherInternal(),
      Future.delayed(const Duration(seconds: 10), () => _cachedData),
    ]);
  }
  
  Future<WeatherData?> _fetchCurrentWeatherInternal() async {
    // Get current position
    final position = await _getCurrentPosition();
    if (position == null) return _cachedData;

    // Fetch weather data
    final data = await _fetchWeatherData(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    if (data != null) {
      _cachedData = data;
    }
    return data ?? _cachedData;
  }

  /// Get current position - only checks permission, does NOT request
  /// Permission should be requested via LocationPermissionService before calling this
  Future<Position?> _getCurrentPosition() async {
    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Only CHECK permission, do NOT request (to avoid concurrent request errors)
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get position with timeout
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      // Handle any position errors gracefully (timeout, location unavailable, etc.)
      return null;
    }
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

