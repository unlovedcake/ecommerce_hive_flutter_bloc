import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/instances/firebase_instances.dart';
import 'package:hive/modules/404_screen.dart';
import 'package:hive/modules/dashboard/views/dashboard.dart';
import 'package:hive/modules/otp_code/views/otp_code.dart';
import 'package:hive/modules/phone_auth/views/phone_auth.dart';

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
  static Future<Navigator> routePageAnimation(
      BuildContext context, Navigator navigator) async {
    return navigator;
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

  static Route goToSignUp(Widget widget) {
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
                child: widget);
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

  static Route goToPage(Widget widget) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //   const begin = Offset(0.0, 1.0);
        //   const end = Offset.zero;
        //   const curve = Curves.ease;

        //   // final tween = Tween(begin: begin, end: end);
        //   // final curvedAnimation = CurvedAnimation(
        //   //   parent: animation,
        //   //   curve: curve,
        //   // );

        // var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        var offsetAnimation = animation.drive(tween);

        // return FadeTransition(
        //   opacity: Tween<double>(
        //     begin: 0,
        //     end: 1,
        //   ).animate(animation),

        // child: SizeTransition(
        //   sizeFactor: animation,
        //   axis: Axis.horizontal,
        //   axisAlignment: -1,
        //     child: Padding(
        //           padding: padding,
        //           child: child(index),
        //         ),
        // ),
        //
        // child: Align(
        //   child: SizeTransition(
        //     sizeFactor: animation,
        //     child: child,
        //     axisAlignment: 0.0,
        //   ),
        // ),

        // child: FadeTransition(
        //   opacity:animation,
        //   child: child,
        // ),

        // child: ScaleTransition(
        //   scale: animation,
        //   child: child,
        // ),

        // return SlideTransition(
        //   position: Tween<Offset>(
        //     begin: Offset(0, -0.1),
        //     end: Offset.zero,
        //   ).animate(animation),
        //   child: child,
        // );
        return SlideTransition(
          position: offsetAnimation,
          //position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
