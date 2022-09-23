class CityModal {
  int id;
  String name;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  CityModal.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        status = json["status"],
        createdAt = DateTime.parse(json["created_at"]),
        updatedAt = DateTime.parse(json["updated_at"]);

  static List<CityModal> parseFromList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => CityModal.fromJson(data)).toList();
    } else {
      return [];
    }
  }
}
