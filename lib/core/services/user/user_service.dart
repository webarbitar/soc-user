import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socspl/core/constance/end_points.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/address/user_address_model.dart';

import '../../modal/response_modal.dart';
import '../../utils/storage/storage.dart';
import '../service_mixin.dart';
import 'package:http/http.dart' as http;

class UserService with ServiceMixin {
  final Storage _storage = Storage.instance;

  Future<ResponseModal> sendRegisterOtp(Map<String, String> data) async {
    var request = http.MultipartRequest('POST', parseUri(registerOtp));
    request.fields.addAll(data);

    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          return ResponseModal.success(message: jsonData["message"]);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal> registerUser(Map<String, String> data) async {
    var request = http.MultipartRequest('POST', Uri.parse(register));
    request.fields.addAll(data);

    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          return ResponseModal.success(message: jsonData["message"]);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal> sendLoginOtp(Map<String, String> data) async {
    var request = http.MultipartRequest('POST', parseUri(loginOtp));
    request.fields.addAll(data);
    http.StreamedResponse response = await request.send();

    final res = await response.stream.bytesToString();
    debugPrint(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          return ResponseModal.success(message: jsonData["message"]);
        } else {
          if (jsonData["message"] == "Mobile not found") {
            return ResponseModal.error(status: ApiStatus.notFound, message: jsonData["message"]);
          }
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal> loginUser(Map<String, String> data) async {
    var request = http.MultipartRequest('POST', Uri.parse(login));
    request.fields.addAll(data);
    http.StreamedResponse response = await request.send();

    final res = await response.stream.bytesToString();
    print(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          print(jsonData["token"]);
          _storage.setUser(jsonData["token"]);
          return ResponseModal.success(message: jsonData["message"]);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<List<UserAddressModel>>> fetchAddresses() async {
    var request = http.MultipartRequest('GET', parseUri("$address/list"));
    print({"Authorization": "Bearer ${Storage.instance.token}"});
    var header = {"Authorization": "Bearer ${Storage.instance.token}"};
    request.headers.addAll(header);
    http.StreamedResponse response = await request.send();

    final res = await response.stream.bytesToString();
    print(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = UserAddressModel.fromJsonList(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<UserAddressModel>> addAddress(Map<String, String> data) async {
    var request = http.MultipartRequest('POST', parseUri("$address/create"));
    var header = {"Authorization": "Bearer ${Storage.instance.token}"};
    request.headers.addAll(header);
    request.fields.addAll(data);

    http.StreamedResponse response = await request.send();

    final res = await response.stream.bytesToString();
    print(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = UserAddressModel.fromJson(jsonData["data"]);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<UserAddressModel>> updateAddress(Map<String, String> data) async {
    var request = http.MultipartRequest('POST', parseUri("$address/update"));
    var header = {"Authorization": "Bearer ${Storage.instance.token}"};
    request.headers.addAll(header);
    request.fields.addAll(data);
    http.StreamedResponse response = await request.send();

    final res = await response.stream.bytesToString();
    print(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = UserAddressModel.fromJson(jsonData["data"]);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }
}
