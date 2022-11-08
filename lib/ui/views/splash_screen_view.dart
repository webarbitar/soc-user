import 'package:flutter/material.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/core/utils/storage/storage.dart';
import 'package:socspl/ui/shared/navigation/navigation.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    _initNavigation();
  }

  void _initNavigation() async {
    // Initialize local storage
    await Storage.instance.initializeStorage();
    await Future.delayed(const Duration(seconds: 2));
    bool isLogin = Storage.instance.isLogin;
    if (isLogin) {
      Navigation.instance.navigateAndReplace("/home");
    } else {
      if (Storage.instance.showOnboarding) {
        Navigation.instance.navigateAndReplace("/landing-view");
      } else {
        Navigation.instance.navigateAndRemoveUntil("/login");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              child: Image.asset(
                "assets/images/logo-banner.jpeg",
              ),
            ),

            UIHelper.verticalSpaceLarge,
            UIHelper.verticalSpaceLarge,
            const LoaderWidget(
              color: primaryColor,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
