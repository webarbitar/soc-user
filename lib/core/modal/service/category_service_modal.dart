import 'package:socspl/core/modal/category/add_on_modal.dart';

class CategoryServiceModal {
  int id;
  String name;
  int categoryId;
  int subCategoryId;
  int childCategoryId;
  String description;
  String image;
  String status;
  String createdAt;
  String updatedAt;
  String imageUrl;
  List<PriceModal> prices;
  List<AddOnModal> addOns;

  CategoryServiceModal.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categoryId = json['category_id'],
        subCategoryId = json['sub_category_id'],
        childCategoryId = json['child_category_id'],
        description = json['description'],
        image = json['image'],
        status = json['status'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        imageUrl = json['image_url'],
        prices = PriceModal.parseFromList(json["prices"] ?? []),
        addOns = AddOnModal.parseFromList(json["add_ons"] ?? []);

  static List<CategoryServiceModal> parseFromList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => CategoryServiceModal.fromJson(data)).toList();
    } else {
      return [];
    }
  }
}

class PriceModal {
  int id;
  int cityId;
  int serviceId;
  int price;
  DateTime createdAt;
  DateTime updatedAt;

  PriceModal.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        cityId = json["city_id"],
        serviceId = json["service_id"],
        price = json["price"],
        createdAt = DateTime.parse(json["created_at"]),
        updatedAt = DateTime.parse(json["updated_at"]);

  static List<PriceModal> parseFromList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => PriceModal.fromJson(data)).toList();
    } else {
      return [];
    }
  }
}
