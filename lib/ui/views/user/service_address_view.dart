import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/address/user_address_model.dart';
import 'package:socspl/core/utils/string_extension.dart';
import 'package:socspl/ui/views/booking/booking_address_view.dart';
import 'package:socspl/ui/widgets/custom/custom_button.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../../core/view_modal/user/user_view_model.dart';
import '../../shared/ui_helpers.dart';

class ServiceAddressView extends StatefulWidget {
  const ServiceAddressView({Key? key}) : super(key: key);

  @override
  State<ServiceAddressView> createState() => _ServiceAddressViewState();
}

class _ServiceAddressViewState extends State<ServiceAddressView> {
  final _busyNfy = ValueNotifier(false);

  late UserAddressModel _selectedAddress;

  @override
  void initState() {
    super.initState();
    final model = context.read<UserViewModel>();
    _busyNfy.value = true;
    final res = model.fetchAddresses();
    res.then((value) {
      _busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          children: [
            const Expanded(
              child: Text(
                "Service Address",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BookingAddressView(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.add_circle_outline,
                      size: 20,
                      color: primaryColor,
                    ),
                    UIHelper.horizontalSpaceSmall,
                    Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      body: ValueListenableBuilder(
          valueListenable: _busyNfy,
          builder: (context, bool busy, _) {
            if (busy) {
              return const Center(
                child: LoaderWidget(),
              );
            }
            return Consumer<UserViewModel>(
              builder: (context, userModel, _) {
                if (userModel.userAddress.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "No address found",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        UIHelper.verticalSpaceMedium,
                      ],
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ...userModel.userAddress.map((data) {
                        return InkWell(
                          onTap: () {
                            _selectedAddress = data;
                            showActionBottomModal();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [dropShadow],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.all(14),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                _buildIcon(data.type),
                                UIHelper.horizontalSpaceSmall,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.type.capitalize(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      UIHelper.verticalSpaceSmall,
                                      Text(
                                        "${data.name} - ${data.mobile}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data.formattedAddress,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

  Widget _buildIcon(String type) {
    switch (type) {
      case "home":
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.shade200,
          ),
          child: const Icon(
            Icons.home,
            size: 20,
          ),
        );

      default:
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.shade200,
          ),
          child: const Icon(
            Icons.business_center_outlined,
            size: 20,
          ),
        );
    }
  }

  void showActionBottomModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Colors.green.shade400,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BookingAddressView(
                        userAddress: _selectedAddress,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
                title: const Text(
                  "Update Address",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Divider(height: 2, thickness: 2),
              const SizedBox(height: 4),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.red.shade400,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  showConfirmationDialog();
                },
                title: const Text(
                  "Delete Address",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
            "Delete Service Address?",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are you sure you want to delete the saved address?",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              UIHelper.verticalSpaceMedium,
              Row(
                children: [
                  Flexible(
                    child: CustomButton(
                      text: "Cancel",
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      width: 180,
                    ),
                  ),
                  UIHelper.horizontalSpaceMedium,
                  Flexible(
                    child: CustomButton(
                      text: "Delete",
                      color: Colors.deepOrange,
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _busyNfy.value = true;
                        final model = context.read<UserViewModel>();
                        final res = model.deleteAddress(_selectedAddress);
                        res.then(
                          (value) {
                            if (value.status == ApiStatus.success) {
                              _busyNfy.value = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value.message,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                  backgroundColor: Colors.green.shade400,
                                ),
                              );
                            }
                          },
                        );
                      },
                      width: 180,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
