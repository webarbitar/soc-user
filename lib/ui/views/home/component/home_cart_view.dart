import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/core/modal/category/category_modal.dart';
import 'package:socspl/core/view_modal/cart/cart_view_model.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/views/cart/cart_view.dart';
import 'package:socspl/ui/views/home/home_view.dart';

import '../../../../core/modal/cart/cart_model.dart';
import '../../../../core/modal/service/category_service_modal.dart';
import '../../../../core/view_modal/home/home_view_modal.dart';
import '../../service/service_view.dart';

class HomeCartView extends StatefulWidget {
  const HomeCartView({Key? key}) : super(key: key);

  @override
  State<HomeCartView> createState() => _HomeCartViewState();
}

class _HomeCartViewState extends State<HomeCartView> {
  int? selectedCategory;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        elevation: 0.2,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Consumer2<HomeViewModal, CartViewModel>(
        builder: (context, homeModel, cartModel, _) {
          if (cartModel.carts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 50,
                    color: Colors.black,
                  ),
                  UIHelper.verticalSpaceMedium,
                  Text(
                    "Your cart is empty",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                UIHelper.verticalSpaceSmall,
                ...cartModel.carts.map((data) {
                  final cat = homeModel.categories.singleWhere((el) => el.id == data.categoryId);
                  return InkWell(
                    onTap: () {
                      cartModel.initCartModule(cat);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CartView(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                          boxShadow: [dropShadow],
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: "Montserrat",
                            ),
                          ),
                          UIHelper.verticalSpaceMedium,
                          ...data.items.map(
                            (item) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.service.name,
                                                style: const TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              if (item.additionalItem.isNotEmpty)
                                                UIHelper.verticalSpaceSmall,
                                              if (item.additionalItem.isNotEmpty)
                                                ...item.additionalItem.map((el) {
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
                                        Text(
                                          "₹ ${item.totalAmount}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(thickness: 2, color: Colors.grey.shade200),
                                ],
                              );
                            },
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
        return AddOnViewWidget(
          serviceId: data.id,
          redirectRoute: const HomeView(),
        );
      },
    );
  }
}
