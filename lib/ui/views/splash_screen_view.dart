import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/core/utils/storage/storage.dart';
import 'package:socspl/ui/shared/navigation/navigation.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../core/view_modal/user/user_view_model.dart';

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
    bool isLogin = Storage.instance.isLogin;
    if (isLogin) {
      if (!mounted) return;
      await context.read<UserViewModel>().fetchUserProfile();
      Navigation.instance.navigateAndReplace("/home");
    } else {
      Navigation.instance.navigateAndRemoveUntil("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  Text(
                    "SOC",
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  UIHelper.verticalSpaceSmall,
                  Text(
                    "Service On Clap",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120),
            const LoaderWidget(),
          ],
        ),
      ),
    );
  }
}
