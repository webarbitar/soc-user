import 'package:socspl/core/modal/category/category_modal.dart';

class SubCategoryModal extends CategoryModal {
  int categoryId;

  SubCategoryModal.fromJson(Map<String, dynamic> json)
      : categoryId = json["category_id"],
        super.fromJson(json);

  static List<SubCategoryModal> parseSubCategoryList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => SubCategoryModal.fromJson(data)).toList();
    } else {
      return [];
    }
  }
}
