import 'dart:async';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socspl/core/modal/city_modal.dart';

import '../../modal/cart/cart_model.dart';

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

  List<Map<String, dynamic>> get carts =>
      pref.getStringList("carts")?.map((e) => jsonDecode(e) as Map<String, dynamic>).toList() ?? [];

  void updateLocalCart(List<CartModel> list) async {
    await pref.setStringList("carts", list.map((e) => jsonEncode(e.toLocalStorageMap())).toList());
    print('update to cart');
    print('*******');
    print('*******');
    print('*******');
    print(Storage.instance.pref.getStringList("carts"));
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
