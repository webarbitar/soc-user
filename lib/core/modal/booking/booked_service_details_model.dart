import 'package:socspl/core/modal/category/add_on_modal.dart';

import 'booked_service_model.dart';

class BookedServiceDetailsModel extends BookedServiceModel {
  ServiceProviderModel? serviceProvider;
  List<BookedService> services;

  BookedServiceDetailsModel.fromJson(Map<String, dynamic> json)
      : serviceProvider = json["service_provider"] != null
            ? ServiceProviderModel.fromJson(json["service_provider"])
            : null,
        services = BookedService.fromJsonList(json["booking_services"]),
        super.fromJson(json);
}

class BookedService {
  int id;
  int bookingId;
  int serviceId;
  int price;
  int quantity;
  int total;
  String createdAt;
  String updatedAt;
  List<BookedAddonService> addonService;

  BookedService.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookingId = json['booking_id'],
        serviceId = json['service_id'],
        price = json['price'],
        quantity = json['quantity'],
        total = json['total'],
        addonService = BookedAddonService.fromJsonList(json["booking_service_add_ons"] ?? []),
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  static List<BookedService> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((e) => BookedService.fromJson(e)).toList();
    }
    return [];
  }

  int get addonQuantity {
    if (addonService.isNotEmpty) {
      return addonService.map((e) => e.quantity).reduce((value, element) => value + element);
    }
    return 0;
  }

  int get addonTotalPrice {
    if (addonService.isNotEmpty) {
      return addonService.map((e) => e.total).reduce((value, element) => value + element);
    }
    return 0;
  }
}

class ServiceProviderModel {
  int id;
  int vendorId;
  int cityId;
  String name;
  String email;
  String mobile;
  String role;
  String status;
  String image;
  int verifiedByVendor;
  int verifiedByAdmin;
  String referralCode;
  double latitude;
  double longitude;
  String createdAt;
  String updatedAt;
  String imageUrl;

  ServiceProviderModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        vendorId = json['vendor_id'],
        cityId = json['city_id'],
        name = json['name'],
        email = json['email'],
        mobile = json['mobile'],
        role = json['role'],
        status = json['status'],
        image = json['image'],
        verifiedByVendor = json['verified_by_vendor'],
        verifiedByAdmin = json['verified_by_admin'],
        referralCode = json['referral_code'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        imageUrl = json['image_url'];
}

class BookedAddonService {
  int id;
  int bookingId;
  int bookingServiceId;
  int addOnId;
  int price;
  int quantity;
  int total;
  AddOnModal addOn;
  String createdAt;
  String updatedAt;

  BookedAddonService.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookingId = json['booking_id'],
        bookingServiceId = json['booking_service_id'],
        addOnId = json['add_on_id'],
        price = json['price'],
        quantity = json['quantity'],
        total = json['total'],
        addOn = AddOnModal.fromJson(json["add_on"]),
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  static List<BookedAddonService> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => BookedAddonService.fromJson(data)).toList();
    }
    return [];
  }
}
