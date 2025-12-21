import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hydro/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:smart_hydro/src/features/auth/data/models/user_model.dart';
import 'package:smart_hydro/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_hydro/src/features/auth/domain/entities/user.dart';
import 'package:smart_hydro/src/features/auth/domain/repositories/auth_repository.dart';

// Mock classes
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepository repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('AuthRepository', () {
    final tUserModel = UserModel(
      id: 'test-user-id',
      email: 'test@example.com',
      name: 'Test User',
      createdAt: DateTime(2024, 1, 1),
    );

    final tUser = tUserModel.toEntity();

    group('signInWithGoogle', () {
      test('should return User when sign in is successful', () async {
        // Arrange
        when(() => mockRemoteDataSource.signInWithGoogle())
            .thenAnswer((_) async => tUserModel);

        // Act
        final result = await repository.signInWithGoogle();

        // Assert
        expect(result, isA<User>());
        expect(result.id, tUser.id);
        expect(result.email, tUser.email);
        verify(() => mockRemoteDataSource.signInWithGoogle()).called(1);
      });

      test('should throw AuthException when sign in fails', () async {
        // Arrange
        when(() => mockRemoteDataSource.signInWithGoogle())
            .thenThrow(AuthExceptions.userCancelled());

        // Act & Assert
        expect(
          () => repository.signInWithGoogle(),
          throwsA(isA<AuthException>()),
        );
        verify(() => mockRemoteDataSource.signInWithGoogle()).called(1);
      });
    });

    group('signInWithApple', () {
      test('should return User when sign in is successful', () async {
        // Arrange
        when(() => mockRemoteDataSource.signInWithApple())
            .thenAnswer((_) async => tUserModel);

        // Act
        final result = await repository.signInWithApple();

        // Assert
        expect(result, isA<User>());
        expect(result.id, tUser.id);
        expect(result.email, tUser.email);
        verify(() => mockRemoteDataSource.signInWithApple()).called(1);
      });

      test('should throw AuthException when sign in fails', () async {
        // Arrange
        when(() => mockRemoteDataSource.signInWithApple())
            .thenThrow(AuthExceptions.userCancelled());

        // Act & Assert
        expect(
          () => repository.signInWithApple(),
          throwsA(isA<AuthException>()),
        );
        verify(() => mockRemoteDataSource.signInWithApple()).called(1);
      });
    });

    group('signInWithEmail', () {
      const tEmail = 'test@example.com';
      const tPassword = 'password123';

      test('should return User when sign in is successful', () async {
        // Arrange
        when(() => mockRemoteDataSource.signInWithEmail(tEmail, tPassword))
            .thenAnswer((_) async => tUserModel);

        // Act
        final result = await repository.signInWithEmail(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<User>());
        expect(result.email, tEmail);
        verify(() => mockRemoteDataSource.signInWithEmail(tEmail, tPassword))
            .called(1);
      });

      test('should throw AuthException when credentials are invalid', () async {
        // Arrange
        when(() => mockRemoteDataSource.signInWithEmail(tEmail, tPassword))
            .thenThrow(AuthException(
          message: 'Invalid credentials',
          code: 'invalid-credentials',
        ));

        // Act & Assert
        expect(
          () => repository.signInWithEmail(
            email: tEmail,
            password: tPassword,
          ),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('signUpWithEmail', () {
      const tEmail = 'newuser@example.com';
      const tPassword = 'password123';
      const tName = 'New User';

      test('should return User when sign up is successful', () async {
        // Arrange
        when(() => mockRemoteDataSource.signUpWithEmail(
              tEmail,
              tPassword,
              tName,
            )).thenAnswer((_) async => tUserModel);

        // Act
        final result = await repository.signUpWithEmail(
          email: tEmail,
          password: tPassword,
          name: tName,
        );

        // Assert
        expect(result, isA<User>());
        verify(() => mockRemoteDataSource.signUpWithEmail(
              tEmail,
              tPassword,
              tName,
            )).called(1);
      });

      test('should throw AuthException when email is already in use', () async {
        // Arrange
        when(() => mockRemoteDataSource.signUpWithEmail(
              tEmail,
              tPassword,
              tName,
            )).thenThrow(AuthException(
          message: 'Email already in use',
          code: 'email-in-use',
        ));

        // Act & Assert
        expect(
          () => repository.signUpWithEmail(
            email: tEmail,
            password: tPassword,
            name: tName,
          ),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('signOut', () {
      test('should complete successfully', () async {
        // Arrange
        when(() => mockRemoteDataSource.signOut())
            .thenAnswer((_) async => {});

        // Act
        await repository.signOut();

        // Assert
        verify(() => mockRemoteDataSource.signOut()).called(1);
      });

      test('should throw AuthException when sign out fails', () async {
        // Arrange
        when(() => mockRemoteDataSource.signOut())
            .thenThrow(AuthExceptions.networkError());

        // Act & Assert
        expect(
          () => repository.signOut(),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('resetPassword', () {
      const tEmail = 'test@example.com';

      test('should complete successfully', () async {
        // Arrange
        when(() => mockRemoteDataSource.resetPassword(tEmail))
            .thenAnswer((_) async => {});

        // Act
        await repository.resetPassword(tEmail);

        // Assert
        verify(() => mockRemoteDataSource.resetPassword(tEmail)).called(1);
      });

      test('should throw AuthException when email is not found', () async {
        // Arrange
        when(() => mockRemoteDataSource.resetPassword(tEmail))
            .thenThrow(AuthExceptions.userNotFound());

        // Act & Assert
        expect(
          () => repository.resetPassword(tEmail),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('updateUserMetadata', () {
      final tMetadata = {'has_completed_onboarding': true};

      test('should return updated User', () async {
        // Arrange
        final updatedUserModel = tUserModel.copyWith(
          metadata: tMetadata,
        );
        when(() => mockRemoteDataSource.updateUserMetadata(tMetadata))
            .thenAnswer((_) async => updatedUserModel);

        // Act
        final result = await repository.updateUserMetadata(tMetadata);

        // Assert
        expect(result, isA<User>());
        expect(result.metadata, tMetadata);
        verify(() => mockRemoteDataSource.updateUserMetadata(tMetadata))
            .called(1);
      });
    });

    group('currentUser', () {
      test('should return current user from data source', () {
        // Arrange
        when(() => mockRemoteDataSource.currentUser).thenReturn(tUserModel);

        // Act
        final result = repository.currentUser;

        // Assert
        expect(result, isA<User>());
        expect(result?.id, tUser.id);
        verify(() => mockRemoteDataSource.currentUser).called(1);
      });

      test('should return null when no user is logged in', () {
        // Arrange
        when(() => mockRemoteDataSource.currentUser).thenReturn(null);

        // Act
        final result = repository.currentUser;

        // Assert
        expect(result, isNull);
        verify(() => mockRemoteDataSource.currentUser).called(1);
      });
    });

    group('isAuthenticated', () {
      test('should return true when user is authenticated', () {
        // Arrange
        when(() => mockRemoteDataSource.isAuthenticated).thenReturn(true);

        // Act
        final result = repository.isAuthenticated;

        // Assert
        expect(result, true);
        verify(() => mockRemoteDataSource.isAuthenticated).called(1);
      });

      test('should return false when user is not authenticated', () {
        // Arrange
        when(() => mockRemoteDataSource.isAuthenticated).thenReturn(false);

        // Act
        final result = repository.isAuthenticated;

        // Assert
        expect(result, false);
        verify(() => mockRemoteDataSource.isAuthenticated).called(1);
      });
    });
  });
}

