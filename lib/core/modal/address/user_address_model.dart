import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserAddressModel {
  int id;
  int userId;
  String name;
  String mobile;
  String flatNo;
  String area;
  String landmark;
  String pinCode;
  int cityId;
  String address;
  LatLng latLng;
  String type;
  String status;
  String createdAt;
  String updatedAt;

  UserAddressModel(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.flatNo,
      required this.area,
      required this.landmark,
      required this.pinCode,
      required this.latLng,
      required this.cityId,
      required this.address,
      required this.type})
      : userId = 0,
        status = "",
        createdAt = "",
        updatedAt = "";

  String get formattedAddress => "$flatNo $area, $landmark,";

  UserAddressModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        name = json['name'],
        mobile = json['mobile'],
        flatNo = json['flat_no'],
        area = json['area'],
        landmark = json['landmark'],
        pinCode = json['pincode'],
        cityId = json['city_id'],
        address = json['address']??"",
        latLng =
            LatLng((json['latitude'] ?? 0.0).toDouble(), (json['longitude'] ?? 0.0).toDouble()),
        type = json['type'],
        status = json['status'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  static List<UserAddressModel> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => UserAddressModel.fromJson(data)).toList();
    }
    return [];
  }

  Map<String, String> toMap() {
    final Map<String, String> data = {};
    if (id != 0) {
      data['id'] = id.toString();
    }
    data['user_id'] = userId.toString();
    data['name'] = name;
    data['mobile'] = mobile;
    data['flat_no'] = flatNo;
    data['area'] = area;
    data['landmark'] = landmark;
    data['pincode'] = pinCode;
    data["latitude"] = "${latLng.latitude}";
    data["longitude"] = "${latLng.longitude}";
    data["address"] = address;
    data['city_id'] = cityId.toString();
    data['type'] = type;
    return data;
  }
}
