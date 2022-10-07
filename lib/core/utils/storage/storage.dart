import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socspl/core/modal/city_modal.dart';

class Storage {
  Storage._();

  static final Storage instance = Storage._();

  late SharedPreferences pref;

  Future<void> initializeStorage() async {
    pref = await SharedPreferences.getInstance();
  }

  bool get isLogin => pref.getBool("isLoggedIn") ?? false;

  String get token => pref.getString("token") ?? "";

  String? get address => pref.getString("address");

  String? get city => pref.getString("city");

  LatLng get latLng => LatLng(pref.getDouble("lat") ?? 0.0, pref.getDouble("lng") ?? 0.0);

  Future<void> setUser(String tokenVal) async {
    print(tokenVal);
    await pref.setString("token", tokenVal);
    await pref.setBool("isLoggedIn", true);
  }

  Future<void> setLocation({
    required LatLng latLng,
    required String address,
    required CityModal city,
  }) async {
    await pref.setDouble("lat", latLng.latitude);
    await pref.setDouble("lng", latLng.longitude);
    await pref.setString("address", address);
    await pref.setString("city", city.name);
  }

  Future<void> logout() async {
    await pref.setBool("isLoggedIn", false);
    await pref.remove(token);
  }
}
