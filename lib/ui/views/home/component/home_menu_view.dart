import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/core/view_modal/user/user_view_model.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/views/user/profile_view.dart';
import 'package:socspl/ui/views/user/service_address_view.dart';

import '../../../../core/constance/style.dart';
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Consumer<UserViewModel>(builder: (context, model, _) {
                if (model.user == null) {
                  return const SizedBox();
                }
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.deepOrange,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          if (model.user!.imageUrl.isNotEmpty)
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: CachedNetworkImage(
                                  imageUrl: model.user!.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: primaryColor,
                                size: 40,
                              ),
                            ),
                          UIHelper.horizontalSpaceMedium,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${model.user?.name}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${model.user?.email}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${model.user?.mobile}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      UIHelper.verticalSpaceSmall,
                      Consumer<HomeViewModal>(builder: (context, model, _) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          color: Colors.white,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.deepOrange,
                              ),
                              UIHelper.horizontalSpaceSmall,
                              Flexible(child: Text(model.currentAddress)),
                              UIHelper.horizontalSpaceSmall,
                              SizedBox(
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.deepOrange),
                                    ),
                                    onPressed: () {
                                      Navigation.instance.navigate("/pick-location");
                                    },
                                    child: const Text(
                                      "Change",
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                      ),
                                    )),
                              )
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                );
              }),
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
                  leading: const Icon(Icons.person_outline),
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
                  leading: const Icon(Icons.location_on_outlined),
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
                  leading: const Icon(Icons.handshake_outlined),
                  title: const Text(
                    "Join Us As Partner",
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
                  leading: const Icon(Icons.wallet),
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
                  leading: const Icon(Icons.business),
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
                  leading: const Icon(Icons.call),
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
                  leading: const Icon(Icons.contact_support),
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
                  leading: const Icon(Icons.shield),
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
                  leading: const Icon(Icons.document_scanner),
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
                  leading: const Icon(Icons.keyboard_return),
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
                  leading: const Icon(Icons.logout),
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
