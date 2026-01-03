import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guest Mode Service
/// 
/// Manages guest user state for users who want to try the app
/// without signing in. Data is stored locally and can be synced
/// when user decides to create an account.
class GuestModeService {
  static const String _isGuestKey = 'is_guest_user';
  static const String _guestIdKey = 'guest_user_id';
  static const String _hasSeenLinkAccountPromptKey = 'has_seen_link_account_prompt';
  static const String _guestDataCreatedAtKey = 'guest_data_created_at';
  
  final SharedPreferences _prefs;
  
  GuestModeService(this._prefs);
  
  /// Check if user is in guest mode
  bool get isGuestMode => _prefs.getBool(_isGuestKey) ?? false;
  
  /// Get guest user ID (generated locally)
  String? get guestUserId => _prefs.getString(_guestIdKey);
  
  /// Check if user has seen the link account prompt
  bool get hasSeenLinkAccountPrompt => 
      _prefs.getBool(_hasSeenLinkAccountPromptKey) ?? false;
  
  /// Get when guest data was created
  DateTime? get guestDataCreatedAt {
    final timestamp = _prefs.getInt(_guestDataCreatedAtKey);
    return timestamp != null 
        ? DateTime.fromMillisecondsSinceEpoch(timestamp) 
        : null;
  }
  
  /// Calculate days since guest mode started
  int get daysSinceGuestModeStarted {
    final createdAt = guestDataCreatedAt;
    if (createdAt == null) return 0;
    return DateTime.now().difference(createdAt).inDays;
  }
  
  /// Enable guest mode
  Future<void> enableGuestMode() async {
    final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
    await _prefs.setBool(_isGuestKey, true);
    await _prefs.setString(_guestIdKey, guestId);
    await _prefs.setInt(
      _guestDataCreatedAtKey, 
      DateTime.now().millisecondsSinceEpoch,
    );
  }
  
  /// Disable guest mode (when user signs in)
  Future<void> disableGuestMode() async {
    await _prefs.setBool(_isGuestKey, false);
    // Keep guestId for data migration
  }
  
  /// Mark link account prompt as seen
  Future<void> markLinkAccountPromptSeen() async {
    await _prefs.setBool(_hasSeenLinkAccountPromptKey, true);
  }
  
  /// Reset link account prompt (to show again)
  Future<void> resetLinkAccountPrompt() async {
    await _prefs.setBool(_hasSeenLinkAccountPromptKey, false);
  }
  
  /// Clear all guest data
  Future<void> clearGuestData() async {
    await _prefs.remove(_isGuestKey);
    await _prefs.remove(_guestIdKey);
    await _prefs.remove(_hasSeenLinkAccountPromptKey);
    await _prefs.remove(_guestDataCreatedAtKey);
  }
  
  /// Check if should show link account reminder
  /// Shows reminder after 3 days of guest usage
  bool get shouldShowLinkAccountReminder {
    if (!isGuestMode) return false;
    if (hasSeenLinkAccountPrompt) return false;
    return daysSinceGuestModeStarted >= 3;
  }
}

/// Guest mode service provider
final guestModeServiceProvider = Provider<GuestModeService>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

/// Is guest mode provider
final isGuestModeProvider = Provider<bool>((ref) {
  final service = ref.watch(guestModeServiceProvider);
  return service.isGuestMode;
});

/// Guest user ID provider
final guestUserIdProvider = Provider<String?>((ref) {
  final service = ref.watch(guestModeServiceProvider);
  return service.guestUserId;
});

/// Should show link account reminder provider
final shouldShowLinkAccountReminderProvider = Provider<bool>((ref) {
  final service = ref.watch(guestModeServiceProvider);
  return service.shouldShowLinkAccountReminder;
});

/// Guest mode state notifier for reactive updates
class GuestModeNotifier extends StateNotifier<bool> {
  final GuestModeService _service;
  
  GuestModeNotifier(this._service) : super(_service.isGuestMode);
  
  Future<void> enableGuestMode() async {
    await _service.enableGuestMode();
    state = true;
  }
  
  Future<void> disableGuestMode() async {
    await _service.disableGuestMode();
    state = false;
  }
}

final guestModeNotifierProvider = 
    StateNotifierProvider<GuestModeNotifier, bool>((ref) {
  final service = ref.watch(guestModeServiceProvider);
  return GuestModeNotifier(service);
});

