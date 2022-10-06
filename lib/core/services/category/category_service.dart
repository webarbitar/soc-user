import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socspl/core/modal/category/add_on_modal.dart';
import 'package:socspl/core/modal/category/category_banner_modal.dart';
import 'package:socspl/core/modal/category/category_modal.dart';
import 'package:http/http.dart' as http;
import 'package:socspl/core/modal/category/child_category_modal.dart';
import 'package:socspl/core/modal/category/rate_card_model.dart';
import 'package:socspl/core/modal/category/sub_category_modal.dart';
import 'package:socspl/core/modal/category/trending_category_modal.dart';
import 'package:socspl/core/modal/section/section_modal.dart';
import 'package:socspl/ui/views/service/service_view.dart';

import '../../../env.dart';
import '../../constance/end_points.dart';
import '../../modal/city_modal.dart';
import '../../modal/response_modal.dart';
import '../../modal/service/category_service_modal.dart';
import '../../utils/storage/storage.dart';
import '../service_mixin.dart';

class CategoryService with ServiceMixin {
  final Storage _storage = Storage.instance;

  Future<ResponseModal<List<CategoryModal>>> fetchAllCategory(String cityId) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(parseUri("$category?city_id=$cityId"), headers: header);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = CategoryModal.parseFromList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<List<TrendingCategoryModal>>> fetchTrendingCategory(String cityId) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(parseUri("$trendingCategory?city_id=$cityId"), headers: header);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = TrendingCategoryModal.parseFromList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<List<CityModal>>> checkCityAvailability(String search) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    debugPrint("*");
    debugPrint("*");
    debugPrint(search);
    debugPrint("*");
    debugPrint("*");
    final res = await http.get(
      parseUri("$cities?search=$search"),
      headers: header,
    );
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = CityModal.parseFromList(jsonData["data"]);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<CategoryBannerModal>> fetchSubCategoryById(int id, String cityId,
      {String search = ""}) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(
      parseUri("$subCategory?category_id=$id&search=$search&city_id=$cityId"),
      headers: header,
    );
    print(res.body);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = CategoryBannerModal.fromJson(jsonData["data"]);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<List<ChildCategoryModal>>> fetchChildCategoryById(
      String categoryId, String subCategoryId, String cityId,
      {String search = ""}) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(
      parseUri(
          "$childCategory?category_id=$categoryId&sub_category_id=$subCategoryId&search=$search&city_id=$cityId"),
      headers: header,
    );
    print(res.body);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = ChildCategoryModal.parseFromList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<List<CategoryServiceModal>>> fetchAllServicesByCategoryIds(
      String categoryId, String subCategoryId, String childCategoryId, String cityId,
      {String search = ""}) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(
      parseUri(
          "$serviceCategory?category_id=$categoryId&sub_category_id=$subCategoryId&child_category_id=$childCategoryId&search=$search&city_id=$cityId"),
      headers: header,
    );
    print(res.body);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = CategoryServiceModal.parseFromList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<CategoryServiceModal>> fetchServiceById(String id, String cityId) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(
      parseUri("$baseUrl/service/$id?city_id=$cityId"),
      headers: header,
    );
    print(res.body);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        if (jsonData["status"]) {
          final data = CategoryServiceModal.fromJson(jsonData["data"]);
          return ResponseModal.success(data: data);
        }
        return ResponseModal.error(message: "Something went wrong. Please try again later");
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<List<AddOnModal>>> fetchAddOnCategoryByChildCategory(int childCategoryId,
      {String search = ""}) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(
      parseUri("$addOn?child_category_id=$childCategoryId&search=$search"),
      headers: header,
    );
    print(res.body);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = AddOnModal.parseFromList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<List<SectionModal>>> fetchSections({String search = ""}) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(
      parseUri("$section?search=$search"),
      headers: header,
    );
    print(res.body);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = SectionModal.fromJsonList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }

  Future<ResponseModal<List<RateCardModel>>> fetchRateCard(int childCategoryId) async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(
      parseUri("$rateCard?child_category_id=$childCategoryId"),
      headers: header,
    );
    print(res.body);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = RateCardModel.fromJsonList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }
}
