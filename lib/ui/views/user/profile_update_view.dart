import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/core/view_modal/user/user_view_model.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/shared/validator_mixin.dart';
import 'package:socspl/ui/views/home/component/home_booking_view.dart';

import '../../../core/constance/strings.dart';
import '../../../core/constance/style.dart';
import '../../widgets/buttons/button134.dart';
import '../../widgets/custom/custom_button.dart';
import '../../widgets/edit43.dart';

class ProfileUpdateView extends StatefulWidget {
  const ProfileUpdateView({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateView> createState() => _ProfileUpdateViewState();
}

class _ProfileUpdateViewState extends State<ProfileUpdateView> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();

  final _imagePicker = ImagePicker();
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    final model = context.read<UserViewModel>();
    _nameCtrl.text = model.user?.name ?? "";
    _emailCtrl.text = model.user?.email ?? "";
    _mobileCtrl.text = model.user?.mobile ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Update",
          style: TextStyle(
            fontFamily: "Montserrat",
          ),
        ),
        centerTitle: true,
        elevation: 0.2,
      ),
      backgroundColor: backgroundColor,
      body: ListView(children: [
        const SizedBox(
          height: 50,
        ),
        Container(
          height: 110,
          width: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: backgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_pickedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 110,
                    child: Image.file(
                      File(_pickedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                ),
            ],
          ),
        ),
        UIHelper.verticalSpaceMedium,
        Center(
          child: CustomButton(
            width: 130,
            height: 40,
            text: "Upload Image",
            textStyle: const TextStyle(
              fontSize: 12,
              color: backgroundColor,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
            ),
            onTap: _imagePickerOnTap,
          ),
        ),
        UIHelper.verticalSpaceMedium,
        UIHelper.verticalSpaceMedium,
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: darkMode ? blackColorTitleBkg : Colors.white,
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(color: Colors.grey.withAlpha(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Edit43a(
            prefixIcon: Icon(
              Icons.person_outline,
              color: darkMode ? Colors.white : Colors.black,
            ),
            controller: _nameCtrl,
            hint: "Enter your name",
            editStyle: theme.style14W400,
            hintStyle: theme.style14W400Grey,
            color: Colors.grey,
          ),
        ),
        UIHelper.verticalSpaceMedium,
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: darkMode ? blackColorTitleBkg : Colors.white,
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(color: Colors.grey.withAlpha(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Edit43a(
            prefixIcon: Icon(
              Icons.email_outlined,
              color: darkMode ? Colors.white : Colors.black,
            ),
            controller: _emailCtrl,
            hint: "Enter your email",
            editStyle: theme.style14W400,
            hintStyle: theme.style14W400Grey,
            color: Colors.grey,
            type: TextInputType.emailAddress,
          ),
        ),
        UIHelper.verticalSpaceMedium,
        IgnorePointer(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: darkMode ? blackColorTitleBkg : Colors.white,
              borderRadius: BorderRadius.circular(theme.radius),
              border: Border.all(color: Colors.grey.withAlpha(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Edit43a(
              prefixIcon: Icon(
                Icons.phone_android,
                color: darkMode ? Colors.white : Colors.black,
              ),
              controller: _mobileCtrl,
              hint: "Enter your email",
              editStyle: theme.style14W400,
              hintStyle: theme.style14W400Grey,
              color: Colors.grey,
              type: TextInputType.phone,
            ),
          ),
        ),
        UIHelper.verticalSpaceMedium,
        UIHelper.verticalSpaceMedium,
        SizedBox(
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              elevation: 0.0,
            ),
            onPressed: () {
              final model = context.read<UserViewModel>();
              loadingDialog(context);
              final res = model.updateUserProfile(
                _nameCtrl.text.trim(),
                _emailCtrl.text.trim(),
                _pickedImage?.path,
              );
              res.then((value) {
                Navigator.of(context).pop();
                if (value.status == ApiStatus.success) {
                  Navigator.of(context).pop();
                } else {
                  showErrorMessage(value.message);
                }
              });
            },
            child: Ink(
              width: double.maxFinite,
              height: 45,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffff0044),
                    Color(0xffff794d),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(80.0)),
              ),
              child: const Center(child: Text("Update")),
            ),
          ),
        ),
        const SizedBox(
          height: 150,
        ),
      ]),
    );
  }

  void _imagePickerOnTap() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
    );
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }
}
