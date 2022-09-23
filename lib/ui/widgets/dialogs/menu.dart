import 'package:flutter/material.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/core/utils/storage/storage.dart';
import 'package:socspl/ui/shared/navigation/navigation.dart';
import '../../../core/constance/strings.dart';
import '../buttons/button126.dart';
import '../checkbox/checkbox12.dart';

getBodyMenuDialog(
    Function() _redraw, Function() _close, double windowWidth, Function(String) _route) {
  double _size = windowWidth * 0.2;
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (Storage.instance.isLogin)
        button126(
            strings.get(51),

            /// "Sign Out",
            [primaryColor.withAlpha(20), primaryColor],
            "assets/logo/out.png",
            _size,
            _size,
            8, () {
          Storage.instance.logout();
          Navigation.instance.navigateAndRemoveUntil("/login");
        }, true),
      // SizedBox(
      //   height: 5,
      // ),
      // Row(
      //   children: [
      //     Expanded(
      //         child: button126(
      //             strings.get(45),
      //
      //             /// "Profile",
      //             [primaryColor.withAlpha(20), primaryColor],
      //             "assets/profile.png",
      //             _size,
      //             _size,
      //             8, () {
      //       _route("profile");
      //     }, true)),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Expanded(
      //         child: button126(
      //             strings.get(49),
      //
      //             /// "My Address",
      //             [primaryColor.withAlpha(20), primaryColor],
      //             "assets/address.png",
      //             _size,
      //             _size,
      //             8, () {
      //       _route("addressBase");
      //     }, true)),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Expanded(
      //         child: button126(
      //             strings.get(50),
      //
      //             /// "Language",
      //             [primaryColor.withAlpha(20), primaryColor],
      //             "assets/lang.png",
      //             _size,
      //             _size,
      //             8, () {
      //       _route("language");
      //     }, true)),
      //     SizedBox(
      //       width: 10,
      //     ),
      //
      //     // if (!userLogin)
      //     //   Expanded(
      //     //       child: button126(
      //     //           strings.get(10),
      //     //
      //     //           /// "Sign In",
      //     //           [primaryColor.withAlpha(20), primaryColor],
      //     //           "assets/login.png",
      //     //           _size,
      //     //           _size,
      //     //           8, () {
      //     //     _route("login");
      //     //   }, true)),
      //   ],
      // ),
      // SizedBox(
      //   height: 10,
      // ),
      // Row(
      //   children: [
      //     Expanded(
      //         child: button126(
      //             strings.get(46),
      //
      //             /// "Privacy Policy",
      //             [primaryColor.withAlpha(20), primaryColor],
      //             "assets/policy.png",
      //             _size,
      //             _size,
      //             8, () {
      //       _route("policy");
      //     }, true)),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Expanded(
      //         child: button126(
      //             strings.get(47),
      //
      //             /// "About Us",
      //             [primaryColor.withAlpha(20), primaryColor],
      //             "assets/about.png",
      //             _size,
      //             _size,
      //             8, () {
      //       _route("about");
      //     }, true)),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Expanded(
      //         child: button126(
      //             strings.get(8),
      //
      //             /// "Terms & Conditions",
      //             [primaryColor.withAlpha(20), primaryColor],
      //             "assets/terms.png",
      //             _size,
      //             _size,
      //             8, () {
      //       _route("terms");
      //     }, true)),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     // Expanded(
      //     //     child: Column(
      //     //   crossAxisAlignment: CrossAxisAlignment.center,
      //     //   children: [
      //     //     CheckBox12(darkMode, (bool val) {
      //     //       darkMode = val;
      //     //       theme = OnDemandServiceTheme();
      //     //       initDecor();
      //     //       localSettings.setDarkMode(val);
      //     //       _redraw();
      //     //     }, color: primaryColor),
      //     //     Text(
      //     //       strings.get(48),
      //     //       style: theme.style10W400,
      //     //       textAlign: TextAlign.center,
      //     //     ),
      //     //
      //     //     /// "Dark Mode",
      //     //   ],
      //     // ))
      //   ],
      // ),
      // SizedBox(height: 10,),
    ],
  );
}
