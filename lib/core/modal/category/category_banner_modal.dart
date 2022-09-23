import 'sub_category_modal.dart';

class CategoryBannerModal {
  String type;
  String link;
  List<SubCategoryModal> subCategories = [];

  CategoryBannerModal.fromJson(Map<String, dynamic> json)
      : type = json["banner"]["type"],
        link = json["banner"]["link"],
        subCategories = SubCategoryModal.parseSubCategoryList(json["sub_categories"]);
}
