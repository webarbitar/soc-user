class SectionModal {
  int id;
  String title;
  String subtitle;
  String status;
  String createdAt;
  String updatedAt;
  List<ServiceModal> services = [];

  SectionModal.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        title = json['title'] ?? "",
        subtitle = json['subtitle'] ?? "",
        status = json['status'] ?? "",
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        services = ServiceModal.fromJsonList(json["active_services_with_limit"] ?? []);

  static List<SectionModal> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => SectionModal.fromJson(data)).toList();
    }
    return [];
  }
}

class ServiceModal {
  int id;
  int sectionId;
  int categoryId;
  int subCategoryId;
  int childCategoryId;
  int serviceId;
  String title;
  String subtitle;
  String image;
  String status;
  String createdAt;
  String updatedAt;
  String imageUrl;

  ServiceModal.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sectionId = json['section_id'],
        categoryId = json['category_id'] ?? 0,
        subCategoryId = json['sub_category_id'] ?? 0,
        childCategoryId = json['child_category_id'] ?? 0,
        serviceId = json['service_id'] ?? 0,
        title = json['title'],
        subtitle = json['subtitle'] ?? "",
        image = json['image'] ?? "",
        status = json['status'] ?? "",
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        imageUrl = json['image_url'] ?? "";

  static List<ServiceModal> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => ServiceModal.fromJson(data)).toList();
    }
    return [];
  }
}
