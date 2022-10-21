import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constance/end_points.dart';
import '../../modal/response_modal.dart';
import '../../modal/testimonial/testimonial_model.dart';
import '../../utils/storage/storage.dart';
import '../service_mixin.dart';

class HomeService with ServiceMixin {
  final Storage _storage = Storage.instance;

  Future<ResponseModal<List<TestimonialModel>>> fetchAllTestimonials() async {
    final header = {"Authorization": "Bearer ${_storage.token}"};
    final res = await http.get(parseUri(testimonials), headers: header);
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        final data = TestimonialModel.fromJsonList(jsonData["data"] ?? []);
        return ResponseModal.success(data: data);
      default:
        return errorResponse(res);
    }
  }
}
