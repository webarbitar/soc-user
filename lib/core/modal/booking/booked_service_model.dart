import '../address/user_address_model.dart';
import '../category/category_modal.dart';
import '../city_modal.dart';

class BookedServiceModel {
  int id;
  String bookingId;
  int userId;
  int? serviceProviderId;
  int categoryId;
  int cityId;
  int addressId;
  int amount;
  int otp;
  int otpVerified;
  DateTime? otpVerifiedTime;
  String selfie;
  int estimatedBillSubmitted;
  String estimatedBillStatus;
  DateTime? jobStartTime;
  DateTime? jobEndTime;
  int? completeOtp;
  int completeOtpVerified;
  DateTime? completeOtpTime;
  String? reason;
  String? paymentMode;
  String paymentStatus;
  int serviceProviderAmount;
  int commission;
  String selfieUrl;
  String date;
  String time;
  String status;
  CityModal city;
  CategoryModal category;
  UserAddressModel address;
  DateTime createdAt;
  DateTime updatedAt;

  BookedServiceModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookingId = json['booking_id'],
        userId = json['user_id'],
        serviceProviderId = json['service_provider_id'],
        categoryId = json['category_id'],
        cityId = json['city_id'],
        addressId = json['address_id'],
        amount = json['amount'],
        date = json['date'],
        time = json['time'],
        otp = json["otp"],
        otpVerified = json["otp_verified"],
        otpVerifiedTime = DateTime.tryParse(json['otp_verified_time'] ?? ""),
        selfie = json['selfie'] ?? "",
        estimatedBillSubmitted = json["estimated_bill_submitted"],
        estimatedBillStatus = json["estimated_bill_status"],
        jobStartTime = DateTime.tryParse(json['job_start_time'] ?? ""),
        jobEndTime = DateTime.tryParse(json['job_end_time'] ?? ""),
        completeOtp = json['complete_otp'],
        completeOtpVerified = json['complete_otp_verified'],
        completeOtpTime = DateTime.tryParse(json['complete_otp_time'] ?? ""),
        reason = json['reason'],
        paymentMode = json['payment_mode'],
        paymentStatus = json['payment_status'],
        serviceProviderAmount = json['service_provider_amount']?.round() ?? 0,
        commission = json['commission'].round(),
        selfieUrl = json['selfie_url'] ?? "",
        status = json['status'],
        createdAt = DateTime.parse(json['created_at'] ?? ""),
        updatedAt = DateTime.parse(json['updated_at'] ?? ""),
        city = CityModal.fromJson(json["city"]),
        category = CategoryModal.fromJson(json['category']),
        address = UserAddressModel.fromJson(json["address"]);

  static List<BookedServiceModel> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((e) => BookedServiceModel.fromJson(e)).toList();
    }
    return [];
  }

  DateTime get bookingDateTime => DateTime.parse("$date $time");
}
