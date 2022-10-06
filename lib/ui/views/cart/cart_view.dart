import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/modal/address/user_address_model.dart';
import 'package:socspl/core/utils/string_extension.dart';
import 'package:socspl/core/view_modal/booking/booking_view_model.dart';
import 'package:socspl/core/view_modal/cart/cart_view_model.dart';
import 'package:socspl/core/view_modal/user/user_view_model.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/widgets/custom/custom_button.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../../core/modal/cart/cart_model.dart';
import '../../../core/modal/service/category_service_modal.dart';
import '../../../core/utils/storage/storage.dart';
import '../../shared/navigation/navigation.dart';
import '../booking/booking_date_view.dart';
import '../service/service_view.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final _busyNfy = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _busyNfy.value = true;
    final model = context.read<UserViewModel>();
    final res = model.fetchAddresses();
    res.then((value) {
      _busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Summary"),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Consumer(
                builder: (context, CartViewModel model, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpaceMedium,
                      ...model.carts.map(
                        (data) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.service.name,
                                            style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          UIHelper.verticalSpaceMedium,
                                          ...data.additionalServices.map((el) {
                                            return Row(
                                              children: [
                                                const Icon(Icons.circle,
                                                    size: 6, color: Colors.grey),
                                                UIHelper.horizontalSpaceSmall,
                                                Text(
                                                  "${el.addOnModal.name} x${el.quantity}",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: "Montserrat",
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black87,
                                                      height: 1.6),
                                                ),
                                              ],
                                            );
                                          })
                                        ],
                                      ),
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    SizedBox(
                                      height: 30,
                                      width: 70,
                                      child: Consumer<CartViewModel>(
                                        builder: (context, CartViewModel model, _) {
                                          CartModel? cart = model.containsService(data.service);
                                          if (cart != null) {
                                            return Material(
                                              elevation: 2.0,
                                              borderRadius: BorderRadius.circular(4),
                                              color: Theme.of(context).primaryColor,
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        if (cart.additionalServices.isNotEmpty) {
                                                        } else {
                                                          model.increaseServiceQty(cart);
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        "${cart.totalQuantity}",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        softWrap: false,
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        if (cart.additionalServices.isNotEmpty) {
                                                          showServiceModalView(data.service);
                                                        } else {
                                                          model.decreaseServiceQty(cart);
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return ElevatedButton(
                                              onPressed: () {
                                                if (Storage.instance.isLogin) {
                                                  if (cart != null) {
                                                    model.increaseServiceQty(cart);
                                                  } else {
                                                    var price = 0;
                                                    if (data.service.prices.isNotEmpty) {
                                                      price = data.service.prices.first.price;
                                                    }
                                                    model.addServiceToCart(
                                                      CartModel(
                                                        service: data.service,
                                                        quantity: 1,
                                                        totalPrice: price,
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  Navigation.instance
                                                      .navigate("/login", args: false);
                                                }
                                              },
                                              child: const Text(
                                                "Add",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    UIHelper.horizontalSpaceMedium,
                                    Text(
                                      "₹ ${data.totalAmount}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              UIHelper.verticalSpaceSmall,
                              Divider(thickness: 6, color: Colors.grey.shade200),
                              UIHelper.verticalSpaceSmall,
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Payment Summary",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            UIHelper.verticalSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Item total",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Montserrat",
                                    color: Colors.black54,
                                  ),
                                ),
                                UIHelper.horizontalSpaceMedium,
                                Text(
                                  "₹ ${model.getTotalPrice()}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Montserrat",
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            UIHelper.verticalSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Convenience fee",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Montserrat",
                                    color: Colors.black54,
                                  ),
                                ),
                                UIHelper.horizontalSpaceMedium,
                                Text(
                                  "₹ 0",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Montserrat",
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            UIHelper.verticalSpaceSmall,
                            const Divider(),
                            UIHelper.verticalSpaceSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                    color: Colors.black,
                                  ),
                                ),
                                UIHelper.horizontalSpaceMedium,
                                Text(
                                  "₹ ${model.getTotalPrice()}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      UIHelper.verticalSpaceSmall,
                      Divider(thickness: 6, color: Colors.grey.shade200),
                      UIHelper.verticalSpaceSmall,
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: SizedBox(
              width: double.maxFinite,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  showAddressModalView();
                },
                child: const Text(
                  "Add address and slot",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontSize: 14,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showServiceModalView(CategoryServiceModal data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        maxWidth: double.maxFinite,
      ),
      builder: (context) {
        return AddOnViewWidget(data: data);
      },
    );
  }

  void showAddressModalView() {
    final model = context.read<UserViewModel>();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ValueListenableBuilder(
              valueListenable: _busyNfy,
              builder: (context, bool busy, _) {
                if (busy) {
                  return const Center(
                    child: LoaderWidget(),
                  );
                }
                return Consumer<BookingViewModel>(
                  builder: (context, BookingViewModel bkModel, _) {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UIHelper.verticalSpaceSmall,
                                const Text(
                                  "Saved Addresses",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                UIHelper.verticalSpaceMedium,
                                InkWell(
                                  onTap: () {
                                    Navigation.instance.navigate("/booking-address");
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(Icons.add),
                                      UIHelper.horizontalSpaceSmall,
                                      Text(
                                        "Add another address",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                UIHelper.verticalSpaceSmall,
                                const Divider(thickness: 2),
                                UIHelper.verticalSpaceSmall,
                                ...model.userAddress.map((data) {
                                  return Column(
                                    children: [
                                      UIHelper.verticalSpaceSmall,
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Radio(
                                            value: data,
                                            groupValue: bkModel.userAddress,
                                            onChanged: (UserAddressModel? val) {
                                              bkModel.userAddress = val;
                                            },
                                          ),
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
                                          // IconButton(
                                          //   onPressed: bkModel.userAddress != null ? () {} : null,
                                          //   icon: const Icon(Icons.more_vert_outlined),
                                          // )
                                        ],
                                      ),
                                      UIHelper.verticalSpaceMedium,
                                      const Divider(thickness: 2),
                                      UIHelper.verticalSpaceSmall,
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                          child: CustomButton(
                            text: "Proceed",
                            onTap: bkModel.userAddress != null
                                ? () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const BookingDateView(),
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        ),
                      ],
                    );
                  },
                );
              });
        });
  }
}
