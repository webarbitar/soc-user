import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/view_modal/auth/auth_view_modal.dart';
import 'package:socspl/ui/shared/messenger/util.dart';

import '../../../core/constance/strings.dart';
import '../../../core/constance/style.dart';
import '../../shared/navigation/navigation.dart';
import '../../widgets/appbars/appbar1.dart';

class OtpView extends StatelessWidget {
  final Widget? redirectRoute;

  OtpView({Key? key, required this.redirectRoute}) : super(key: key);

  final _otpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    final modal = context.read<AuthViewModal>();
    print(redirectRoute);
    return Scaffold(
      backgroundColor: darkMode ? Colors.black : mainColorGray,
      body: Directionality(
        textDirection: strings.direction,
        child: Stack(
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
                    "Otp has been send to ${modal.isLogin ? modal.loginModal!.mobile : modal.registrationModal!.mobile}",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        letterSpacing: 0.4,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: (darkMode) ? Colors.white : Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: 20,
                    child: PinCodeTextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (val) {},
                      controller: _otpCtrl,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      length: 4,
                      autoFocus: true,
                      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                      enablePinAutofill: true,
                      enabled: true,
                      enableActiveFill: true,
                      pinTheme: PinTheme(
                          borderRadius: BorderRadius.circular(2),
                          selectedColor: primaryColor.withOpacity(0.2),
                          selectedFillColor: primaryColor.withOpacity(0.2),
                          activeColor: primaryColor.withOpacity(0.2),
                          activeFillColor: primaryColor.withOpacity(0.2),
                          inactiveColor: primaryColor.withOpacity(0.2),
                          inactiveFillColor: primaryColor.withOpacity(0.2),
                          fieldHeight: 45,
                          fieldWidth: 45),
                      appContext: context,
                      onCompleted: (_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (modal.isLogin) {
                          final res = modal.loginUser(_);
                          res.then((value) {
                            if (value.status == ApiStatus.success) {
                              messageOk(context, value.message);
                              if (redirectRoute != null) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => redirectRoute!,
                                  ),
                                );
                              } else {
                                Navigation.instance.navigateAndRemoveUntil("/home");
                              }
                            } else {
                              messageError(context, value.message);
                            }
                          });
                        } else {
                          final res = modal.registerUser(_);
                          res.then((value) {
                            if (value.status == ApiStatus.success) {
                              messageOk(context, value.message);
                              Navigation.instance.navigateAndRemoveUntil("/home");
                            } else {
                              messageError(context, value.message);
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            appbar1(
              Colors.transparent,
              (darkMode) ? Colors.white : Colors.black,
              "",
              context,
              () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
