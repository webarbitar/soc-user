class UserModel {
  int id;
  String name;
  String email;
  String mobile;
  String role;
  String status;
  String image;
  String updateMobile;
  int verifiedByVendor;
  int verifiedByAdmin;
  String referralCode;
  String deviceType;
  String fcmToken;
  DateTime createdAt;
  DateTime updatedAt;
  String imageUrl;

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        mobile = json['mobile'],
        role = json['role'],
        status = json['status'],
        image = json['image'] ?? "",
        updateMobile = json['update_mobile'].toString(),
        verifiedByVendor = json['verified_by_vendor'],
        verifiedByAdmin = json['verified_by_admin'],
        referralCode = json['referral_code'],
        deviceType = json['device_type'],
        fcmToken = json['fcm_token'] ?? "",
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']),
        imageUrl = json['image_url'] ?? "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['role'] = role;
    data['status'] = status;
    data['image'] = image;
    data['update_mobile'] = updateMobile;
    data['verified_by_vendor'] = verifiedByVendor;
    data['verified_by_admin'] = verifiedByAdmin;
    data['referral_code'] = referralCode;
    data['device_type'] = deviceType;
    data['fcm_token'] = fcmToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    return data;
  }
}
