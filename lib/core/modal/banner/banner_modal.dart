class BannerModal {
  int id;
  int categoryId;
  int subCategoryId;
  int childCategoryId;
  String image;
  String imageUrl;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  BannerModal.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        categoryId = json["category_id"],
        subCategoryId = json["sub_category_id"],
        childCategoryId = json["child_category_id"],
        image = json["image"],
        imageUrl = json["image_url"],
        status = json["status"],
        createdAt = DateTime.parse(json["created_at"]),
        updatedAt = DateTime.parse(json["updated_at"]);

  static List<BannerModal> parseFromList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => BannerModal.fromJson(data)).toList();
    }
    return [];
  }
}
