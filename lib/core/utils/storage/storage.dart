import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Storage._();

  static final Storage instance = Storage._();

  late SharedPreferences pref;

  Future<void> initializeStorage() async {
    pref = await SharedPreferences.getInstance();
  }

  bool get isLogin => pref.getBool("isLoggedIn") ?? false;

  String get token => pref.getString("token") ?? "";

  Future<void> setUser(String tokenVal) async {
    await pref.setString("token", tokenVal);
    await pref.setBool("isLoggedIn", true);
  }

  Future<void> logout() async {
    await pref.setBool("isLoggedIn", false);
  }
}
