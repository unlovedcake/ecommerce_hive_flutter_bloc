import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/instances/firebase_instances.dart';
import 'package:hive/modules/404_screen.dart';
import 'package:hive/modules/dashboard/views/dashboard.dart';
import 'package:hive/modules/otp_code/views/otp_code.dart';

import 'package:hive/modules/sign_in/sign_in.dart';
import 'package:hive/modules/sign_up/sign_up.dart';
import 'package:hive/splash/views/spalsh.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    User? user;
    FirebaseAuth _auth = FirebaseAuth.instance;
    switch (settings.name) {
      case '/':
        // _auth.authStateChanges().listen((User? user) {
        //   _user = user;
        // });

        user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return MaterialPageRoute(
            builder: (_) => const SignIn(),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => const Splash(),
          );
        }

      case '/register':
        return MaterialPageRoute(
          builder: (_) => const SignUp(),
        );

      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const DashBoard(),
        );

      case '/otp_code':
        return MaterialPageRoute(
          builder: (_) => const OtpCode(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const PageNotFound(),
        );
    }
  }
}

class RouterPageAnimation {
  static routePageAnimation(BuildContext context, Route route) {
    Navigator.push(context, route);
  }

  static Route goToSignIn() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
      return TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 3000),
          builder: (context, value, child) {
            return ShaderMask(
                blendMode: BlendMode.colorBurn,
                shaderCallback: (rect) {
                  return RadialGradient(
                          radius: value * 5,
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.blue.withOpacity(0.8),
                            Colors.blue.withOpacity(0.8),
                          ],
                          stops: [0.0, 0.55, 0.6, 1.0],
                          center: const FractionalOffset(0.5, 0.5))
                      .createShader(rect);
                },
                child: const SignIn());
          });
    });
  }

  static Route goToSignUp() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
      return TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 3000),
          builder: (context, value, child) {
            return ShaderMask(
                blendMode: BlendMode.colorBurn,
                shaderCallback: (rect) {
                  return RadialGradient(
                          radius: value * 5,
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.blue.withOpacity(0.8),
                            Colors.blue.withOpacity(0.8),
                          ],
                          stops: [0.0, 0.55, 0.6, 1.0],
                          center: const FractionalOffset(0.5, 0.5))
                      .createShader(rect);
                },
                child: const SignUp());
          });
    });
  }

  static Route goToDashBoard() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
      return TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 3000),
          builder: (context, value, child) {
            return ShaderMask(
                blendMode: BlendMode.colorBurn,
                shaderCallback: (rect) {
                  return RadialGradient(
                          radius: value * 5,
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.blue.withOpacity(0.8),
                            Colors.blue.withOpacity(0.8),
                          ],
                          stops: [0.0, 0.55, 0.6, 1.0],
                          center: const FractionalOffset(0.5, 0.5))
                      .createShader(rect);
                },
                child: const DashBoard());
          });
    });
  }
}
