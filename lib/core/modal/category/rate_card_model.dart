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
        price = json['price'],
        image = json['image'] ?? "",
        status = json['status'],
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
