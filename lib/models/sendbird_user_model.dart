import 'package:cloud_firestore/cloud_firestore.dart';

class SendbirdUser {
  static const PROFILE_URL = 'profile_url';
  static const USER_ID = 'user_id';
  static const IS_ACTIVE = 'is_active';
  static const NICKNAME = 'nickname';
  static const EMAIL = 'email';
  static const ACCESS_TOKEN = 'access_token';
  static const ROLE = 'role';
  static const CREATED_AT = 'created_at';
  static const UPDATED_AT = 'updated_at';

  final String profileUrl;
  final String userId;
  final bool isActive;
  final String email;
  final String nickname;
  final String accessToken;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  SendbirdUser({
    required this.profileUrl,
    required this.userId,
    required this.isActive,
    required this.email,
    required this.nickname,
    required this.accessToken,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SendbirdUser.fromMap(Map<String, dynamic> map) {
    return SendbirdUser(
      profileUrl: map[PROFILE_URL] as String,
      userId: map[USER_ID] as String,
      isActive: map[IS_ACTIVE] as bool,
      email: map[EMAIL] as String,
      nickname: map[NICKNAME] as String,
      accessToken: map[ACCESS_TOKEN] as String,
      role: map[ROLE] as String,
      createdAt: (map[CREATED_AT] as Timestamp).toDate(),
      updatedAt: (map[CREATED_AT] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      PROFILE_URL: profileUrl,
      USER_ID: userId,
      IS_ACTIVE: isActive,
      EMAIL: email,
      NICKNAME: nickname,
      ACCESS_TOKEN: accessToken,
      ROLE: role,
      CREATED_AT: FieldValue.serverTimestamp(),
      UPDATED_AT: FieldValue.serverTimestamp(),
    };
  }
}
