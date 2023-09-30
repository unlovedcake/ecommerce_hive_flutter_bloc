import 'package:flutter/cupertino.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

late final SendbirdSdk sendBird;

Map<String, dynamic> addToCart = {
  'id': '',
  'name': '',
  'quantity': '',
  'description': '',
  'price': '',
  'totalPrice': '',
};

List<Map<String, dynamic>> addToCartsListItem = [];

final totalQuantityCartItem = ValueNotifier<int>(0);
