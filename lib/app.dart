import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/Logger/my_logger.dart';
import 'package:hive/routes/app_router.dart';

import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'bloc/Internet/internet_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/chat/chat_bloc.dart';
import 'bloc/favorites_bloc/favorites_bloc.dart';
import 'bloc/product_bloc/product_bloc.dart';
import 'bloc/search_bloc/search_bloc.dart';
import 'constants/asset_storage_image.dart';
import 'enums/flavor_enum.dart';
import 'modules/dashboard/views/dashboard.dart';
import 'modules/sign_in/sign_in.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.flavor,
    required this.connectivity,
  });

  final Connectivity connectivity;
  final Flavor flavor;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      MyLogger.printInfo('CURRENT FLAVOR: ${flavor.description}');
    }

    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (authContext) => AuthBloc(),
          ),
          BlocProvider<ProductBloc>(
            create: (productContext) => ProductBloc(),
          ),
          BlocProvider<FavoritesBloc>(
            create: (favoriteContext) => FavoritesBloc(),
          ),
          BlocProvider<SearchBloc>(
            create: (searchContext) => SearchBloc(),
            lazy: false,
          ),
          BlocProvider<ChatBloc>(
            create: (searchContext) => ChatBloc(),
            lazy: false,
          ),
          // BlocProvider<InternetBloc>(
          //   create: (internetContext) =>
          //       InternetBloc(connectivity: connectivity)
          //         ..add(InternetConnectedEvent()),
          // ),
        ],
        child: DevicePreview(
          enabled: false,
          builder: (context) => MaterialApp(
            initialRoute: '/',
            onGenerateRoute: AppRouter().onGenerateRoute,
            // initialRoute: '/',
            // routes: {
            //   '/': (context) => StreamBuilder<User?>(
            //       stream: FirebaseAuth.instance.authStateChanges(),
            //       builder: (context, snapshot) {
            //         // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return Scaffold(
            //             body: Container(
            //               color: Colors.blue,
            //               child: Center(
            //                 child: Image.asset(
            //                     width: 200,
            //                     height: 200,
            //                     AssetStorageImage.facebook),
            //                 // child: SpinKitFadingCircle(
            //                 //   color: Colors.blue,
            //                 //   size: 50.0,
            //                 // ),
            //               ),
            //             ),
            //           );
            //         }

            //         if (snapshot.hasData) {
            //           print('ddz');
            //           return const DashBoard();
            //         }

            //         return const SignIn();
            //       }),
            // },
            // home: StreamBuilder<User?>(
            //     stream: FirebaseAuth.instance.authStateChanges(),
            //     builder: (context, snapshot) {
            //       // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.

            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Scaffold(
            //           body: Container(
            //               color: Colors.white,
            //               child: const Center(
            //                   child: SpinKitFadingCircle(
            //                 color: Colors.blue,
            //                 size: 50.0,
            //               ))),
            //         );
            //       }
            //       if (snapshot.hasData) {
            //         return const DashBoard();
            //       }

            //       return const SignIn();
            //     }),
            title: '${flavor.title}AFEX Exhibitor',
            debugShowCheckedModeBanner: kDebugMode ? true : false,
            useInheritedMediaQuery: true,
            builder: (context, child) {
              child = ResponsiveWrapper.builder(
                ClampingScrollWrapper.builder(context, child!),
                minWidth: 360,
                defaultName: MOBILE,
                breakpoints: [
                  const ResponsiveBreakpoint.resize(360),
                  const ResponsiveBreakpoint.resize(480, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(640, name: 'PHABLET'),
                  const ResponsiveBreakpoint.autoScale(850, name: TABLET),
                  const ResponsiveBreakpoint.autoScale(1080, name: DESKTOP),
                ],
              );
              child = DevicePreview.appBuilder(context, child);
              return child;
            },
          ),
        ));
  }
}
