class UserRegistrationModal {
  String mobile;
  String otp = "";

  UserRegistrationModal({required this.mobile});

  Map<String, String> otpMap() {
    return {"mobile": mobile};
  }

  Map<String, String> registerMap() {
    return {
      'otp': otp,
      'mobile': mobile,
    };
  }
}
