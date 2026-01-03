import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';

/// Location permission status
enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

/// Service to handle location permissions
class LocationPermissionService {
  /// Completer to handle concurrent permission requests
  /// All concurrent calls will wait for the same result
  static Completer<LocationPermissionStatus>? _permissionCompleter;
  
  /// Check and request location permission
  /// Returns the current permission status
  /// Safe to call multiple times - concurrent calls will share the same request
  static Future<LocationPermissionStatus> checkAndRequestPermission() async {
    // If a request is already in progress, wait for it
    if (_permissionCompleter != null && !_permissionCompleter!.isCompleted) {
      return _permissionCompleter!.future;
    }
    
    // Create new completer for this request
    _permissionCompleter = Completer<LocationPermissionStatus>();
    
    try {
      final result = await _doCheckAndRequest();
      _permissionCompleter!.complete(result);
      return result;
    } catch (e) {
      // In case of error, return current status
      final fallback = await _getCurrentStatus();
      if (!_permissionCompleter!.isCompleted) {
        _permissionCompleter!.complete(fallback);
      }
      return fallback;
    }
  }
  
  /// Internal method that actually does the permission check/request
  static Future<LocationPermissionStatus> _doCheckAndRequest() async {
    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    // Check current permission
    var permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied) {
        return LocationPermissionStatus.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionStatus.deniedForever;
    }

    return LocationPermissionStatus.granted;
  }
  
  /// Get current status without requesting (safe to call anytime)
  static Future<LocationPermissionStatus> getCurrentStatus() async {
    return _getCurrentStatus();
  }
  
  /// Internal: Get current status without requesting
  static Future<LocationPermissionStatus> _getCurrentStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }
    
    final permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionStatus.deniedForever;
    }
    
    if (permission == LocationPermission.denied) {
      return LocationPermissionStatus.denied;
    }
    
    return LocationPermissionStatus.granted;
  }

  /// Open device location settings
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings (for permission denied forever)
  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Show dialog to guide user to enable location
  /// Returns true if user wants to retry permission request
  static Future<bool> showPermissionDeniedDialog(
    BuildContext context, {
    required bool isDeniedForever,
  }) async {
    final title = isDeniedForever 
        ? 'Cần cấp quyền vị trí'
        : 'Bật quyền truy cập vị trí';
    
    final message = isDeniedForever
        ? 'Bạn đã từ chối quyền vị trí vĩnh viễn. Vui lòng vào Cài đặt > SmartHydro > Vị trí để bật quyền.'
        : 'SmartHydro cần quyền vị trí để lấy thông tin thời tiết và điều chỉnh mục tiêu nước uống phù hợp với bạn.';

    final actionText = isDeniedForever ? 'Mở Cài đặt' : 'Cho phép';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.hydroEnd.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.hydroEnd,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleMedium().bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Để sau',
              style: AppTextStyles.labelLarge(color: AppColors.grey600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (isDeniedForever) {
                // Open app settings for user to manually enable
                await openAppSettings();
                Navigator.of(context).pop(false); // User will come back later
              } else {
                Navigator.of(context).pop(true); // Request permission again
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.hydroEnd,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(actionText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  /// Show snackbar for location service disabled
  static void showServiceDisabledSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Vui lòng bật GPS để cập nhật thời tiết'),
        action: SnackBarAction(
          label: 'Bật GPS',
          onPressed: () => openLocationSettings(),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

