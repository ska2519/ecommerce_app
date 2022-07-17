@Timeout(Duration(microseconds: 500))
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  // FakeAuthRepository makeAuthRepository() =>
  //     FakeAuthRepository(addDelay: false);
  // final testUser = AppUser(
  //   uid: testEmail.split('').reversed.join(),
  //   email: testEmail,
  // );
  group('submit', () {
    test('''
Given formType is signIn
When signInWithEmailAndPassword succeeds
Then return true
And state is AsyncData
''', () async {
      // setup
      final authRepository = MockAuthRepository();
      when(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );

      // expect later
      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncLoading<void>(),
          ),
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncData<void>(null),
          ),
        ]),
      );
      // run
      final result = await controller.submit(testEmail, testPassword);
      // verify
      expect(result, true);
      verify(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).called(1);
    });

    test('''
Given formType is signIn
When signInWithEmailAndPassword fails
Then return false
And state is AsyncError
''', () async {
      // setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).thenThrow(exception);
      final controller = EmailPasswordSignInController(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );

      // expect later
      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncLoading<void>(),
          ),
          // using predicate since we can't match the stack trace
          predicate<EmailPasswordSignInState>((state) {
            expect(state.formType, EmailPasswordSignInFormType.signIn);
            expect(state.value.hasError, true);
            return true;
          }),
        ]),
      );
      // run
      final result = await controller.submit(testEmail, testPassword);
      // verify
      expect(result, false);
      verify(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).called(1);
    });

    test('''
Given formType is register
When createUserWithEmailAndPassword succeeds
Then return true
And state is AsyncData
''', () async {
      // setup
      final authRepository = MockAuthRepository();
      when(() => authRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          )).thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );

      // expect later
      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncLoading<void>(),
          ),
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncData<void>(null),
          ),
        ]),
      );
      // run
      final result = await controller.submit(testEmail, testPassword);
      // verify
      expect(result, true);
      verify(() => authRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          )).called(1);
    });

    test('''
Given formType is register
When createUserWithEmailAndPassword fails
Then return false
And state is AsyncError
''', () async {
      // setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(() => authRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          )).thenThrow(exception);
      final controller = EmailPasswordSignInController(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );

      // expect later
      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncLoading<void>(),
          ),
          // using predicate since we can't match the stack trace
          predicate<EmailPasswordSignInState>((state) {
            expect(state.formType, EmailPasswordSignInFormType.register);
            expect(state.value.hasError, true);
            return true;
          }),
        ]),
      );
      // run
      final result = await controller.submit(testEmail, testPassword);
      // verify
      expect(result, false);
      verify(() => authRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          )).called(1);
    });
  });

  group('updateFormType', () {
    test('''
Given formType is signIn
When called with register
Then state.formType is register
''', () {
      // setup
      final authRepository = MockAuthRepository();
      final controller = EmailPasswordSignInController(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );
      controller.updateFormType(
        EmailPasswordSignInFormType.register,
      );
      expect(
        controller.debugState,
        EmailPasswordSignInState(
          formType: EmailPasswordSignInFormType.register,
          value: const AsyncData<void>(null),
        ),
      );
    });
    test('''
Given formType is register
When called with signIn
Then state.formType is signIn
''', () {
      // setup
      final authRepository = MockAuthRepository();
      final controller = EmailPasswordSignInController(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );
      controller.updateFormType(
        EmailPasswordSignInFormType.signIn,
      );
      expect(
        controller.debugState,
        EmailPasswordSignInState(
          formType: EmailPasswordSignInFormType.signIn,
          value: const AsyncData<void>(null),
        ),
      );
    });
  });
}
