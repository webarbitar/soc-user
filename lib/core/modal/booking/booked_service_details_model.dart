import 'package:socspl/core/modal/category/add_on_modal.dart';

import '../category/rate_card_model.dart';
import 'booked_service_model.dart';
import 'custom_spare_model.dart';

class BookedServiceDetailsModel extends BookedServiceModel {
  ServiceProviderModel? serviceProvider;
  List<BookedService> services;

  List<BookedRateCard> rateCards;

  List<CustomSpareModel> spares;

  BookedServiceDetailsModel.fromJson(Map<String, dynamic> json)
      : serviceProvider = json["service_provider"] != null
            ? ServiceProviderModel.fromJson(json["service_provider"])
            : null,
        services = BookedService.fromJsonList(json["booking_services"] ?? []),
        rateCards = BookedRateCard.fromJsonList(json["booking_service_rate_cards"] ?? []),
        spares = CustomSpareModel.fromJsonList(json["booking_custom_parts"] ?? []),
        super.fromJson(json);

  int get totalSparePartsPrice {
    int serviceSp =
        services.map((e) => e.sparePartsTotalPrice).reduce((value, element) => value + element);

    int customSp = spares.isNotEmpty
        ? spares.map((e) => e.total).reduce((value, element) => value + element)
        : 0;
    return serviceSp + customSp;
  }

  int get totalSparePartsQuantity {
    int serviceSp =
        services.map((e) => e.sparePartsQuantity).reduce((value, element) => value + element);

    return serviceSp + spares.length;
  }
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
  List<BookedRateCard> rateCards;

  BookedService.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookingId = json['booking_id'],
        serviceId = json['service_id'],
        price = json['price'],
        quantity = json['quantity'],
        total = json['total'],
        addonService = BookedAddonService.fromJsonList(json["booking_service_add_ons"] ?? []),
        rateCards = BookedRateCard.fromJsonList(json["booking_rate_card_parts"] ?? []),
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  static List<BookedService> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((e) => BookedService.fromJson(e)).toList();
    }
    return [];
  }

  // ================================ Addon Getter Methods ================================
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


  // ================================ Spare Parts Getter Methods ================================

  int get sparePartsQuantity {
    if (rateCards.isNotEmpty) {
      return rateCards.map((e) => e.quantity).reduce((value, element) => value + element);
    }
    return 0;
  }

  int get sparePartsTotalPrice {
    if (rateCards.isNotEmpty) {
      return rateCards.map((e) => e.amount).reduce((value, element) => value + element);
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

class BookedRateCard {
  int id;
  int bookingId;
  int rateCardPartId;
  int price;
  int quantity;
  int amount;
  RateCardPartModel rateCard;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  BookedRateCard({
    this.id = 0,
    required this.bookingId,
    required this.quantity,
    this.rateCardPartId = 0,
    required this.price,
    required this.amount,
    required this.rateCard,
  });

  BookedRateCard.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookingId = json['booking_id'],
        rateCardPartId = json['rate_card_part_id'],
        price = json['price'],
        quantity = json['quantity'],
        rateCard = RateCardPartModel.fromJson(json["rate_card_part"]),
        amount = json['amount'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']);

  static List<BookedRateCard> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => BookedRateCard.fromJson(data)).toList();
    }
    return [];
  }

  BookedRateCard copyObject() {
    return BookedRateCard(
      id: id,
      bookingId: bookingId,
      quantity: quantity,
      rateCardPartId: rateCardPartId,
      price: price,
      amount: amount,
      rateCard: rateCard,
    );
  }

  Map<String, dynamic> toBookingUpdateMap() {
    return {
      "id": id,
      "quantity": quantity,
    };
  }
}

class ServiceProofModel {
  int id;
  int bookingId;
  int bookingServiceId;
  String type;
  String url;
  String createdAt;
  String updatedAt;
  String fullUrl;

  ServiceProofModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookingId = json['booking_id'],
        bookingServiceId = json['booking_service_id'],
        type = json['type'],
        url = json['url'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        fullUrl = json['full_url'];

  static List<ServiceProofModel> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((e) => ServiceProofModel.fromJson(e)).toList();
    }
    return [];
  }
}
