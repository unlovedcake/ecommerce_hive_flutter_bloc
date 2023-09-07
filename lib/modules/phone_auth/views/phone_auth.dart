import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/instances/firebase_instances.dart';
import 'package:hive/modules/otp_code/views/otp_code.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phoneController = TextEditingController();
  var receivedID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            child: IntlPhoneField(
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'PH',
              onChanged: (phone) {
                phoneController.text = phone.completeNumber;
                print(phone.completeNumber);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                shape: const StadiumBorder()),
            child: const Text('Verify Phone'),
            onPressed: () async {
              firebaseAuth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                timeout: const Duration(seconds: 60),
                verificationCompleted: (PhoneAuthCredential credential) async {
                  await firebaseAuth.signInWithCredential(credential).then(
                        (value) => print('Logged In Successfully'),
                      );

                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     '/otp_code', (Route route) => false);
                },
                verificationFailed: (FirebaseAuthException e) {
                  print(e.message);
                  print('error phone auth');
                },
                codeSent: (String verificationId, int? resendToken) {
                  receivedID = verificationId;

                  print('Received ID:' + receivedID);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpCode(title: receivedID),
                    ),
                  );

                  setState(() {});
                },
                codeAutoRetrievalTimeout: (String verificationId) {
                  print('TimeOut');
                },
              );
            },
          ),
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
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: receivedID,
                smsCode: '123456',
              );
              await firebaseAuth
                  .signInWithCredential(credential)
                  .then((value) => print('User Login In Successful'));
            },
          )
        ],
      ),
    ));
  }
}
