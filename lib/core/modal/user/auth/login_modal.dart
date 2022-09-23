class LoginModal {
  String mobile;
  String otp = "";

  LoginModal({required this.mobile});

  Map<String, String> otpMap() {
    return {"mobile": mobile};
  }

  Map<String, String> loginMap() {
    return {"mobile": mobile, "otp": otp};
  }
}
