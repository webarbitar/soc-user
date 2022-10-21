import 'package:flutter/material.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/views/user/profile_view.dart';
import 'package:socspl/ui/views/user/service_address_view.dart';

import '../../../../core/utils/storage/storage.dart';
import '../../../shared/navigation/navigation.dart';

class HomeMenuView extends StatefulWidget {
  const HomeMenuView({Key? key}) : super(key: key);

  @override
  State<HomeMenuView> createState() => _HomeMenuViewState();
}

class _HomeMenuViewState extends State<HomeMenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              UIHelper.verticalSpaceMedium,
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileView(),
                      ),
                    );
                  },
                  title: const Text(
                    "My Profile",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ServiceAddressView(),
                      ),
                    );
                  },
                  title: const Text(
                    "Service Address",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: const Text(
                    "My Wallet",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: const Text(
                    "About Us",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: const Text(
                    "Contact Us",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: const Text(
                    "FAQ",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: const Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: const Text(
                    "Term & Condition",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: const Text(
                    "Return & Refund Policy",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Storage.instance.logout();

                    Navigation.instance.navigateAndRemoveUntil("/login");
                  },
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
