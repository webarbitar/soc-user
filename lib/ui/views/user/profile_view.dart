import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/utils/string_extension.dart';
import 'package:socspl/ui/shared/messenger/util.dart';
import 'package:socspl/ui/views/user/profile_update_view.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../../core/view_modal/user/user_view_model.dart';
import '../../shared/ui_helpers.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _busyNfy = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _busyNfy.value = true;
    final model = context.read<UserViewModel>();
    final res = model.fetchUserProfile();
    res.then((value) {
      if (value.status != ApiStatus.success) {
        messageError(context, value.message);
      }
      _busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontFamily: "Montserrat",
          ),
        ),
        centerTitle: true,
        elevation: 0.2,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileUpdateView(),
                ),
              );
            },
            child: const Text(
              "Edit",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Consumer<UserViewModel>(builder: (context, userModel, _) {
        return ValueListenableBuilder(
            valueListenable: _busyNfy,
            builder: (context, bool busy, _) {
              if (busy) {
                return const Center(
                  child: LoaderWidget(),
                );
              }
              if (userModel.user == null) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "Profile couldn't be fetch. Please try again",
                      style: TextStyle(fontFamily: "Montserrat", fontSize: 13),
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    UIHelper.verticalSpaceMedium,
                    UIHelper.verticalSpaceSmall,
                    if (userModel.user!.imageUrl.isNotEmpty)
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4, -4),
                              blurRadius: 8,
                            ),
                            BoxShadow(
                              color: Color(0xffd4d4d4),
                              offset: Offset(4, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: userModel.user!.imageUrl,
                            // imageUrl: "https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4, -4),
                              blurRadius: 8,
                            ),
                            BoxShadow(
                              color: Color(0xffd4d4d4),
                              offset: Offset(4, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          color: primaryColor,
                          size: 40,
                        ),
                      ),
                    UIHelper.verticalSpaceLarge,
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          children: [
                            buildProfileContainer(
                              label: "Name",
                              data: "${userModel.user?.name}",
                            ),
                            UIHelper.verticalSpaceSmall,
                            const Divider(thickness: 2),
                            UIHelper.verticalSpaceSmall,
                            buildProfileContainer(
                              label: "Email",
                              data: "${userModel.user?.email}",
                            ),
                            UIHelper.verticalSpaceSmall,
                            const Divider(thickness: 2),
                            UIHelper.verticalSpaceSmall,
                            buildProfileContainer(
                              label: "Mobile",
                              data: "${userModel.user?.mobile}",
                            ),
                            UIHelper.verticalSpaceSmall,
                            const Divider(thickness: 2),
                            UIHelper.verticalSpaceSmall,
                            buildProfileContainer(
                              label: "Status",
                              data: "${userModel.user?.status.capitalize()}",
                            ),
                            UIHelper.verticalSpaceSmall,
                            const Divider(thickness: 2),
                            UIHelper.verticalSpaceSmall,
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
      }),
    );
  }

  static buildProfileContainer({String label = "", String data = ""}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: "Montserrat",
            ),
          ),
        ),
        Expanded(
            flex: 2,
            child: Text(
              data,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Montserrat",
              ),
            ))
      ],
    );
  }
}
