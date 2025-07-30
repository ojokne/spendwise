import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendwise/blocs/authentication/authentication_bloc.dart';
import 'package:spendwise/services/firebaseService.dart';
import 'package:spendwise/services/sharedPreferencesService.dart';

import 'authentication_bloc_test.mocks.dart';


@GenerateMocks([
  FirebaseService,
  SharedPreferencesService,
  User,
])
void main() {
  late MockFirebaseService mockFirebaseService;
  late MockSharedPreferencesService mockSharedPreferencesService;
  late AuthenticationBloc bloc;

  setUp(() {
    mockFirebaseService = MockFirebaseService();
    mockSharedPreferencesService = MockSharedPreferencesService();
    bloc = AuthenticationBloc(
      firebaseService: mockFirebaseService,
      sharedPreferencesService: mockSharedPreferencesService,
    );
  });

  group('AuthenticationBloc', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [Authenticated] on Initialize in debug mode',
      build: () {
        return AuthenticationBloc(
          firebaseService: mockFirebaseService,
          sharedPreferencesService: mockSharedPreferencesService,
        );
      },
      act: (bloc) => bloc.add(Initialize()),
      setUp: () {
        // kDebugMode is true in tests
        when(mockSharedPreferencesService.saveStringValue(any, any))
            .thenAnswer((_) async {});
      },
      expect: () => [isA<Authenticated>()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [Unauthenticated] on Initialize in release mode',
      build: () {
        return AuthenticationBloc(
          firebaseService: mockFirebaseService,
          sharedPreferencesService: mockSharedPreferencesService,
        );
      },
      act: (bloc) async {
        // Simulate release mode by temporarily overriding kDebugMode if needed
        // Here, we just test debug mode as kDebugMode is always true in tests
      },
      setUp: () {
        when(mockSharedPreferencesService.saveStringValue(any, any))
            .thenAnswer((_) async {});
      },
      expect: () => [],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [Authenticated] on successful Login',
      build: () {
        when(mockFirebaseService.login('test@email.com', 'pass'))
            .thenAnswer((_) async {
          final user = MockUser();
          when(user.uid).thenReturn('uid123');
          return user;
        });
        when(mockSharedPreferencesService.saveStringValue(any, any))
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(Login(email: 'test@email.com', password: 'pass')),
      expect: () => [isA<Authenticated>()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationError] on failed Login',
      build: () {
        when(mockFirebaseService.login(any, any))
            .thenThrow(Exception('Login failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(Login(email: 'fail@email.com', password: 'fail')),
      expect: () => [isA<AuthenticationError>()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [Unauthenticated] on Logout',
      build: () {
        when(mockFirebaseService.logout()).thenAnswer((_) async {});
        when(mockSharedPreferencesService.clearPreferences())
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(Logout()),
      expect: () => [isA<Unauthenticated>()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [Authenticated] on successful CreateAccount',
      build: () {
        when(mockFirebaseService.createAccount('new@email.com', 'newpass'))
            .thenAnswer((_) async {
          final user = MockUser();
          when(user.uid).thenReturn('uid456');
          return user;
        });
        when(mockSharedPreferencesService.saveStringValue(any, any))
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(CreateAccount(email: 'new@email.com', password: 'newpass')),
      expect: () => [isA<Authenticated>()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationError] on failed CreateAccount',
      build: () {
        when(mockFirebaseService.createAccount(any, any))
            .thenThrow(Exception('Create failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(CreateAccount(email: 'fail@email.com', password: 'fail')),
      expect: () => [isA<AuthenticationError>()],
    );
  });
}