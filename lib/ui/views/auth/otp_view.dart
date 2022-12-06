import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/view_modal/auth/auth_view_modal.dart';
import 'package:socspl/ui/shared/messenger/util.dart';

import '../../../core/constance/strings.dart';
import '../../../core/constance/style.dart';
import '../../../core/view_modal/user/user_view_model.dart';
import '../../shared/navigation/navigation.dart';
import '../../shared/ui_helpers.dart';
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
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       primaryColor.shade500,
        //       const Color(0x32ad1998),
        //     ],
        //     // begin: Alignment.topCenter,
        //     // end: Alignment.centerRight,
        //     // stops: const [0.0, 1.0],
        //   ),
        // ),
        child: Directionality(
          textDirection: strings.direction,
          child: ListView(
            children: [
              const SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "OTP",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    const Text(
                      "Verification",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    UIHelper.verticalSpaceMedium,
                    Text(
                      "Otp has been send to ${modal.isLogin ? modal.loginModal!.mobile : modal.registrationModal!.mobile}",
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        letterSpacing: 0.4,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
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
                        borderRadius: BorderRadius.circular(20),
                        selectedColor: Colors.white,
                        selectedFillColor: Colors.white,
                        activeColor: Colors.white,
                        activeFillColor: Colors.white,
                        inactiveColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        fieldHeight: 45,
                        fieldWidth: 45),
                    appContext: context,
                    onCompleted: (_) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (modal.isLogin) {
                        final res = modal.loginUser(_);
                        res.then((value) async {
                          if (value.status == ApiStatus.success) {
                            await context.read<UserViewModel>().fetchUserProfile();
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
                        res.then((value) async {
                          if (value.status == ApiStatus.success) {
                            await context.read<UserViewModel>().fetchUserProfile();
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
        ),
      ),
    );
  }
}
