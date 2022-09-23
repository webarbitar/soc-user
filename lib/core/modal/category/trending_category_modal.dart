import 'package:socspl/core/modal/category/category_modal.dart';
import 'package:socspl/core/modal/category/sub_category_modal.dart';

class TrendingCategoryModal extends CategoryModal {
  List<SubCategoryModal> subCategories;

  TrendingCategoryModal.fromJson(Map<String, dynamic> json)
      : subCategories = SubCategoryModal.parseSubCategoryList(
          json["active_sub_categories_with_limit"],
        ),
        super.fromJson(json);

  static List<TrendingCategoryModal> parseFromList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => TrendingCategoryModal.fromJson(data)).toList();
    } else {
      return [];
    }
  }
}
