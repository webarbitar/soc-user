import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool darkMode = false;
OnDemandServiceTheme theme = OnDemandServiceTheme();

const primaryColor = Colors.blue;
const mainColorGray = Color(0xfffafafa);
const blackColorTitleBkg = Color(0xff202020);
const backgroundColor = Color.fromRGBO(246, 247, 251, 1);
const highlightColor = Color.fromRGBO(237, 238, 240, 1);
const highlightColor2 = Color.fromRGBO(241, 232, 232, 1);

const dropShadow = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 16,
  spreadRadius: 0,
  color: Color.fromRGBO(0, 0, 0, .08),
);

const systemOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: backgroundColor,
  systemNavigationBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarIconBrightness: Brightness.dark,
);

Decoration decor = BoxDecoration(
  color: (darkMode) ? blackColorTitleBkg : Colors.white,
  borderRadius: BorderRadius.circular(theme.radius),
  border: Border.all(color: Colors.grey.withAlpha(20)),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 1,
      blurRadius: 1,
      offset: const Offset(1, 1),
    ),
  ],
);

class OnDemandServiceTheme {
  double radius = 8;

  // splash
  String logo =
      ""; // https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/apps%2Fc0b154bc-050a-4bce-babd-04d50f889cbb.jpg?alt=media&token=ef7a8e8a-7737-4504-980c-dbc48b2947ee
  String splashImage = "";
  bool logoAsset = true;
  bool splashImageAsset = true;

  //Color splashColor = Color(0xff1c7bab);
  // lang
  bool langLogoAsset = true;
  String langLogo = "";

  // login
  bool loginLogoAsset = true;
  String loginLogo = "";
  bool loginImageAsset = true;
  String loginImage = "";

  // register
  bool registerLogoAsset = true;
  String registerLogo = "";

  // home
  bool homeLogoAsset = true;
  String homeLogo = "";

  // provider
  Color providerStarColor = const Color(0xFFFFA726);
  bool providerGLogoAsset = true;
  String providerGLogo = "";
  bool providerRLogoAsset = true;
  String providerRLogo = "";

  // service
  Color serviceStarColor = const Color(0xFFFFA726);
  bool serviceGLogoAsset = true;
  String serviceGLogo = "";
  bool serviceRLogoAsset = true;
  String serviceRLogo = "";

  // category
  Color categoryStarColor = const Color(0xFFFFA726);
  Color categoryBoardColor = const Color(0xFF66BB6A);

  // booking
  bool bookingNotFoundImageAsset = true;
  String bookingNotFoundImage = "";

  // chat
  bool chatLogoAsset = true;
  String chatLogo = "";

  // chat 2
  bool chat2LogoAsset = true;
  String chat2Logo = "";
  bool chatSendButtonImageAsset = true;
  String chatSendButtonImage = "";

  // notify
  bool notifyLogoAsset = true;
  String notifyLogo = "";
  bool notifyNotFoundImageAsset = true;
  String notifyNotFoundImage = "";

  // account
  bool accountLogoAsset = true;
  String accountLogo = "";

  // profile
  bool profileLogoAsset = true;
  String profileLogo = "";

  // documents
  bool documentsLogoAsset = true;
  String documentsLogo = "";

  // booking 1
  Color booking1CheckBoxColor = const Color(0xFFFFA726);

  // booking 4
  Color booking4CheckBoxColor = const Color(0xFFFFA726);

  // booking 5
  bool booking5LogoAsset = true;
  String booking5Logo = "";

  OnDemandServiceTheme({
    // this.mainColor = const Color(0xff69c4ff), this.mainColorGray = const Color(0xfff1f6fe),
    // this.blackColorTitleBkg = const Color(0xff202020),
    // splash
    this.logo = "",
    this.splashImage = "",
    this.logoAsset = true,
    this.splashImageAsset = true,
    // lang
    this.langLogoAsset = true,
    this.langLogo = "",
    // login
    this.loginImageAsset = true,
    this.loginLogo = "",
    this.loginLogoAsset = true,
    this.loginImage = "",
    // register
    this.registerLogoAsset = true,
    this.registerLogo = "",
    // home
    this.homeLogoAsset = true,
    this.homeLogo = "",
    // provider
    this.providerStarColor = const Color(0xFFFFA726),
    this.providerGLogoAsset = true,
    this.providerGLogo = "",
    this.providerRLogoAsset = true,
    this.providerRLogo = "",
    // service
    this.serviceStarColor = const Color(0xFFFFA726),
    this.serviceGLogoAsset = true,
    this.serviceGLogo = "",
    this.serviceRLogoAsset = true,
    this.serviceRLogo = "",
    // category
    this.categoryStarColor = const Color(0xFFFFA726),
    this.categoryBoardColor = const Color(0xFF66BB6A),
    // booking
    this.bookingNotFoundImageAsset = true,
    this.bookingNotFoundImage = "",
    // chat
    this.chatLogoAsset = true,
    this.chatLogo = "",
    // chat 2
    this.chat2LogoAsset = true,
    this.chat2Logo = "",
    this.chatSendButtonImageAsset = true,
    this.chatSendButtonImage = "",
    // notify
    this.notifyLogoAsset = true,
    this.notifyLogo = "",
    this.notifyNotFoundImageAsset = true,
    this.notifyNotFoundImage = "",
    // account
    this.accountLogoAsset = true,
    this.accountLogo = "",
    // profile
    this.profileLogoAsset = true,
    this.profileLogo = "",
    // documents
    this.documentsLogoAsset = true,
    this.documentsLogo = "",
    // booking 1
    this.booking1CheckBoxColor = const Color(0xFFFFA726),
    // booking 4
    this.booking4CheckBoxColor = const Color(0xFFFFA726),
    // booking 5
    this.booking5LogoAsset = true,
    this.booking5Logo = "",
  }) {
    style12W600Stars = TextStyle(
        fontFamily: _font,
        letterSpacing: 0.4,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: providerStarColor);
    style12W600StarsService = TextStyle(
        fontFamily: _font,
        letterSpacing: 0.4,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: serviceStarColor);
    style12W600StarsCategory = TextStyle(
        fontFamily: _font,
        letterSpacing: 0.4,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: categoryStarColor);
    style14W800MainColor = const TextStyle(
        fontFamily: _font,
        letterSpacing: 0.4,
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: primaryColor);
    style11W800MainColor = const TextStyle(
        fontFamily: _font,
        letterSpacing: 0.4,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: primaryColor);
    style11W400MainColor = const TextStyle(
        fontFamily: _font,
        letterSpacing: 0.4,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: primaryColor);
  }

  //
  //
  //
  //
  //

  static const String _font = "Montserrat";

  TextStyle style10W400White = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: Colors.white);

  TextStyle style10W800White = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 10,
      fontWeight: FontWeight.w800,
      color: Colors.white);

  TextStyle style10W400 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style11W600 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style11W600Grey = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: Colors.grey);

  TextStyle style11W800W = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      color: Colors.white);

  TextStyle style10W600Grey = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: Colors.grey);

  TextStyle style12W400 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style13W400 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style13W800 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 13,
      fontWeight: FontWeight.w800,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style13W800Red = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 13,
      fontWeight: FontWeight.w800,
      color: Colors.red);

  TextStyle style13W400D = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      decoration: TextDecoration.lineThrough,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.grey);

  TextStyle style12W600Grey = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.grey);

  TextStyle style12W600Blue = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.blue);

  TextStyle style12W600Orange = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.orange);

  late TextStyle style12W600Stars;
  late TextStyle style12W600StarsService;
  late TextStyle style12W600StarsCategory;
  late TextStyle style11W400MainColor;
  late TextStyle style14W800MainColor;
  late TextStyle style11W800MainColor;

  TextStyle style12W600White = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.white);

  TextStyle style12W800 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style12W800W = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: Colors.white);

  TextStyle style14W400 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style14W400Grey = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.grey);

  TextStyle style14W800 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style14W600Grey = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.grey);

  TextStyle style15W400 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style16W400 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style16W800 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.5,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style16W400U = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style16W800White = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: Colors.white);

  TextStyle style16W800W = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: Colors.white);
  TextStyle style14W800W = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: Colors.white);

  TextStyle style16W800Main = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: primaryColor);

  TextStyle style16W800Green = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: Colors.green);

  TextStyle style16W800Red = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: Colors.red);

  TextStyle style16W800Orange = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: Colors.orange);

  TextStyle style16W800Blue = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: Colors.blue);

  TextStyle style16W600Grey = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.grey);

  TextStyle style16W800Grey = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: Colors.grey);

  TextStyle style18W800 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style18W800Grey = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: Colors.grey);

  TextStyle style18W800Orange = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: Colors.orange);

  TextStyle style20W800 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style20W800Red = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: Colors.red);

  TextStyle style20W800Green = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: Colors.green);

  TextStyle style20W800Grey = const TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: Colors.grey);

  TextStyle style25W800 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 25,
      fontWeight: FontWeight.w800,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style25W400 = TextStyle(
      fontFamily: _font,
      letterSpacing: 0.4,
      fontSize: 25,
      fontWeight: FontWeight.w400,
      color: (darkMode) ? Colors.white : Colors.black);
}
