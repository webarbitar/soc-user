import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as df;

import '../../../core/modal/stringdata.dart';

dprint(String str) {
  if (!kReleaseMode) print(str);
}

Color getColor(String? boardColor) {
  if (boardColor == null) return Colors.red;
  var t = int.tryParse(boardColor);
  if (t != null) return Color(t);
  return Colors.red;
}

messageError(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

messageOk(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: primaryColor,
      duration: const Duration(seconds: 5),
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      )));
}

Color toColor(String? boardColor) {
  if (boardColor == null) return Colors.red;
  var t = int.tryParse(boardColor);
  if (t != null) return Color(t);
  return Colors.red;
}

String getTextByLocale(List<StringData> data) {
  // for (var item in _data)
  //   if (item.code == localSettings.locale)
  //     return item.text;
  for (var item in data) {
    if (item.code == "en") return item.text;
  }
  if (data.isNotEmpty) return data[0].text;
  return "";
}

int toInt(String str) {
  int ret = 0;
  try {
    ret = int.parse(str);
  } catch (_) {}
  return ret;
}

double toDouble(String str) {
  double ret = 0;
  try {
    ret = double.parse(str);
  } catch (_) {}
  return ret;
}

bool validateEmail(String value) {
  var pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return false;
  } else {
    return true;
  }
}

String checkPhoneNumber(String phoneText) {
  String s = "";
  for (int i = 0; i < phoneText.length; i++) {
    int c = phoneText.codeUnitAt(i);
    if ((c == "1".codeUnitAt(0)) ||
        (c == "2".codeUnitAt(0)) ||
        (c == "3".codeUnitAt(0)) ||
        (c == "4".codeUnitAt(0)) ||
        (c == "5".codeUnitAt(0)) ||
        (c == "6".codeUnitAt(0)) ||
        (c == "7".codeUnitAt(0)) ||
        (c == "8".codeUnitAt(0)) ||
        (c == "9".codeUnitAt(0)) ||
        (c == "0".codeUnitAt(0)) ||
        (c == "+".codeUnitAt(0))) {
      String h = String.fromCharCode(c);
      s = "$s$h";
    }
  }
  return s;
}

callMobile(String phone) async {
  var uri = "tel:${checkPhoneNumber(phone)}";
  if (await canLaunch(uri)) await launch(uri);
}

openUrl(String uri) async {
  if (await canLaunch(uri)) await launch(uri);
}

String getDateTimeString(DateTime time) {
  return df.DateFormat("dd.MM.yyyy").format(time).toString() +
      " " +
      df.DateFormat("HH:mm").format(time).toString();
}

String getTimeString(DateTime time) {
  return df.DateFormat("HH:mm").format(time).toString();
}
