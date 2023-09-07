// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive/modules/sign_in/sign_in.dart';
// import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';
// import 'bloc/auth/auth_bloc.dart';
// import 'bloc/favorites_bloc/favorites_bloc.dart';
// import 'bloc/product_bloc/product_bloc.dart';
// import 'bloc/search_bloc/search_bloc.dart';
// import 'constants/sendbird_instance.dart';
// import 'firebase_options.dart';
// import 'instances/firebase_instances.dart';
// import 'modules/dashboard/views/dashboard.dart';
// import 'routes/app_router.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   sendBird = SendbirdSdk(appId: '51A3EFB8-6F6E-4E0D-862E-8ABDAD535D18');

//   runApp(MyApp(
//     appRouter: AppRouter(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({
//     Key? key,
//     required this.appRouter,
//   }) : super(key: key);
//   final AppRouter appRouter;
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthBloc>(
//           create: (authContext) => AuthBloc(),
//         ),
//         BlocProvider<ProductBloc>(
//           create: (productContext) => ProductBloc(),
//         ),
//         BlocProvider<FavoritesBloc>(
//           create: (favoriteContext) => FavoritesBloc(),
//         ),
//         BlocProvider<SearchBloc>(
//           create: (searchContext) => SearchBloc(),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         //home: DashBoard(),
//         // initialRoute: '/',
//         // onGenerateRoute: appRouter.onGenerateRoute,
//         home: StreamBuilder<User?>(
//             stream: FirebaseAuth.instance.authStateChanges(),
//             builder: (context, snapshot) {
//               // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const CircularProgressIndicator();
//               }
//               if (snapshot.hasData) {
//                 return const DashBoard();
//               }
//               // Otherwise, they're not signed in. Show the sign in page.
//               return const SignIn();
//             }),
//       ),
//     );
//   }
// }
