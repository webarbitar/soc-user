class PromoBannerModal {
  int id;
  int categoryId;
  int subCategoryId;
  int childCategoryId;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  String imageUrl;

  PromoBannerModal.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        categoryId = json['category_id'],
        subCategoryId = json['sub_category_id'],
        childCategoryId = json['child_category_id'],
        image = json['image'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']),
        imageUrl = json['image_url'];

  static List<PromoBannerModal> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => PromoBannerModal.fromJson(data)).toList();
    }
    return [];
  }
}
