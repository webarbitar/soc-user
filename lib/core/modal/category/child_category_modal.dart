class ChildCategoryModal {
  int id;
  String name;
  int categoryId;
  int subCategoryId;
  String description;
  String image;
  String imageUrl;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  ChildCategoryModal.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        categoryId = json["category_id"],
        subCategoryId = json["sub_category_id"],
        description = json["description"] ?? "",
        image = json["image"] ?? "",
        imageUrl = json["image_url"] ?? "",
        status = json["status"],
        createdAt = DateTime.parse(json["created_at"]),
        updatedAt = DateTime.parse(json["updated_at"]);

  static List<ChildCategoryModal> parseFromList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => ChildCategoryModal.fromJson(data)).toList();
    } else {
      return [];
    }
  }
}

