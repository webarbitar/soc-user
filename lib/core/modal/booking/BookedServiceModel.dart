import 'package:socspl/core/modal/address/user_address_model.dart';
import 'package:socspl/core/modal/category/category_modal.dart';
import 'package:socspl/core/modal/city_modal.dart';

class BookedServiceModel {
  int id;
  int userId;
  int? serviceProviderId;
  int categoryId;
  int cityId;
  int addressId;
  int amount;
  String date;
  String time;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  CityModal city;
  CategoryModal category;
  UserAddressModel address;

  BookedServiceModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        serviceProviderId = json['service_provider_id'],
        categoryId = json['category_id'],
        cityId = json['city_id'],
        addressId = json['address_id'],
        amount = json['amount'],
        date = json['date'],
        time = json['time'],
        status = json['status'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']),
        city = CityModal.fromJson(json["city"]),
        category = CategoryModal.fromJson(json['category']),
        address = UserAddressModel.fromJson(json["address"]);

  static List<BookedServiceModel> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((e) => BookedServiceModel.fromJson(e)).toList();
    }
    return [];
  }
}
