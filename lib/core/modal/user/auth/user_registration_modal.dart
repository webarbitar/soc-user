class UserRegistrationModal {
  String mobile;
  String otp;
  String fcmToken;

  UserRegistrationModal({required this.mobile, this.otp = "", this.fcmToken = ""});

  Map<String, String> otpMap() {
    return {"mobile": mobile};
  }

  Map<String, String> registerMap() {
    return {'otp': otp, 'mobile': mobile, 'fcm_token': fcmToken};
  }
}
