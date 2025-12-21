import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../entities/user.dart';

/// Authentication Repository Interface
/// 
/// Defines contracts for authentication operations
abstract class AuthRepository {
  /// Get current user
  User? get currentUser;

  /// Get auth state stream
  Stream<User?> get authStateChanges;

  /// Sign in with Google
  Future<User> signInWithGoogle();

  /// Sign in with Apple
  Future<User> signInWithApple();

  /// Sign in with email and password
  Future<User> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });

  /// Sign out
  Future<void> signOut();

  /// Reset password
  Future<void> resetPassword(String email);

  /// Update user metadata
  Future<User> updateUserMetadata(Map<String, dynamic> metadata);

  /// Delete account
  Future<void> deleteAccount();

  /// Check if user is authenticated
  bool get isAuthenticated;
}

/// Auth Exception types
class AuthException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AuthException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AuthException: $message ${code != null ? '(code: $code)' : ''}';
}

/// Auth exception factory
class AuthExceptions {
  static AuthException fromSupabaseException(supabase.AuthException e) {
    return AuthException(
      message: e.message,
      code: e.statusCode,
      originalError: e,
    );
  }

  static AuthException userNotFound() {
    return AuthException(
      message: 'User not found',
      code: 'user-not-found',
    );
  }

  static AuthException userCancelled() {
    return AuthException(
      message: 'User cancelled the sign in flow',
      code: 'user-cancelled',
    );
  }

  static AuthException networkError() {
    return AuthException(
      message: 'Network error occurred',
      code: 'network-error',
    );
  }

  static AuthException unknown(dynamic error) {
    return AuthException(
      message: 'An unknown error occurred',
      code: 'unknown',
      originalError: error,
    );
  }
}

