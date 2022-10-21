import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:socspl/core/constance/end_points.dart';
import 'package:socspl/core/modal/banner/banner_modal.dart';
import 'package:socspl/core/services/service_mixin.dart';
import 'package:socspl/core/utils/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:socspl/env.dart';

import '../../modal/banner/promo_banner.dart';
import '../../modal/response_modal.dart';

class BannerService with ServiceMixin {
  final Storage _storage = Storage.instance;

  Future<ResponseModal<List<BannerModal>>> fetchAllBanner(String cityId) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(parseUri("$banner?city_id=$cityId"), headers: header);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = BannerModal.parseFromList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<List<BannerModal>>> fetchHomeBanners() async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(parseUri(homeBanner), headers: header);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        if (jsonData["status"]) {
          final data = BannerModal.fromJson(jsonData["data"]["banner1"]);
          final data1 = BannerModal.fromJson(jsonData["data"]["banner2"]);
          final data2 = BannerModal.fromJson(jsonData["data"]["banner3"]);
          return ResponseModal.success(data: [data, data1, data2]);
        }
        return ResponseModal.error(message: jsonData["message"]);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<List<PromoBannerModal>>> fetchAllOfferBanner(String cityId) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(parseUri("$offerBanner?city_id=$cityId"), headers: header);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = PromoBannerModal.fromJsonList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<List<PromoBannerModal>>> fetchAllWorkBanner(String cityId) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(parseUri("$workBanner?city_id=$cityId"), headers: header);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = PromoBannerModal.fromJsonList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }
}
