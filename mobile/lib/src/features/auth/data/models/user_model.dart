import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/user.dart';

/// User Model - Data layer model
/// 
/// Converts between Supabase User and domain User entity
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.avatarUrl,
    required super.createdAt,
    super.lastSignInAt,
    super.metadata,
  });

  /// Create UserModel from Supabase User
  factory UserModel.fromSupabase(supabase.User supabaseUser) {
    return UserModel(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      name: supabaseUser.userMetadata?['name'] as String? ??
          supabaseUser.userMetadata?['full_name'] as String?,
      avatarUrl: supabaseUser.userMetadata?['avatar_url'] as String?,
      createdAt: DateTime.parse(supabaseUser.createdAt),
      lastSignInAt: supabaseUser.lastSignInAt != null
          ? DateTime.parse(supabaseUser.lastSignInAt!)
          : null,
      metadata: supabaseUser.userMetadata,
    );
  }

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
      metadata: metadata,
    );
  }

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

