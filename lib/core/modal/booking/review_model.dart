class ReviewModel {
  int id;
  int bookingId;
  int serviceProviderId;
  int rating;
  String review;
  String updatedAt;
  String createdAt;

  ReviewModel(
      {this.id = 0,
      required this.bookingId,
      required this.serviceProviderId,
      required this.rating,
      required this.review})
      : createdAt = DateTime.now().toString(),
        updatedAt = DateTime.now().toString();

  ReviewModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookingId = json['booking_id'],
        serviceProviderId = json['service_provider_id'],
        rating = json['rating'],
        review = json['review'],
        updatedAt = json['updated_at'],
        createdAt = json['created_at'];

  Map<String, dynamic> toMap() {
    return {
      "booking_id": bookingId,
      "service_provider_id": serviceProviderId,
      "rating": rating,
      "review": review,
    };
  }
}
