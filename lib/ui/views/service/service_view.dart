import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/modal/service/category_service_modal.dart';
import 'package:socspl/ui/views/category/rate_card/rate_card_view.dart';
import 'package:socspl/ui/views/home/home_view.dart';
import 'package:socspl/ui/views/service/service_details_view.dart';
import 'package:socspl/ui/widgets/view/service/service_widget.dart';

import '../../../core/constance/strings.dart';
import '../../../core/constance/style.dart';
import '../../../core/modal/cart/cart_model.dart';
import '../../../core/modal/category/add_on_modal.dart';
import '../../../core/utils/storage/storage.dart';
import '../../../core/view_modal/cart/cart_view_model.dart';
import '../../../core/view_modal/home/home_view_modal.dart';
import '../../shared/navigation/navigation.dart';
import '../../shared/ui_helpers.dart';
import '../../widgets/buttons/button134.dart';
import '../../widgets/buttons/button2.dart';
import '../../widgets/buttons/button202z.dart';
import '../../widgets/edit26.dart';
import '../../widgets/loader/loader_widget.dart';

class ServiceView extends StatefulWidget {
  final int? categoryId;
  final int? subCategoryId;
  final int? childCategoryId;
  final String searchKey;

  const ServiceView({
    Key? key,
    this.categoryId,
    this.subCategoryId,
    this.childCategoryId,
    this.searchKey = "",
  }) : super(key: key);

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  final _busyNfy = ValueNotifier(false);
  final _searchCtrl = TextEditingController();
  final _totalNfy = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    final model = context.read<HomeViewModal>();
    _busyNfy.value = true;

    final res = model.fetchAllServicesByCategoryIds(
      "${widget.categoryId ?? ""}",
      "${widget.subCategoryId ?? ""}",
      childCategoryId: "${widget.childCategoryId ?? ""}",
      search: widget.searchKey,
    );
    res.then((value) {
      _busyNfy.value = false;
    });
    _searchCtrl.text = widget.searchKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          context.read<HomeViewModal>().selectedCategory,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Montserrat",
          ),
        ),
        elevation: 0.0,
      ),
      // bottomNavigationBar: Consumer(builder: (context, CartViewModel model, _) {
      //   if (!model.isPresent) {
      //     return const SizedBox();
      //   }
      //   return Padding(
      //     padding: const EdgeInsets.symmetric(
      //       vertical: 8.0,
      //       horizontal: 14,
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 12),
      //           child: Text(
      //             "₹ ${model.totalPrice}",
      //             style: const TextStyle(
      //               fontSize: 18,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //         Flexible(
      //           child: SizedBox(
      //             width: 160,
      //             height: 45,
      //             child: ElevatedButton(
      //               onPressed: () {
      //                 Navigation.instance.navigate("/cart");
      //               },
      //               child: const Text(
      //                 "View Cart",
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontFamily: "Montserrat",
      //                   fontSize: 14,
      //                   height: 1.3,
      //                   fontWeight: FontWeight.w600,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
      // }),
      body: ValueListenableBuilder(
        valueListenable: _busyNfy,
        builder: (context, bool busy, _) {
          if (busy) {
            return const Center(
              child: LoaderWidget(),
            );
          }
          return Consumer<HomeViewModal>(builder: (context, modal, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Edit26(
                    hint: strings.get(24),
                    color: (darkMode) ? Colors.black : Colors.white,
                    style: theme.style14W400,
                    radius: 10,
                    useAlpha: false,
                    icon: Icons.search,
                    controller: _searchCtrl,
                    suffixIcon: Icons.cancel,
                    onSuffixIconPress: () {
                      _searchCtrl.text = "";
                    },
                    onSubmit: (val) {
                      modal.fetchAllServicesByCategoryIds(
                        "${widget.categoryId ?? ""}",
                        "${widget.subCategoryId ?? ""}",
                        childCategoryId: "${widget.childCategoryId ?? ""}",
                        search: val.trim(),
                      );
                    },
                  ),
                ),
                UIHelper.verticalSpaceSmall,
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (modal.categoryServices.isEmpty) {
                        return SizedBox(
                          child: Center(
                            child: Text(
                              "No data found",
                              style: theme.style10W600Grey,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: modal.categoryServices.length,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        itemBuilder: (context, index) {
                          final item = modal.categoryServices[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ServiceDetailsView(
                                      serviceId: item.id, categoryId: item.categoryId),
                                ),
                              );
                            },
                            child: ServiceWidget(
                              data: item,
                              onTap: () {},
                              enableAddCart: false,
                              redirectRoute: const HomeView(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          });
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
          redirectRoute: ServiceView(
            categoryId: widget.categoryId,
            subCategoryId: widget.subCategoryId,
            childCategoryId: widget.childCategoryId,
            searchKey: widget.searchKey,
          ),
        );
      },
    );
  }
}

class AddOnViewWidget extends StatefulWidget {
  final bool isDraggable;
  final int serviceId;
  final Widget redirectRoute;

  const AddOnViewWidget({
    Key? key,
    required this.serviceId,
    required this.redirectRoute,
    this.isDraggable = true,
  }) : super(key: key);

  @override
  State<AddOnViewWidget> createState() => _AddOnViewWidgetState();
}

class _AddOnViewWidgetState extends State<AddOnViewWidget> {
  final busyNfy = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    final modal = context.read<HomeViewModal>();
    final res = modal.fetchServicesById("${widget.serviceId}");
    // final res = modal.fetchAddOnModal(widget.data.id);
    res.then((value) {
      busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDraggable) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
        child: DraggableScrollableSheet(
            initialChildSize: 1.0,
            minChildSize: 0.5,
            expand: false,
            snap: true,
            builder: (context, controller) {
              return Column(
                children: [
                  Expanded(
                    child: _buildMainContentView(controller: controller),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                    child: button2s(
                      "Done",
                      theme.style14W800W,
                      primaryColor,
                      10,
                      () {
                        Navigator.of(context).pop();
                      },
                      true,
                    ),
                  ),
                ],
              );
            }),
      );
    }
    return _buildMainContentView();
  }

  Widget _buildMainContentView({ScrollController? controller}) {
    final modal = context.read<HomeViewModal>();
    return ValueListenableBuilder(
      valueListenable: busyNfy,
      builder: (context, bool val, _) {
        if (val) {
          return const Center(
            child: LoaderWidget(),
          );
        }
        final data = modal.serviceModal!;

        return SingleChildScrollView(
          controller: controller,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.imageUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: data.imageUrl,
                  width: double.maxFinite,
                ),
              UIHelper.verticalSpaceMedium,
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: 4.75,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18.0,
                                    direction: Axis.horizontal,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text("4.75 (2.3K)")
                                ],
                              ),
                            ],
                          ),
                        ),
                        Consumer<CartViewModel>(
                          builder: (context, CartViewModel model, _) {
                            CartItem? cart = model.containsService(data);
                            if (cart != null && cart.quantity != 0) {
                              return Material(
                                elevation: 2.0,
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).primaryColor,
                                child: SizedBox(
                                  height: 30,
                                  width: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            model.decreaseServiceQty(cart);
                                          },
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${cart.quantity}",
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
                                            model.increaseServiceQty(cart);
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (Storage.instance.isLogin) {
                                      if (cart != null) {
                                        model.increaseServiceQty(cart);
                                      } else {
                                        var price = 0;
                                        if (data.prices.isNotEmpty) {
                                          price = data.prices.first.price;
                                        }
                                        model.addServiceToCart(
                                          CartItem(
                                            service: data,
                                            quantity: 1,
                                            totalPrice: price,
                                          ),
                                        );
                                      }
                                    } else {
                                      Navigation.instance.navigate(
                                        "/login",
                                        args: widget.redirectRoute,
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹ ${data.prices.first.price}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    UIHelper.verticalSpaceMedium,
                    if (data.rateCards.isNotEmpty)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  RateCardView(childCategoryId: data.childCategoryId),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.list_alt_outlined,
                                color: Colors.orange.shade200,
                              ),
                              UIHelper.horizontalSpaceSmall,
                              const Text(
                                "Charge will be as per rate card",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              UIHelper.horizontalSpaceSmall,
                              const Icon(Icons.keyboard_arrow_right_outlined),
                            ],
                          ),
                        ),
                      ),
                    UIHelper.verticalSpaceMedium,
                    const Divider(thickness: 5),
                    UIHelper.verticalSpaceMedium,
                    Text(
                      "Description",
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          letterSpacing: 0.4,
                          fontSize: 15,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          color: (darkMode) ? Colors.white : Colors.black),
                    ),
                    UIHelper.verticalSpaceSmall,
                    Html(
                      data: data.description,
                      style: {
                        "body": Style(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          fontFamily: "Montserrat",
                          fontSize: FontSize.em(0.9),
                          letterSpacing: 0.3,
                        ),
                      },
                    ),
                    UIHelper.verticalSpaceMedium,
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double width = (constraints.maxWidth / 3) - 8;
                        if (modal.addOnList.isEmpty) {
                          return Container();
                        }
                        return Consumer(
                          builder: (context, CartViewModel model, _) {
                            CartItem? cart = model.containsService(data);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UIHelper.verticalSpaceSmall,
                                Text(strings.get(93), style: theme.style12W800),
                                UIHelper.verticalSpaceSmall,
                                Wrap(
                                  runSpacing: 12,
                                  spacing: 12,
                                  children: modal.addOnList.map((data2) {
                                    var cartAd = model.containsAdditionalService(data, data2);

                                    return SizedBox(
                                      width: width,
                                      child: Column(
                                        children: [
                                          _buildAddOnView(
                                            data2,
                                            width: width,
                                            onTap: () {
                                              if (cartAd != null) {
                                                model.removeAddOnServiceFromCart(cart!, cartAd);
                                              } else {
                                                model.addAddOnServiceToCart(data, data2);
                                              }
                                            },
                                            isActive: cartAd != null,
                                          ),
                                          if (cartAd != null) UIHelper.verticalSpaceSmall,
                                          if (cartAd != null)
                                            buildQuantityView(
                                              cartAd.quantity,
                                              onIncrement: () {
                                                model.increaseAdditionalServiceQty(cart!, cartAd);
                                              },
                                              onDecrement: () {
                                                model.decreaseAdditionalServiceQty(cart!, cartAd);
                                              },
                                            ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddOnView(AddOnModal data,
      {VoidCallback? onTap, bool isActive = false, double? width}) {
    print(data.imageUrl);
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: width,
          height: 90,
          child: Stack(
            children: [
              CachedNetworkImage(
                errorWidget: (context, url, error) {
                  return Container();
                },
                imageUrl: data.imageUrl,
                fit: BoxFit.cover,
                height: 90,
              ),
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  color: isActive ? Colors.black54 : Colors.black38,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          data.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.orange : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      UIHelper.verticalSpaceSmall,
                      Text(
                        "₹ ${data.price}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.orange : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildQuantityView(int value,
      {VoidCallback? onIncrement, VoidCallback? onDecrement, int min = 1, int? max}) {
    bool decStat = value > min;
    bool incStat = max != null ? value < max : true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: decStat ? onDecrement : null,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: decStat ? primaryColor : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.exposure_minus_1,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text("$value", style: theme.style14W800),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: incStat ? onIncrement : null,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: incStat ? primaryColor : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.plus_one,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
