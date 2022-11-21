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
import 'package:socspl/ui/shared/ui_helpers.dart';
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
      backgroundColor: primaryColor,
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       colors: [
        //         primaryColor.shade500,
        //         const Color(0xfff02d71),
        //       ],
        //       begin: Alignment.topLeft,
        //       end: const Alignment(5, 0),
        //       stops: const [0.4, 0.9]),
        // ),
        child: Stack(
          children: <Widget>[
            ListView(
              children: [
                UIHelper.verticalSpaceLarge,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Service On Clap",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
                UIHelper.verticalSpaceLarge,
                UIHelper.verticalSpaceLarge,
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
                Column(
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
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Ink(
                          width: double.maxFinite,
                          height: 45,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffff0044),
                                Color(0xffff794d),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: const Center(child: Text("Sign In")),
                        ),
                      ),
                    ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
                const Center(
                  child: Text(
                    "Co-powered by SOC Services pvt Ltd",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            if (widget.redirectRoute == null)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
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
                child: LoaderWidget(),
              ),
          ],
        ),
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
