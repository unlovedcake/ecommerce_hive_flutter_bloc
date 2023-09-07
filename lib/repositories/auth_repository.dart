import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/Logger/my_logger.dart';
import 'package:hive/constants/sendbird_instance.dart';
import 'package:hive/instances/firebase_instances.dart';
import 'package:hive/models/sendbird_user_model.dart';
import 'package:hive/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  static final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signUps(
      {required String name,
      required String email,
      required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final defaultUrlProfileImage =
          'https://t3.ftcdn.net/jpg/02/09/37/00/360_F_209370065_JLXhrc5inEmGl52SyvSPeVB23hB6IjrR.jpg';
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // await userCredential.user!.updateProfile(
      //   displayName: name,
      //   photoURL:
      //       'https://img.freepik.com/premium-vector/business-global-economy_24877-41082.jpg',
      // );
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.updatePhotoURL(defaultUrlProfileImage);

      final user = UserModel(
          id: _firebaseAuth.currentUser!.uid, name: name, email: email);

      await fireStore.collection('users').doc(user.id).set(user.toMap());
      MyLogger.printInfo('Successfully Registered.');

      final apiUrl =
          'https://api-51A3EFB8-6F6E-4E0D-862E-8ABDAD535D18.sendbird.com/v3/users'; // Replace with your API URL
      final apiToken = 'b5a78407a708a4f11623de4a8296df490abe2648';

      final headers = {
        'Content-Type': 'application/json',
        'Api-Token': apiToken,
      };

      final body = {
        "user_id": _firebaseAuth.currentUser!.uid,
        "nickname": name,
        "issue_access_token": true,
        "profile_url": defaultUrlProfileImage,
        "metadata": {"role": "user"}
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        MyLogger.printInfo(
            'Sendbird user created successfully  ${response.body}');

        Map<String, dynamic> jsonDataMap = json.decode(response.body);
        String accessToken = jsonDataMap['access_token'];

        final userRef = fireStore
            .collection('sendbird_users')
            .doc(_firebaseAuth.currentUser!.uid);

        await userRef.set({
          'user_id': _firebaseAuth.currentUser!.uid,
          'nickname': name,
          'is_active': true,
          'role': 'user',
          'profile_url': defaultUrlProfileImage,
          'email': email,
          'access_token': accessToken,
          'created_at': DateTime.now(),
          'updated_at': DateTime.now(),
        });

        final sendBirdUser =
            await getSendbirdUser(_firebaseAuth.currentUser!.uid);

        await sendBird.connect(
          sendBirdUser.userId,
          accessToken: sendBirdUser.accessToken,
        );
        MyLogger.printInfo('CONNECTED TO SENDBIRD');
      }
    }
    // on FirebaseAuthException catch (e) {
    //   MyLogger.printError(e);
    //   if (e.code == 'weak-password') {
    //     throw Exception('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     throw Exception('The account already exists for that email.');
    //   } else if (e.code == 'invalid-email') {
    //     throw Exception('The email address is badly formatted.');
    //   }
    // }
    catch (e) {
      MyLogger.printError(e);
      throw Exception(e.toString());
    }
  }

  static Future<SendbirdUser> getSendbirdUser(String sendbirdUserId) async {
    try {
      final docRef = fireStore.collection('sendbird_users').doc(sendbirdUserId);
      final doc = await docRef.get();
      // ignore: cast_nullable_to_non_nullable
      final map = doc.data() as Map<String, dynamic>;
      final sendbirdUser = SendbirdUser.fromMap(map);
      return sendbirdUser;
    } catch (_) {
      rethrow;
    }
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      MyLogger.printInfo('You are now logged in.');

      final sendBirdUser =
          await getSendbirdUser(_firebaseAuth.currentUser!.uid);

      await sendBird.connect(
        sendBirdUser.userId,
        accessToken: sendBirdUser.accessToken,
      );
      MyLogger.printInfo('CONNECTED TO SENDBIRD');
    }
    // on FirebaseAuthException catch (e) {
    //   MyLogger.printError(e);
    //   if (e.code == 'user-not-found') {
    //     throw Exception('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     throw Exception('Wrong password provided for that user.');
    //   }
    // }
    catch (e) {
      MyLogger.printError(e);
      throw Exception(e.toString());
    }
  }

  static Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      MyLogger.printError('You are now signed with Google Account');
    } catch (e) {
      MyLogger.printError(e);
      throw Exception(e.toString());
    }
  }

  static Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> addUser(UserModel user) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(user.id).set(user.toMap());
  }
}
