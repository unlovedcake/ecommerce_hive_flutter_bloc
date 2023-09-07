import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hive/app.dart';
import 'package:hive/bloc/auth/auth_bloc.dart';
import 'package:hive/enums/flavor_enum.dart';
import 'package:hive/firebase_options.dart';

import 'package:hive/repositories/auth_repository.dart';

import 'firebase_config_test.dart';

import 'package:mocktail/mocktail.dart';

class MockAutenticatedAuthenticationRepository extends Mock
    implements UserCredential, AuthRepository {}

Future<void> main() async {
  //setupFirebaseMocks();
  // WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();

  //runApp(MyApp(flavor: Flavor.development));
  //await initializeFirebaseForTesting();

  group('RegistrationBloc', () {
    final _mockAuth = MockFirebaseAuth();
    late AuthBloc registrationBloc;
    //late MockAutenticatedAuthenticationRepository authMock;

    // setUpAll(() async {
    //   TestWidgetsFlutterBinding.ensureInitialized();
    //   await initializeFirebaseForTesting();
    // });

    setUp(() async {
      // Create a mock repository for Firebase Auth
      //authMock = MockAutenticatedAuthenticationRepository();
      registrationBloc = AuthBloc();
      // await AuthRepository.signUp(
      //     name: 'Hello', email: 'test@example.com', password: 'password');
    });

    tearDown(() {
      registrationBloc.close();
    });

    test('Initial state is UnauthenticatedState', () {
      expect(registrationBloc.state, isA<UnAuthenticated>());
    });

    test('signIn function test', () async {
      final user = await _mockAuth.createUserWithEmailAndPassword(
          email: 'heygmail.com', password: 'password123');

      expect(user.user!.email, _mockAuth.currentUser!.email);
    });

    // blocTest<AuthBloc, AuthState>(
    //   'Emits [AuthenticatedState] when SignInEvent is added',
    //   // build: () {
    //   //   when(() async {
    //   //     await _mockAuth
    //   //         .createUserWithEmailAndPassword(
    //   //             email: 'hey@gmail.com', password: 'password123')
    //   //         .then((value) => true);
    //   //   });
    //   //   return registrationBloc;
    //   // },
    //   build: () => registrationBloc,
    //   wait: Duration(seconds: 3),
    //   verify: (bloc) => bloc.state == AuthenticatedSignUp(),
    //   act: (bloc) =>
    //       bloc.add(SignUpRequested('Hello', 'test@example.com', 'password')),
    //   expect: () => [AuthenticatedSignUp()],
    // );

    // blocTest<AuthBloc, AuthState>(
    //   'emits [RegistrationLoading, RegistrationSuccess] when registration is successful',
    //   build: () => registrationBloc,
    //   act: (bloc) =>
    //       bloc.add(SignUpRequested(' asdada', 'test@example.com', 'password')),
    //   expect: () => [Loading(), AuthenticatedSignUp()],
    // );
  });
}
