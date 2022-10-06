import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../constance/end_points.dart';
import '../../modal/response_modal.dart';
import '../../modal/service/service_booking.dart';
import '../../utils/storage/storage.dart';
import '../service_mixin.dart';

class BookingService with ServiceMixin {
  final Storage _storage = Storage.instance;

  Future<ResponseModal> bookServices(Map<String, dynamic> data) async {
    var request = http.Request('POST', parseUri(booking));
    var header = {"Authorization": "Bearer ${_storage.token}"};
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
}
