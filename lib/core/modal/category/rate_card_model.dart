class RateCardModel {
  int id;
  int categoryId;
  int subCategoryId;
  int childCategoryId;
  int serviceId;
  String name;
  String description;
  int price;
  String image;
  String imageUrl;
  String status;
  List<RateCardPartModel> rateCardParts;
  String createdAt;
  String updatedAt;

  RateCardModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        categoryId = json['category_id'],
        subCategoryId = json['sub_category_id'],
        childCategoryId = json['child_category_id'],
        serviceId = json['service_id'],
        name = json['name'],
        description = json['description'] ?? "",
        price = json['price']??0,
        image = json['image'] ?? "",
        status = json['status'],
        rateCardParts = RateCardPartModel.fromJsonList(json["rate_card_parts"] ?? []),
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        imageUrl = json['image_url'] ?? "";

  static List<RateCardModel> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => RateCardModel.fromJson(data)).toList();
    }
    return [];
  }
}

class RateCardPartModel {
  int id;
  int rateCardId;
  String name;
  int price;
  String status;
  String createdAt;
  String updatedAt;

  RateCardPartModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        rateCardId = json['rate_card_id'],
        name = json['name'],
        price = json['price'],
        status = json['status'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  static List<RateCardPartModel> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => RateCardPartModel.fromJson(data)).toList();
    }
    return [];
  }
}
