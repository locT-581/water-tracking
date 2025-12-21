import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

// ============== DATA SOURCE PROVIDERS ==============

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Auth remote data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSourceImpl(supabase: supabase);
});

// ============== REPOSITORY PROVIDERS ==============

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});

// ============== STATE PROVIDERS ==============

/// Current user provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Auth status provider
final authStatusProvider = Provider<AuthStatus>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  
  return userAsync.when(
    data: (user) => user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    loading: () => AuthStatus.loading,
    error: (_, __) => AuthStatus.unauthenticated,
  );
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final status = ref.watch(authStatusProvider);
  return status == AuthStatus.authenticated;
});

/// Has completed onboarding provider
final hasCompletedOnboardingProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  
  return userAsync.when(
    data: (user) => user?.hasCompletedOnboarding ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

// ============== USE CASE PROVIDERS ==============

/// Sign in with Google use case
final signInWithGoogleProvider = Provider<Future<User> Function()>((ref) {
  return () async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.signInWithGoogle();
  };
});

/// Sign in with Apple use case
final signInWithAppleProvider = Provider<Future<User> Function()>((ref) {
  return () async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.signInWithApple();
  };
});

/// Sign in with email use case
final signInWithEmailProvider = Provider<Future<User> Function(String, String)>((ref) {
  return (email, password) async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.signInWithEmail(
      email: email,
      password: password,
    );
  };
});

/// Sign up with email use case
final signUpWithEmailProvider = Provider<Future<User> Function(String, String, String?)>((ref) {
  return (email, password, name) async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    );
  };
});

/// Sign out use case
final signOutProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final repository = ref.read(authRepositoryProvider);
    await repository.signOut();
  };
});

/// Reset password use case
final resetPasswordProvider = Provider<Future<void> Function(String)>((ref) {
  return (email) async {
    final repository = ref.read(authRepositoryProvider);
    await repository.resetPassword(email);
  };
});

/// Update user metadata use case
final updateUserMetadataProvider = Provider<Future<User> Function(Map<String, dynamic>)>((ref) {
  return (metadata) async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.updateUserMetadata(metadata);
  };
});

// ============== AUTH CONTROLLER ==============

/// Auth controller state
class AuthControllerState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;

  const AuthControllerState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  AuthControllerState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
  }) {
    return AuthControllerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

/// Auth controller
class AuthController extends StateNotifier<AuthControllerState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AuthControllerState());

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final user = await _repository.signInWithGoogle();
      state = state.copyWith(isLoading: false, user: user);
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Đã xảy ra lỗi không xác định',
      );
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final user = await _repository.signInWithApple();
      state = state.copyWith(isLoading: false, user: user);
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Đã xảy ra lỗi không xác định',
      );
    }
  }

  /// Sign in with email
  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final user = await _repository.signInWithEmail(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, user: user);
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Đã xảy ra lỗi không xác định',
      );
    }
  }

  /// Sign up with email
  Future<void> signUpWithEmail(String email, String password, String? name) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final user = await _repository.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );
      state = state.copyWith(isLoading: false, user: user);
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Đã xảy ra lỗi không xác định',
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      await _repository.signOut();
      state = const AuthControllerState();
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Đã xảy ra lỗi không xác định',
      );
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      await _repository.resetPassword(email);
      state = state.copyWith(isLoading: false);
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Đã xảy ra lỗi không xác định',
      );
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Auth controller provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthControllerState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});

