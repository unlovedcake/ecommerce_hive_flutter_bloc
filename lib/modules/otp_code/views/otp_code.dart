import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/instances/firebase_instances.dart';
import 'package:hive/modules/phone_auth/views/phone_auth.dart';
import 'package:hive/modules/sign_in/sign_in.dart';

class OtpCode extends StatefulWidget {
  const OtpCode({
    super.key,
    this.title = '',
  });

  final String title;

  @override
  State<OtpCode> createState() => _OtpCodeState();
}

class _OtpCodeState extends State<OtpCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  shape: const StadiumBorder()),
              child: const Text('OTP CODE'),
              onPressed: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.title,
                    smsCode: '123456',
                  );
                  await firebaseAuth
                      .signInWithCredential(credential)
                      .then((value) {
                    print('User Login In Successful');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                      (route) => false,
                    );
                  });
                } catch (e) {
                  print(e);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
