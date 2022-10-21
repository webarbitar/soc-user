class TestimonialModel {
  int id;
  String name;
  String title;
  String description;
  int rating;
  String createdAt;
  String updatedAt;

  TestimonialModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        title = json['title'],
        description = json['description'],
        rating = json['rating'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  static List<TestimonialModel> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => TestimonialModel.fromJson(data)).toList();
    }
    return [];
  }
}
