// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
//
// import '../../core/constants/style.dart';
//
// mixin MessengerMixin {
//   showSuccessMessage(BuildContext context, String message, {bool? scaffoldMessenger}) {
//     if (scaffoldMessenger != null && scaffoldMessenger) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: BUTTON_COLOR,
//         content: Text(
//           message,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             fontFamily: "Poppins",
//             color: WHITE_COLOR,
//           ),
//         ),
//       ));
//     } else {
//       Flushbar(
//         flushbarPosition: FlushbarPosition.TOP,
//         duration: Duration(seconds: 2),
//         backgroundColor: BUTTON_COLOR,
//         messageText: Text(
//           message,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             fontFamily: "Poppins",
//             color: WHITE_COLOR,
//           ),
//         ),
//       ).show(context);
//     }
//   }
//
//   showErrorMessage(BuildContext context, String message) {
//     Flushbar(
//       flushbarPosition: FlushbarPosition.TOP,
//       duration: Duration(seconds: 2),
//       backgroundColor: Colors.red,
//       messageText: Text(
//         message,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           fontFamily: "Poppins",
//           color: WHITE_COLOR,
//         ),
//       ),
//     ).show(context);
//   }
// }
