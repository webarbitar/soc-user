import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:socspl/core/modal/category/category_banner_modal.dart';
import 'package:socspl/core/modal/category/sub_category_modal.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/widgets/custom/custom_network_image.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';
import 'package:socspl/ui/widgets/view/service/service_widget.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constance/strings.dart';
import '../../../../core/constance/style.dart';
import '../../../../core/modal/service/category_service_modal.dart';
import '../../../../core/view_modal/cart/cart_view_model.dart';
import '../../../shared/navigation/navigation.dart';
import '../../../widgets/buttons/button202z.dart';
import '../../../widgets/edit26.dart';
import '../../service/service_view.dart';

class SubCategoryView extends StatefulWidget {
  final SubCategoryModal category;

  const SubCategoryView({Key? key, required this.category}) : super(key: key);

  @override
  State<SubCategoryView> createState() => _SubCategoryViewState();
}

class _SubCategoryViewState extends State<SubCategoryView> {
  final List<GlobalKey> itemsKey = [];
  final _busyNfy = ValueNotifier(false);
  final _searchCtrl = TextEditingController();
  VideoPlayerController? _videoCtrl;
  CategoryBannerModal? bannerModal;

  final _searchFilterNfy = ValueNotifier<List<CategoryServiceModal>>([]);
  bool _search = false;

  @override
  void initState() {
    super.initState();
    // context.read<HomeViewModal>().fetchSubCategoryModal(widget.category.id);
    initModule();
    context.read<CartViewModel>().initCartModule(widget.category);
  }

  void initModule() async {
    final sub = widget.category;
    _busyNfy.value = true;
    final model = context.read<HomeViewModal>();
    // Initialize the video player controller.
    if (widget.category.videoUrl != null && widget.category.videoUrl!.isNotEmpty) {
      _videoCtrl = VideoPlayerController.network(widget.category.videoUrl!)
        ..initialize().then((_) {
          _videoCtrl?.setVolume(0);
          _videoCtrl?.play();
          _videoCtrl?.setLooping(true);

          setState(() {});
        });
    }
    await model.fetchChildCategoryModal("${sub.categoryId}", "${sub.id}");

    // Creating global key for each item in child category
    if (model.childCategories.isNotEmpty) {
      for (var element in model.childCategories) {
        itemsKey.add(GlobalKey());
      }
    }
    model.fetchAllServicesByCategoryIds("${sub.categoryId}", "${sub.id}");
    _busyNfy.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final homeModel = context.read<HomeViewModal>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          widget.category.name,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Montserrat",
          ),
        ),
        elevation: 0.0,
      ),
      floatingActionButton: context.watch<HomeViewModal>().childCategories.isNotEmpty
          ? SizedBox(
              height: 35,
              child: FloatingActionButton.extended(
                  backgroundColor: Colors.black87,
                  onPressed: () {
                    _childCategoryModalView();
                  },
                  label: Row(
                    children: const [
                      Icon(
                        Icons.menu,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Menu",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Consumer(builder: (context, CartViewModel model, _) {
        if (!model.isPresent) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 14,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "₹ ${model.totalPrice}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: 160,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigation.instance.navigate("/cart");
                    },
                    child: const Text(
                      "View Cart",
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
      }),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
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
                setState(() {
                  _search = false;
                });
              },
              onChangeText: (val) {
                Future.delayed(
                  const Duration(milliseconds: 700),
                  () {
                    if (val.length > 3) {
                      // Check if search is true or not. To prevent unnecessary setState call
                      if (_search == false) {
                        setState(() {
                          _search = true;
                        });
                      }
                      final filter = homeModel.categoryServices
                          .where((element) => element.name.toLowerCase().contains(val.toLowerCase()))
                          .toList();
                      _searchFilterNfy.value = filter;
                    } else {
                      setState(() {
                        _search = false;
                      });
                    }
                  },
                );
              },
            ),
          ),
          UIHelper.verticalSpaceSmall,
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ValueListenableBuilder(
                  valueListenable: _busyNfy,
                  builder: (context, bool busy, _) {
                    if (busy) {
                      return const Center(
                        child: LoaderWidget(),
                      );
                    }
                    return IndexedStack(
                      index: _search ? 0 : 1,
                      children: [
                        ValueListenableBuilder(
                            valueListenable: _searchFilterNfy,
                            builder: (context, List<CategoryServiceModal> list, _) {
                              return ListView.builder(
                                itemCount: list.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(14),
                                itemBuilder: (context, index) {
                                  var item = list[index];
                                  return InkWell(
                                    onTap: () {
                                      showServiceModalView(item);
                                    },
                                    child: Column(
                                      children: [
                                        ServiceWidget(
                                          data: item,
                                          onTap: () {
                                            showServiceModalView(item);
                                          },
                                          redirectRoute: SubCategoryView(
                                            category: widget.category,
                                          ),
                                        ),
                                        if (list.length - 1 != index) const Divider()
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                        Consumer<HomeViewModal>(builder: (context, modal, _) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_videoCtrl != null) UIHelper.verticalSpaceMedium,
                                if (_videoCtrl != null && _videoCtrl!.value.isInitialized)
                                  FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      height: _videoCtrl!.value.size.width,
                                      width: _videoCtrl!.value.size.width,
                                      child: VideoPlayer(_videoCtrl!),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      UIHelper.verticalSpaceSmall,
                                      Text(
                                        widget.category.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: const [
                                          Icon(Icons.star),
                                          SizedBox(width: 6),
                                          // Text("0 (0)"),
                                          Text(
                                            "No Rating",
                                            style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (widget.category.description.isNotEmpty)
                                        UIHelper.verticalSpaceSmall,
                                      if (widget.category.description.isNotEmpty)
                                        Text(
                                          widget.category.description,
                                          style: const TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 13,
                                          ),
                                        ),
                                      UIHelper.verticalSpaceMedium,
                                      Builder(
                                        builder: (context) {
                                          if (modal.childCategories.isEmpty) {
                                            return SizedBox(
                                              height: constraints.maxHeight - 400,
                                              child: Center(
                                                child: Text(
                                                  "Service not available",
                                                  style: theme.style10W600Grey,
                                                ),
                                              ),
                                            );
                                          }
                                          return Wrap(
                                            spacing: 12,
                                            runSpacing: 12,
                                            children: modal.childCategories.map((data) {
                                              final width = (constraints.maxWidth / 3) - 18;
                                              return InkWell(
                                                onTap: () {
                                                  int index = modal.childCategories.indexOf(data);
                                                  Scrollable.ensureVisible(
                                                      itemsKey[index].currentContext!);
                                                },
                                                focusColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                radius: 8,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  width: width,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.topCenter,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(6),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(12),
                                                              color: highlightColor,
                                                            ),
                                                            child: CustomNetworkImage(
                                                              url: data.imageUrl,
                                                              height: 80,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      UIHelper.verticalSpaceSmall,
                                                      Padding(
                                                        padding: const EdgeInsets.all(8),
                                                        child: Center(
                                                          child: Text(
                                                            data.name,
                                                            style: theme.style11W600,
                                                            maxLines: 2,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                UIHelper.verticalSpaceSmall,
                                const Divider(
                                  color: highlightColor,
                                  thickness: 8,
                                ),
                                UIHelper.verticalSpaceSmall,
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    children: [
                                      ...modal.childCategories.map((chCate) {
                                        int index = modal.childCategories.indexOf(chCate);
                                        var filterServices = modal.categoryServices
                                            .where(
                                                (element) => element.childCategoryId == chCate.id)
                                            .toList();
                                        return Column(
                                          key: itemsKey[index],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            UIHelper.verticalSpaceMedium,
                                            Text(
                                              chCate.name,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.4,
                                                height: 1.4,
                                              ),
                                            ),
                                            UIHelper.verticalSpaceSmall,
                                            ListView.builder(
                                              itemCount: filterServices.length,
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                var item = filterServices[index];
                                                return InkWell(
                                                  onTap: () {
                                                    showServiceModalView(item);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      ServiceWidget(
                                                        data: item,
                                                        onTap: () {
                                                          showServiceModalView(item);
                                                        },
                                                        redirectRoute: SubCategoryView(
                                                          category: widget.category,
                                                        ),
                                                      ),
                                                      if (filterServices.length - 1 != index)
                                                        const Divider()
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                            UIHelper.verticalSpaceSmall,
                                            const Divider(
                                              thickness: 6,
                                              color: highlightColor,
                                            ),
                                            UIHelper.verticalSpaceSmall,
                                          ],
                                        );
                                      })
                                    ],
                                  ),
                                ),
                                UIHelper.verticalSpaceMedium,
                                UIHelper.verticalSpaceMedium,
                              ],
                            ),
                          );
                        })
                      ],
                    );
                  },
                );
              },
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
        return AddOnViewWidget(
          serviceId: data.id,
          redirectRoute: SubCategoryView(category: widget.category),
        );
      },
    );
  }

  void _childCategoryModalView() {
    final model = context.read<HomeViewModal>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       category.name,
                //       style: const TextStyle(
                //           fontFamily: "Montserrat",
                //           fontSize: 16,
                //           fontWeight: FontWeight.w600,
                //           letterSpacing: 0.4,
                //           height: 1.4),
                //     ),
                //     UIHelper.horizontalSpaceMedium,
                //     IconButton(
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //       visualDensity: VisualDensity.compact,
                //       padding: EdgeInsets.zero,
                //       icon: const Icon(Icons.close),
                //     ),
                //   ],
                // ),
                // UIHelper.verticalSpaceMedium,
                UIHelper.verticalSpaceSmall,
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 12,
                      runSpacing: 16,
                      // crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      children: model.childCategories.map((data) {
                        final width = (constraints.maxWidth / 3) - 8;
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            int index = model.childCategories.indexOf(data);
                            Scrollable.ensureVisible(itemsKey[index].currentContext!);
                          },
                          child: SizedBox(
                            width: width,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: highlightColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    child: CustomNetworkImage(
                                      url: data.imageUrl,
                                      width: width,
                                      height: 80,
                                    ),
                                  ),
                                ),
                                UIHelper.verticalSpaceSmall,
                                Text(
                                  data.name,
                                  style: const TextStyle(
                                    fontFamily: "Montserrat",
                                    letterSpacing: 0.4,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoCtrl?.dispose();
  }
}
