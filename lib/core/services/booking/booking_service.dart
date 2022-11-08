import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socspl/core/modal/booking/booked_service_model.dart';
import 'package:socspl/core/modal/time_slot_model.dart';
import 'package:socspl/env.dart';
import '../../constance/end_points.dart';
import '../../modal/booking/booked_service_details_model.dart';
import '../../modal/booking/generate_paytm_token_model.dart';
import '../../modal/response_modal.dart';
import '../../modal/service/service_booking.dart';
import '../../utils/storage/storage.dart';
import '../service_mixin.dart';

class BookingService with ServiceMixin {
  final Storage _storage = Storage.instance;

  Future<ResponseModal<List<TimeSlotModel>>> fetchTimeSlots(int categoryId) async {
    var request = http.Request('GET', parseUri("$timeslot?category_id=$categoryId"));
    var header = {
      "Authorization": "Bearer ${_storage.token}",
      'Content-Type': 'application/json',
    };
    request.headers.addAll(header);
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    print(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = TimeSlotModel.fromJsonList(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<BookedServiceModel>> bookServices(Map<String, dynamic> data) async {
    var request = http.Request('POST', parseUri(booking));
    var header = {
      "Authorization": "Bearer ${_storage.token}",
      'Content-Type': 'application/json',
    };
    print(header);
    print(jsonEncode(data));
    request.headers.addAll(header);
    request.body = jsonEncode(data);
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    print(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = BookedServiceModel.fromJson(jsonData["data"]);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<List<BookedServiceModel>>> cancelBooking(int bookingId) async {
    var request = http.Request('POST', parseUri(bookingCancel));
    var header = {
      "Authorization": "Bearer ${_storage.token}",
      'Content-Type': 'application/json',
    };
    request.headers.addAll(header);
    request.body = jsonEncode({"booking_id": bookingId, "reason": "I want to do it"});
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    print(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = BookedServiceModel.fromJsonList(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<List<BookedServiceModel>>> fetchPendingBooking(int page) async {
    var request = http.Request('GET', parseUri("$pendingBooking?page=$page"));
    var header = {
      "Authorization": "Bearer ${_storage.token}",
      'Content-Type': 'application/json',
    };
    request.headers.addAll(header);
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    print(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = BookedServiceModel.fromJsonList(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<List<BookedServiceModel>>> fetchConfirmedBooking(int page) async {
    var request = http.Request('GET', parseUri("$confirmedBooking?page=$page"));
    var header = {
      "Authorization": "Bearer ${_storage.token}",
      'Content-Type': 'application/json',
    };
    request.headers.addAll(header);
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = BookedServiceModel.fromJsonList(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<List<BookedServiceModel>>> fetchOngoingBooking(int page) async {
    var request = http.Request('GET', parseUri("$ongoingBooking?page=$page"));
    var header = {
      "Authorization": "Bearer ${_storage.token}",
      'Content-Type': 'application/json',
    };
    request.headers.addAll(header);
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = BookedServiceModel.fromJsonList(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<List<BookedServiceModel>>> fetchCompletedBooking(int page) async {
    var request = http.Request('GET', parseUri("$completedBooking?page=$page"));
    var header = {
      "Authorization": "Bearer ${_storage.token}",
      'Content-Type': 'application/json',
    };
    request.headers.addAll(header);
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = BookedServiceModel.fromJsonList(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<BookedServiceDetailsModel>> fetchBookingDetailsById(int id) async {
    var request = http.Request('GET', parseUri("$baseUrl/booking/$id"));
    var header = {
      "Authorization": "Bearer ${_storage.token}",
      'Content-Type': 'application/json',
    };
    request.headers.addAll(header);
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    print(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = BookedServiceDetailsModel.fromJson(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal> acceptServiceBooking(int bookingId) async {
    var request = http.Request('POST', parseUri("$baseUrl/approve_estimatted_bill"));
    var header = {"Authorization": "Bearer ${_storage.token}", 'Content-Type': 'application/json'};
    print(header);
    request.headers.addAll(header);
    request.body = jsonEncode({'booking_id': bookingId});
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint("Request booking response $res");
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          // final data = BookedServiceModel.fromJsonList(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"]);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal> rejectServiceBooking(int bookingId) async {
    var request = http.Request('POST', parseUri("$baseUrl/reject_estimatted_bill"));
    var header = {"Authorization": "Bearer ${_storage.token}", 'Content-Type': 'application/json'};
    print(header);
    request.headers.addAll(header);
    request.body = jsonEncode({'booking_id': bookingId});
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint("Request booking response $res");
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          // final data = BookedServiceModel.fromJsonList(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"]);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal> payBookingByCash(int bookingId) async {
    var request = http.Request('POST', parseUri("$baseUrl/booking_payment_cash"));
    var header = {"Authorization": "Bearer ${_storage.token}", 'Content-Type': 'application/json'};
    print(header);
    request.headers.addAll(header);
    request.body = jsonEncode({'booking_id': bookingId});
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint("Request booking response $res");
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          // final data = BookedServiceModel.fromJsonList(jsonData["data"] ?? []);
          return ResponseModal.success(message: jsonData["message"]);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModal<GeneratePaytmTokenModel>> generatePaytmToken(int bookingId) async {
    var request = http.Request('POST', parseUri("$baseUrl/generate_payment_token"));
    var header = {"Authorization": "Bearer ${_storage.token}", 'Content-Type': 'application/json'};
    print(header);
    request.headers.addAll(header);
    request.body = jsonEncode({'booking_id': bookingId});
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint("Request booking response $res");
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          final data = GeneratePaytmTokenModel.fromJson(jsonData["data"]);
          return ResponseModal.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModal.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }
}
