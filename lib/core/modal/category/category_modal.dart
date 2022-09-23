import 'package:socspl/core/modal/category/sub_category_modal.dart';

class CategoryModal {
  int id;
  String name;
  String description;
  String image;
  String imageUrl;
  String? video;
  String? videoUrl;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  List<SubCategoryModal> subcategories;

  CategoryModal.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        description = json["description"] ?? "",
        image = json["image"],
        imageUrl = json["image_url"],
        video = json["video"],
        videoUrl = json["video_url"],
        status = json["status"],
        createdAt = DateTime.parse(json["created_at"]),
        updatedAt = DateTime.parse(json["updated_at"]),
        subcategories = SubCategoryModal.parseSubCategoryList(json["sub_categories"] ?? []);

  static List<CategoryModal> parseFromList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => CategoryModal.fromJson(data)).toList();
    }
    return [];
  }
}
