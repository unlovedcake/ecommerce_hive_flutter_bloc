import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirebaseForTesting() async {
  // Initialize Firebase with your test configuration
  await Firebase.initializeApp(
    name: 'test',
    options: FirebaseOptions(
      apiKey: 'AIzaSyBJkq02kuKELSwm3NudoHPWTCjFcrVRFu8',
      appId: '1:449980123915:web:10f82cfc84a58b7dfdf00e',
      messagingSenderId: '449980123915',
      projectId: 'flutter-bloc-crud',
      authDomain: 'flutter-bloc-crud.firebaseapp.com',
      storageBucket: 'flutter-bloc-crud.appspot.com',
      measurementId: 'G-BC4YNV1036',
    ),
  );
}
