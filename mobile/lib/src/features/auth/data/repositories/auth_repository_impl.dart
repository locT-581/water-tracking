import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
/// 
/// Coordinates between data sources and domain layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  User? get currentUser => _remoteDataSource.currentUser;

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  bool get isAuthenticated => _remoteDataSource.isAuthenticated;

  @override
  Future<User> signInWithGoogle() async {
    try {
      final userModel = await _remoteDataSource.signInWithGoogle();
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> signInWithApple() async {
    try {
      final userModel = await _remoteDataSource.signInWithApple();
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmail(email, password);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final userModel = await _remoteDataSource.signUpWithEmail(
        email,
        password,
        name,
      );
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> updateUserMetadata(Map<String, dynamic> metadata) async {
    try {
      final userModel = await _remoteDataSource.updateUserMetadata(metadata);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    // TODO: Implement via Supabase RPC or Admin API
    // For now, just sign out
    await signOut();
    throw UnimplementedError('Account deletion requires backend implementation');
  }
}

