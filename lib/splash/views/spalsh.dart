import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/constants/asset_storage_image.dart';
import 'package:hive/modules/404_screen.dart';
import 'package:hive/modules/dashboard/views/dashboard.dart';
import 'package:hive/modules/sign_in/sign_in.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

User? user;
FirebaseAuth _auth = FirebaseAuth.instance;

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 5)),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const PageNotFound();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetStorageImage.commerceHiveLogo,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                  const SpinKitFadingCircle(
                    color: Colors.blue,
                    size: 50.0,
                  ),
                  const Text('Loading')
                ],
              );
            }

            return const DashBoard();
          }),
    );
  }
}
