import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/user/auth/user_registration_modal.dart';
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

class SignupPageView extends StatefulWidget {
  const SignupPageView({Key? key}) : super(key: key);

  @override
  State<SignupPageView> createState() => _SignupPageViewState();
}

class _SignupPageViewState extends State<SignupPageView> with ValidatorMixin {
  var windowWidth;
  var windowHeight;
  double windowSize = 0;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  var _agree = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
      backgroundColor: (darkMode) ? Colors.black : mainColorGray,
      body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[
            ListView(children: [
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
              Center(child: Text(strings.get(1), style: theme.style25W400)),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.all(10),
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
                child: Column(
                  children: [
                    Edit43a(
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: darkMode ? Colors.white : Colors.black,
                        ),
                        controller: _nameCtrl,
                        hint: strings.get(16),
                        editStyle: theme.style14W400,
                        hintStyle: theme.style14W400Grey,
                        color: Colors.grey,
                        type: TextInputType.text),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: const Divider(color: Colors.grey),
                    ),
                    Edit43a(
                        prefixIcon: Icon(
                          Icons.email,
                          color: darkMode ? Colors.white : Colors.black,
                        ),
                        controller: _emailCtrl,
                        hint: strings.get(4),
                        editStyle: theme.style14W400,
                        hintStyle: theme.style14W400Grey,
                        color: Colors.grey,
                        type: TextInputType.emailAddress),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: const Divider(color: Colors.grey),
                    ),
                    Edit43a(
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: darkMode ? Colors.white : Colors.black,
                        ),
                        controller: _mobileCtrl,
                        hint: "Enter your phone",
                        editStyle: theme.style14W400,
                        hintStyle: theme.style14W400Grey,
                        color: Colors.grey,
                        type: TextInputType.emailAddress),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CheckBox12(_agree, (bool val) {
                            _agree = val;
                            _redraw();
                          }, color: primaryColor),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(strings.get(7), style: theme.style12W400),

                          /// I agree with
                          const SizedBox(
                            width: 5,
                          ),
                          button134(strings.get(8), () {
                            // widget.callback("termsFromRegister");
                          }, true, theme.style14W800MainColor)

                          /// "Terms and Conditions",
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: button134(
                            strings.get(10),
                            () {
                              Navigation.instance.goBack();
                            },
                            true,
                            theme.style14W800MainColor,
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: button2s(
                              strings.get(9),
                              theme.style16W800White,
                              primaryColor,
                              10,
                              _continue,
                              true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(
                height: 150,
              ),
            ]),
            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black, "", context, () {
              Navigation.instance.goBack();
            }),
            if (_wait)
              SizedBox(
                width: windowSize,
                height: windowHeight,
                child: const Center(
                  child: LoaderWidget(
                    color: primaryColor,
                  ),
                ),
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

  _continue() {
    // _waits(false);

    String? val = emptyFieldValidation(_nameCtrl.text);
    if (val != null) {
      messageError(context, val);
      return;
    }

    String? val2 = emailValidation(_emailCtrl.text);
    if (val2 != null) {
      messageError(context, val2);
      return;
    }

    String? val3 = phoneValidation(_mobileCtrl.text);
    if (val3 != null) {
      messageError(context, val3);
      return;
    }

    _waits(true);
    final modal = context.read<AuthViewModal>();
    var usr = UserRegistrationModal(
      mobile: _mobileCtrl.text.trim(),
    );
    final res = modal.sendRegisterOtp(usr);
    res.then((value) {
      if (value.status == ApiStatus.success) {
        messageOk(context, value.message);
        Navigation.instance.navigate("/otp");
      } else {
        messageError(context, value.message);
      }
      _waits(false);
    });
  }
}
