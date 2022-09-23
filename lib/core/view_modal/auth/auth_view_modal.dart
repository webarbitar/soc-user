import 'package:socspl/core/modal/user/auth/login_modal.dart';
import 'package:socspl/core/modal/user/auth/user_registration_modal.dart';
import 'package:socspl/core/services/user/user_service.dart';
import 'package:socspl/core/view_modal/base_view_modal.dart';

import '../../modal/response_modal.dart';

class AuthViewModal extends BaseViewModal {
  late UserService _userService;

  set userService(UserService value) {
    _userService = value;
  }

  bool isLogin = true;

  UserRegistrationModal? _registrationModal;

  UserRegistrationModal? get registrationModal => _registrationModal;

  LoginModal? _loginModal;

  LoginModal? get loginModal => _loginModal;

  Future<ResponseModal> sendRegisterOtp(UserRegistrationModal modal) async {
    isLogin = false;
    _registrationModal = modal;
    final res = _userService.sendRegisterOtp(modal.otpMap());
    return res;
  }

  Future<ResponseModal> registerUser(String otp) async {
    _registrationModal!.otp = otp;
    final res = _userService.registerUser(_registrationModal!.registerMap());
    return res;
  }

  Future<ResponseModal> sendLoginOtp(LoginModal modal) async {
    isLogin = true;
    _loginModal = modal;
    final res = _userService.sendLoginOtp(modal.otpMap());
    return res;
  }

  Future<ResponseModal> loginUser(String otp) async {
    _loginModal!.otp = otp;
    final res = _userService.loginUser(_loginModal!.loginMap());
    return res;
  }
}
