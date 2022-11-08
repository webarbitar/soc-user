class CustomSpareModel {
  int id;
  int bookingId;
  String name;
  int quantity;
  int amount;
  int total;
  String billImage;
  String billImageUrl;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  CustomSpareModel({
    this.id = 0,
    required this.bookingId,
    required this.name,
    this.quantity = 1,
    required this.amount,
    required this.total,
    required this.billImage,
    this.billImageUrl = "",
  });

  CustomSpareModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookingId = json['booking_id'],
        name = json['name'],
        quantity = json['quantity'],
        amount = json['amount'],
        total = json['total'],
        billImage = json['bill_image'],
        billImageUrl = json['bill_image_url'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']);

  static List<CustomSpareModel> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((data) => CustomSpareModel.fromJson(data)).toList();
    }
    return [];
  }

  Map<String, String> toMap() {
    return {
      'booking_id': bookingId.toString(),
      'name': name,
      'amount': amount.toString(),
      'total': total.toString()
    };
  }
}
