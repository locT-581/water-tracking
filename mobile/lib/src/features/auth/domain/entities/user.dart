import 'package:equatable/equatable.dart';

/// User entity - Domain model for authenticated user
/// 
/// This represents the core user data from Supabase Auth
class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastSignInAt;
  final Map<String, dynamic>? metadata;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    required this.createdAt,
    this.lastSignInAt,
    this.metadata,
  });

  /// Check if user has completed onboarding
  bool get hasCompletedOnboarding {
    return metadata?['has_completed_onboarding'] == true;
  }

  /// Copy with method
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatarUrl,
        createdAt,
        lastSignInAt,
        metadata,
      ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name)';
  }
}

/// Authentication state
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

