class AddOnModal {
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
  DateTime createdAt;
  DateTime updatedAt;

  AddOnModal.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        categoryId = json["category_id"],
        subCategoryId = json["sub_category_id"],
        childCategoryId = json["child_category_id"],
        serviceId = json["service_id"],
        price = json["price"],
        image = json["image"] ?? "",
        imageUrl = json["image_url"] ?? "",
        description = json["description"] ?? "",
        status = json["status"],
        createdAt = DateTime.parse(json["created_at"]),
        updatedAt = DateTime.parse(json["updated_at"]);

  static List<AddOnModal> parseFromList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => AddOnModal.fromJson(data)).toList();
    } else {
      return [];
    }
  }
}
