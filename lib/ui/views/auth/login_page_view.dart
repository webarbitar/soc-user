import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/user/auth/login_modal.dart';
import 'package:socspl/core/modal/user/auth/user_registration_modal.dart';
import 'package:socspl/core/utils/storage/storage.dart';
import 'package:socspl/core/view_modal/auth/auth_view_modal.dart';
import 'package:socspl/ui/shared/validator_mixin.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../../core/constance/strings.dart';
import '../../../core/constance/style.dart';
import '../../shared/messenger/util.dart';
import '../../shared/navigation/navigation.dart';
import '../../widgets/appbars/appbar1.dart';
import '../../widgets/buttons/button134.dart';
import '../../widgets/buttons/button2.dart';
import '../../widgets/checkbox/checkbox12.dart';
import '../../widgets/edit43.dart';

class LoginPageView extends StatefulWidget {
  final Widget? redirectRoute;

  const LoginPageView({Key? key, this.redirectRoute}) : super(key: key);

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> with ValidatorMixin {
  final formKey = GlobalKey<FormState>();
  var windowWidth = 0.0;
  var windowHeight = 0.0;
  double windowSize = 0;
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
      backgroundColor: darkMode ? Colors.black : mainColorGray,
      body: Stack(
        children: <Widget>[
          ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                  width: windowWidth * 0.3,
                  height: windowWidth * 0.3,
                  child: Image.asset("assets/images/logo.png", fit: BoxFit.contain)),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  strings.get(1),
                  style: theme.style25W400,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: darkMode ? blackColorTitleBkg : Colors.white,
                  borderRadius: BorderRadius.circular(theme.radius),
                  border: Border.all(color: Colors.grey.withAlpha(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: Edit43a(
                  prefixIcon: Icon(
                    Icons.phone_android,
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                  controller: _phoneCtrl,
                  hint: "Enter your phone",
                  editStyle: theme.style14W400,
                  hintStyle: theme.style14W400Grey,
                  color: Colors.grey,
                  type: TextInputType.phone,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    // Row(
                    //   children: [
                    // Expanded(
                    //   child: SizedBox(
                    //     height: 45,
                    //     child: button134(strings.get(9), _register, true, theme.style14W800),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    SizedBox(
                      height: 45,
                      child: button2s(
                          strings.get(10), theme.style14W800W, primaryColor, 10, _login, true),
                    ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
          if (widget.redirectRoute == null)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () {
                    Navigation.instance.navigateAndRemoveUntil("/home");
                  },
                  child: const Text("Skip"),
                ),
              ),
            ),
          if (_wait)
            const Center(
              child: LoaderWidget(
                color: primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  bool _wait = false;

  _waits(bool value) {
    _wait = value;
    _redraw();
  }

  _redraw() {
    if (mounted) setState(() {});
  }

  _login() async {
    final modal = context.read<AuthViewModal>();
    modal.isLogin = true;
    String? val = phoneValidation(_phoneCtrl.text);
    if (val != null) {
      messageError(context, val);
      return;
    }
    _waits(true);
    var token = await FirebaseMessaging.instance.getToken();
    final data = LoginModal(mobile: _phoneCtrl.text, fcmToken: token ?? "");
    final res = modal.sendLoginOtp(data);
    res.then(
      (value) async {
        if (value.status == ApiStatus.success) {
          messageOk(context, value.message);
          Navigation.instance.navigate("/otp", args: widget.redirectRoute);
        } else if (value.status == ApiStatus.notFound) {
          modal.isLogin = false;
          final res2 = await modal.sendRegisterOtp(
            UserRegistrationModal(
              mobile: _phoneCtrl.text,
              fcmToken: token ?? "",
            ),
          );
          if (res2.status == ApiStatus.success) {
            if (mounted) {
              messageOk(context, value.message);
              Navigation.instance.navigate("/otp");
            }
          }
        } else {
          messageError(context, value.message);
        }
        _waits(false);
      },
    );
  }
}
