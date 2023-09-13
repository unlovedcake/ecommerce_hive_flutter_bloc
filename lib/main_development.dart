import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';
import 'app.dart';
import 'constants/sendbird_instance.dart';
import 'enums/flavor_enum.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  sendBird = SendbirdSdk(appId: '51A3EFB8-6F6E-4E0D-862E-8ABDAD535D18');
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(MyApp(
    flavor: Flavor.development,
    connectivity: Connectivity(),
  ));
}
