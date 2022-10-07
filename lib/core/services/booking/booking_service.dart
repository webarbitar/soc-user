import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:socspl/core/modal/booking/BookedServiceModel.dart';
import 'package:socspl/core/modal/time_slot_model.dart';
import '../../constance/end_points.dart';
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

  Future<ResponseModal> bookServices(Map<String, dynamic> data) async {
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
          // final data = ServiceBooking.fromJson(jsonData["data"]);
          return ResponseModal.success(message: jsonData["message"]);
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

  Future<ResponseModal<List<BookedServiceModel>>> fetchCompletedBooking(int page) async {
    var request = http.Request('GET', parseUri("$completedBooking?page=$page"));
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
}
