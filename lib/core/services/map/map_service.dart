import 'dart:convert';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../env.dart';
import '../../constance/end_points.dart';
import '../../enum/api_status.dart';
import '../../modal/address/geocode_address.dart';
import '../../modal/response_modal.dart';
import '../service_mixin.dart';

class MapService with ServiceMixin {
  Future<ResponseModal<GeocodeAddress>> fetchAddressFromGeocode({required LatLng position}) async {
    Uri uri = parseUri(
        "$mapGecode?latlng=${"${position.latitude},${position.longitude}"}&location_type=APPROXIMATE&key=$mapToken");
    final res = await http.get(uri);
    // log(res.body);
    try {
      switch (res.statusCode) {
        case 200:
          final jsonData = jsonDecode(res.body);
          if (jsonData["status"] == "OK" && (jsonData["results"] as List).isNotEmpty) {
            final data = GeocodeAddress.fromJson(jsonData["results"][0]);
            return ResponseModal.success(data: data);
          }
          return ResponseModal.error(status: ApiStatus.error, message: ServiceMixin.ERROR_MESSAGE);
        default:
          return errorResponse(res);
      }
    } catch (ex) {
      return exceptionResponse(ex);
    }
  }
}
