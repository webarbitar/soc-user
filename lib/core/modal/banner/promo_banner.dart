class PromoBannerModal {
  int id;
  int categoryId;
  int subCategoryId;
  int childCategoryId;
  int serviceId;
  String image;
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  PromoBannerModal.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        categoryId = json['category_id'],
        subCategoryId = json['sub_category_id'],
        childCategoryId = json['child_category_id'],
        serviceId = json['service_id'],
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
