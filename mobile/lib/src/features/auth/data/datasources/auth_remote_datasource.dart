import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

/// Remote data source for authentication
/// 
/// Handles all Supabase Auth API calls
abstract class AuthRemoteDataSource {
  User? get currentUser;
  Stream<User?> get authStateChanges;
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(String email, String password, String? name);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<UserModel> updateUserMetadata(Map<String, dynamic> metadata);
  bool get isAuthenticated;
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabase;
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();

  AuthRemoteDataSourceImpl({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client {
    // Listen to Supabase auth state changes
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      if (user != null) {
        _authStateController.add(UserModel.fromSupabase(user));
      } else {
        _authStateController.add(null);
      }
    });
  }

  @override
  User? get currentUser {
    final supabaseUser = _supabase.auth.currentUser;
    if (supabaseUser == null) return null;
    return UserModel.fromSupabase(supabaseUser);
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.smarthydro://login-callback/',
      );

      if (!response) {
        throw AuthExceptions.userCancelled();
      }

      // Wait for auth state change
      await Future.delayed(const Duration(seconds: 2));

      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw AuthExceptions.userNotFound();
      }

      return UserModel.fromSupabase(user);
    } on AuthException catch (e) {
      throw AuthExceptions.fromSupabaseException(e);
    } catch (e) {
      throw AuthExceptions.unknown(e);
    }
  }

  @override
  Future<UserModel> signInWithApple() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.supabase.smarthydro://login-callback/',
      );

      if (!response) {
        throw AuthExceptions.userCancelled();
      }

      // Wait for auth state change
      await Future.delayed(const Duration(seconds: 2));

      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw AuthExceptions.userNotFound();
      }

      return UserModel.fromSupabase(user);
    } on AuthException catch (e) {
      throw AuthExceptions.fromSupabaseException(e);
    } catch (e) {
      throw AuthExceptions.unknown(e);
    }
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw AuthExceptions.userNotFound();
      }

      return UserModel.fromSupabase(user);
    } on AuthException catch (e) {
      throw AuthExceptions.fromSupabaseException(e);
    } catch (e) {
      throw AuthExceptions.unknown(e);
    }
  }

  @override
  Future<UserModel> signUpWithEmail(
    String email,
    String password,
    String? name,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );

      final user = response.user;
      if (user == null) {
        throw AuthException(
          message: 'Failed to create user',
          code: 'signup-failed',
        );
      }

      return UserModel.fromSupabase(user);
    } on AuthException catch (e) {
      throw AuthExceptions.fromSupabaseException(e);
    } catch (e) {
      throw AuthExceptions.unknown(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthExceptions.fromSupabaseException(e);
    } catch (e) {
      throw AuthExceptions.unknown(e);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.smarthydro://reset-password/',
      );
    } on AuthException catch (e) {
      throw AuthExceptions.fromSupabaseException(e);
    } catch (e) {
      throw AuthExceptions.unknown(e);
    }
  }

  @override
  Future<UserModel> updateUserMetadata(Map<String, dynamic> metadata) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(data: metadata),
      );

      final user = response.user;
      if (user == null) {
        throw AuthExceptions.userNotFound();
      }

      return UserModel.fromSupabase(user);
    } on AuthException catch (e) {
      throw AuthExceptions.fromSupabaseException(e);
    } catch (e) {
      throw AuthExceptions.unknown(e);
    }
  }

  void dispose() {
    _authStateController.close();
  }
}

