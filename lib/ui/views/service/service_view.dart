import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/modal/service/category_service_modal.dart';

import '../../../core/constance/strings.dart';
import '../../../core/constance/style.dart';
import '../../../core/modal/category/add_on_modal.dart';
import '../../../core/view_modal/home/home_view_modal.dart';
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
  final _searchCtrl = TextEditingController();
  final _totalNfy = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    context.read<HomeViewModal>().fetchAllServicesByCategoryIds(
          "${widget.categoryId ?? ""}",
          "${widget.subCategoryId ?? ""}",
          "${widget.childCategoryId ?? ""}",
          search: widget.searchKey,
        );
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
      body: Consumer<HomeViewModal>(builder: (context, modal, _) {
        if (modal.busy) {
          return const Center(
            child: LoaderWidget(),
          );
        }

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
                    "${widget.childCategoryId ?? ""}",
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
                      return Container(
                        height: 140,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: button202z(
                          item.name,
                          theme.style11W600,
                          "Provider",
                          theme.style11W600Grey,
                          // price
                          // "\$${item.price[0].price.toStringAsFixed(0)}",
                          "₹ ${item.prices.first.price}",
                          // item.price[0].discPrice == 0
                          //     ? theme.style13W800
                          //     : theme.style13W400D,
                          theme.style13W800,
                          // discount price
                          // item.price[0].discPrice != 0
                          //     ? "\$${item.price[0].discPrice.toStringAsFixed(0)}"
                          //     : "",
                          "",
                          theme.style13W800Red,
                          //
                          4,
                          Colors.orangeAccent,
                          (darkMode) ? Colors.black : Colors.white,
                          // item.gallery.isNotEmpty ? item.gallery[0].serverPath : "",
                          item.imageUrl,
                          constraints.maxWidth,
                          8,
                          false,
                          (bool val) {
                            print('$val');
                          },
                          "",
                          theme.style10W400White,
                          false,
                          () {
                            showServiceModalView(item);
                          },
                          true,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  void showServiceModalView(CategoryServiceModal data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddOnViewWidget(data: data);
      },
    );
  }
}

class AddOnViewWidget extends StatefulWidget {
  final CategoryServiceModal data;

  const AddOnViewWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<AddOnViewWidget> createState() => _AddOnViewWidgetState();
}

class _AddOnViewWidgetState extends State<AddOnViewWidget> {
  final totalNfy = ValueNotifier<int>(0);
  final busyNfy = ValueNotifier(true);
  final qtyNfy = ValueNotifier(1);
  final addOnNfy = ValueNotifier<List<AddOnModal>>([]);

  @override
  void initState() {
    super.initState();
    totalNfy.value = widget.data.prices.first.price;
    final modal = context.read<HomeViewModal>();
    final res = modal.fetchServicesById("${widget.data.id}");
    // final res = modal.fetchAddOnModal(widget.data.id);
    res.then((value) {
      busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        return ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 140,
              child: button202z(
                data.name,
                theme.style11W600,
                "Providers",
                theme.style11W600Grey,
                // price
                // "\$${item.price[0].price.toStringAsFixed(0)}",
                "₹ ${data.prices.first.price}",
                // item.price[0].discPrice == 0
                //     ? theme.style13W800
                //     : theme.style13W400D,
                theme.style13W800,
                // discount price
                // item.price[0].discPrice != 0
                //     ? "\$${item.price[0].discPrice.toStringAsFixed(0)}"
                //     : "",
                "",
                theme.style13W800Red,
                //
                4,
                Colors.orangeAccent,
                (darkMode) ? Colors.black : Colors.white,
                // item.gallery.isNotEmpty ? item.gallery[0].serverPath : "",
                data.imageUrl,
                double.maxFinite,
                8,
                false,
                (bool val) {
                  print('$val');
                },
                "",
                theme.style10W400White,
                false,
                () {
                  // widget.openDialogService(item);
                },
                true,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("Description", style: theme.style12W800),
            const SizedBox(
              height: 5,
            ),
            Text((data.description).isNotEmpty ? data.description : "No description",
                style: theme.style12W400),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(strings.get(92),

                        /// "Quantity",
                        style: theme.style12W800)),
                ValueListenableBuilder<int>(
                  valueListenable: qtyNfy,
                  builder: (context, val, _) {
                    return buildQuantityView(
                      val,
                      onIncrement: () {
                        val++;
                        qtyNfy.value = val;
                        totalNfy.value += 300;
                      },
                      onDecrement: () {
                        val--;
                        qtyNfy.value = val;
                        totalNfy.value -= 300;
                      },
                    );
                  },
                )
              ],
            ),
            ValueListenableBuilder<List<AddOnModal>>(
              valueListenable: addOnNfy,
              builder: (context, val, _) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    double width = constraints.maxWidth / 3;
                    if (modal.addOnList.isEmpty) {
                      return Container();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UIHelper.verticalSpaceSmall,
                        Text(strings.get(93), style: theme.style12W800),
                        UIHelper.verticalSpaceSmall,
                        Wrap(
                          runSpacing: 12,
                          spacing: 12,
                          children: modal.addOnList.map((data) {
                            List<AddOnModal> ads = [...val];
                            // Get index of the each object
                            int index = ads.indexOf(data);
                            // Check is the value is present or not
                            bool isActive = val.contains(data);

                            return SizedBox(
                              width: width,
                              child: Column(
                                children: [
                                  _buildAddOnView(
                                    data,
                                    width: width,
                                    onTap: () {
                                      if (!isActive) {
                                        ads.add(data);
                                        totalNfy.value += data.price;
                                      } else {
                                        ads.remove(data);
                                        totalNfy.value -= data.price;
                                      }
                                      addOnNfy.value = ads;
                                    },
                                    isActive: isActive,
                                  ),
                                  if (isActive) UIHelper.verticalSpaceSmall,
                                  if (isActive)
                                    buildQuantityView(
                                      data.quantity,
                                      onIncrement: () {
                                        data.quantity++;
                                        ads[index] = data;
                                        addOnNfy.value = ads;
                                        // Increase service cost
                                        totalNfy.value += data.price;
                                      },
                                      onDecrement: () {
                                        data.quantity--;
                                        ads[index] = data;
                                        addOnNfy.value = ads;
                                        // Decrease service cost
                                        totalNfy.value -= data.price;
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
            Row(
              children: [
                Text(strings.get(95),

                    /// "Total amount",
                    style: theme.style12W800),
                const SizedBox(
                  width: 10,
                ),
                ValueListenableBuilder(
                  valueListenable: totalNfy,
                  builder: (context, val, _) {
                    return Text("₹ $val", style: theme.style13W800Red);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: button134(
                    strings.get(32),
                    () {
                      // currentProvider = provider[0];
                      // _openProvider();
                    },
                    true,
                    theme.style14W800MainColor,
                  ),
                ),

                /// "Provider",
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: button2s(
                      strings.get(94),

                      /// "Add to cart",
                      theme.style14W800W,
                      primaryColor,
                      10, () {
                    // _close();
                  }, true),
                )
              ],
            ),
          ],
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
                      Text(
                        data.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.orange : Colors.white,
                        ),
                        textAlign: TextAlign.center,
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

  buildQuantityView(
    int value, {
    VoidCallback? onIncrement,
    VoidCallback? onDecrement,
    int min = 1,
    int? max,
  }) {
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
