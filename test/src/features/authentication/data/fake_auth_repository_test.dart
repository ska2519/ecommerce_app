import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  FakeAuthRepository makeAuthRepository() =>
      FakeAuthRepository(addDelay: false);
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );
  group('FakeAuthRepository', () {
    test('currentUser is null', () {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });
  });

  test('currentUser is not null after sign in', () async {
    final authRepository = makeAuthRepository();
    await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
    expect(
      authRepository.currentUser,
      testUser,
    );
    expect(
      authRepository.authStateChanges(),
      emits(testUser),
    );
  });

  test('currentUser is not null after registration', () async {
    final authRepository = makeAuthRepository();
    await authRepository.createUserWithEmailAndPassword(
      testEmail,
      testPassword,
    );
    expect(authRepository.currentUser, testUser);
    expect(
      authRepository.authStateChanges(),
      emits(testUser),
    );
  });

  test(
    'currentUser is null after sign out',
    () async {
      final authRepository = makeAuthRepository();
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);

      /// [emitsInOrder] 사용할 수 있지만 가독성 떨어짐
      // expect(
      //   authRepository.authStateChanges(),
      //   emitsInOrder([
      //     testUser, // after signIn
      //     null, // after signOut
      //   ]),
      // );

      expect(authRepository.currentUser, testUser);
      expect(
        authRepository.authStateChanges(),
        emits(testUser),
      );
      await authRepository.signOut();
      expect(
        authRepository.currentUser,
        null,
      );
      expect(
        authRepository.authStateChanges(),
        emits(null),
      );
    },
  );

  test(
    'sign in after dispose throws exception',
    () async {
      final authRepository = makeAuthRepository();
      authRepository.dispose();
      expect(
        authRepository.currentUser,
        null,
      );
      expectLater(
        () => authRepository.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
        throwsStateError,
      );
    },
  );
}
