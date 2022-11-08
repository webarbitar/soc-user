import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/ui/shared/navigation/navigation.dart';
import 'package:socspl/ui/widgets/custom/custom_network_image.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../../../core/constance/strings.dart';
import '../../../../core/constance/style.dart';
import '../../../../core/modal/category/category_modal.dart';
import '../../../../core/utils/storage/storage.dart';
import '../../../shared/ui_helpers.dart';
import '../../../widgets/edit26.dart';
import '../../../widgets/ibanner.dart';
import '../../service/service_details_view.dart';
import '../../service/service_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  final _controllerSearch = TextEditingController();
  String _searchText = "";

  @override
  void dispose() {
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Storage.instance.pref.getStringList("carts"));
    super.build(context);
    return Scaffold(
      backgroundColor: darkMode ? Colors.black : mainColorGray,
      body: SafeArea(
        child: Consumer<HomeViewModal>(builder: (context, modal, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                elevation: 2.0,
                shadowColor: Colors.grey.shade200,
                primary: false,
                backgroundColor: backgroundColor,
                expandedHeight: 122,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  stretchModes: const [
                    StretchMode.fadeTitle,
                    StretchMode.blurBackground,
                  ],
                  expandedTitleScale: 1,
                  collapseMode: CollapseMode.pin,
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 0, 45),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                Navigation.instance.navigate("/pick-location");
                              },
                              child: Row(
                                children: [
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Flexible(
                                    child: Text(
                                      modal.currentAddress,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Stack(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.chat,
                                            color: Colors.grey,
                                            size: 22,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: -3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 3, right: 3),
                                            child: Container(
                                              height: 16,
                                              width: 16,
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "4",
                                                  style: theme.style10W400White,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: Stack(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.notifications,
                                            color: Colors.grey,
                                            size: 22,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: -3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 3, right: 3),
                                            child: Container(
                                              height: 16,
                                              width: 16,
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "4",
                                                  style: theme.style10W400White,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size(double.maxFinite, 70),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Edit26(
                            hint: strings.get(24),
                            color: (darkMode) ? Colors.black : Colors.white,
                            style: theme.style14W400,
                            radius: 10,
                            useAlpha: false,
                            icon: Icons.search,
                            suffixIcon: Icons.cancel,
                            type: TextInputType.text,
                            controller: _controllerSearch,
                            textInputAction: TextInputAction.search,
                            onSubmit: (String val) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ServiceView(
                                    searchKey: val.trim(),
                                  ),
                                ),
                              );
                            },
                            onSuffixIconPress: () {
                              _searchText = "";
                              _controllerSearch.text = "";
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.filter_alt,
                              color: primaryColor,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  if (modal.busy) {
                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: constraints.remainingPaintExtent,
                        child: const Center(
                          child: LoaderWidget(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    );
                  } else {
                    if (modal.city == null) {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: constraints.remainingPaintExtent,
                          width: double.maxFinite,
                          child: const Center(
                            child: SizedBox(
                              width: 320,
                              child: Text(
                                "Sorry for inconvenience, our service is not available in this area.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (modal.banners.isNotEmpty) UIHelper.verticalSpaceSmall,
                                  if (modal.banners.isNotEmpty)
                                    Center(
                                      child: IBanner(
                                        modal.banners,
                                        width: constraints.crossAxisExtent,
                                        height: constraints.crossAxisExtent * 0.45,
                                        colorActive: primaryColor,
                                        colorProgressBar: primaryColor,
                                        radius: 6,
                                        shadow: 0,
                                        style: theme.style16W400,
                                        callback: (String id, String heroId, String image) {},
                                        seconds: 3,
                                      ),
                                    ),
                                  UIHelper.verticalSpaceMedium,
                                  UIHelper.verticalSpaceSmall,
                                  Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    child: _horizontalCategories(),
                                  ),
                                  UIHelper.verticalSpaceMedium,
                                  if (modal.homeBanner.isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        var hb = modal.homeBanner.first;
                                        if (hb.serviceId != 0) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ServiceDetailsView(
                                                  serviceId: hb.serviceId,
                                                  categoryId: hb.categoryId),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        color: Colors.red.shade50,
                                        child: CachedNetworkImage(
                                          width: double.maxFinite,
                                          imageUrl: modal.homeBanner.first.imageUrl,
                                        ),
                                      ),
                                    ),

                                  if (modal.offerBanners.isNotEmpty) UIHelper.verticalSpaceMedium,
                                  if (modal.offerBanners.isNotEmpty) UIHelper.verticalSpaceMedium,
                                  if (modal.offerBanners.isNotEmpty)
                                    Center(
                                      child: PromoBanner(
                                        modal.offerBanners,
                                        width: constraints.crossAxisExtent,
                                        height: constraints.crossAxisExtent * 0.45,
                                        colorActive: primaryColor,
                                        colorProgressBar: primaryColor,
                                        radius: 6,
                                        shadow: 0,
                                        style: theme.style16W400,
                                        callback: (String id, String heroId, String image) {},
                                        seconds: 3,
                                      ),
                                    ),
                                  // ...modal.offerBanners.map((data) {
                                  //   return CachedNetworkImage(imageUrl: data.imageUrl);
                                  // }),
                                  UIHelper.verticalSpaceMedium,
                                  Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    child: _trendingCategories(),
                                  ),

                                  UIHelper.verticalSpaceMedium,
                                  if (modal.homeBanner.isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        var hb = modal.homeBanner.last;
                                        if (hb.serviceId != 0) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ServiceDetailsView(
                                                  serviceId: hb.serviceId,
                                                  categoryId: hb.categoryId),
                                            ),
                                          );
                                        }
                                      },
                                      child: CachedNetworkImage(
                                        width: double.maxFinite,
                                        imageUrl: modal.homeBanner.last.imageUrl,
                                      ),
                                    ),
                                  UIHelper.verticalSpaceMedium,
                                  Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    child: _buildSectionView(),
                                  ),
                                  UIHelper.verticalSpaceMedium,
                                  if (modal.workBanners.isNotEmpty) UIHelper.verticalSpaceMedium,
                                  if (modal.workBanners.isNotEmpty)
                                    Center(
                                      child: PromoBanner(
                                        modal.workBanners,
                                        width: constraints.crossAxisExtent,
                                        height: constraints.crossAxisExtent * 0.45,
                                        colorActive: primaryColor,
                                        colorProgressBar: primaryColor,
                                        radius: 6,
                                        shadow: 0,
                                        style: theme.style16W400,
                                        callback: (String id, String heroId, String image) {},
                                        seconds: 3,
                                      ),
                                    ),
                                  // ...modal.workBanners.map((data) {
                                  //   return CachedNetworkImage(imageUrl: data.imageUrl);
                                  // }),
                                  UIHelper.verticalSpaceMedium,
                                  _buildTestimonial(),
                                  UIHelper.verticalSpaceMedium,
                                  if (modal.homeBanner.isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        var hb = modal.homeBanner[1];
                                        if (hb.serviceId != 0) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ServiceDetailsView(
                                                  serviceId: hb.serviceId,
                                                  categoryId: hb.categoryId),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        color: Colors.deepPurple.shade50,
                                        child: CachedNetworkImage(
                                          width: double.maxFinite,
                                          imageUrl: modal.homeBanner[1].imageUrl,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _horizontalCategories() {
    final modal = context.watch<HomeViewModal>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 12,
          runSpacing: 16,
          // crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          children: modal.categories.map((data) {
            final width = (constraints.maxWidth / 3) - 8;
            return InkWell(
              onTap: () {
                _subCategoryModalView(data);
              },
              child: SizedBox(
                width: width,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: highlightColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        width: width,
                        height: 80,
                        child: CustomNetworkImage(
                          url: data.imageUrl,
                          height: 180,
                          fit: BoxFit.fitHeight,
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
    );
  }

  void _subCategoryModalView(CategoryModal category) {
    final model = context.read<HomeViewModal>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        height: 1.4),
                  ),
                  UIHelper.horizontalSpaceMedium,
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              UIHelper.verticalSpaceMedium,
              UIHelper.verticalSpaceSmall,
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    // crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    children: category.subcategories.map((data) {
                      final width = (constraints.maxWidth / 3) - 8;
                      return InkWell(
                        onTap: () {
                          Navigation.instance.navigate("/sub-category", args: data);
                        },
                        child: SizedBox(
                          width: width,
                          child: Column(
                            children: [
                              if (data.imageUrl.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    width: width,
                                    height: 80,
                                    child: CachedNetworkImage(
                                      imageUrl: data.imageUrl,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  decoration: const BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  width: width,
                                  height: 80,
                                  child: const Text("No image"),
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
        );
      },
    );
  }

  Widget _trendingCategories() {
    final modal = context.read<HomeViewModal>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          itemCount: modal.trendingCategories.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final cate = modal.trendingCategories[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cate.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Montserrat",
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (cate.description.isNotEmpty) const SizedBox(height: 6),
                          if (cate.description.isNotEmpty)
                            Text(
                              cate.description,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall,
                    // button134(
                    //   strings.get(26),
                    //   () {
                    //     // modal.selectedCategory = cate.name;
                    //     // Navigation.instance.navigate("/sub-category", args: cate);
                    //   },
                    //   true,
                    //   theme.style14W800MainColor,
                    // )
                  ],
                ),
                UIHelper.horizontalSpaceSmall,
                const Divider(),
                UIHelper.horizontalSpaceSmall,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    // crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    children: cate.subCategories.map((data) {
                      final width = (constraints.maxWidth / 3) - 8;
                      return InkWell(
                        onTap: () {
                          modal.selectedSubCategory = data.name;
                          Navigation.instance.navigate("/sub-category", args: data);
                        },
                        child: SizedBox(
                          width: width,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: highlightColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  width: width,
                                  height: 90,
                                  child: CustomNetworkImage(
                                    url: data.imageUrl,
                                    fit: BoxFit.cover,
                                    height: 240,
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
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                UIHelper.verticalSpaceSmall,
              ],
            );
          },
        );
      },
    );
  }

  _buildSectionView() {
    final modal = context.read<HomeViewModal>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            ...modal.sections.map((data) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.title,
                                  style: theme.style14W800,
                                ),
                                Text(
                                  data.subtitle,
                                  style: theme.style12W400,
                                ),
                              ],
                            ),
                          ),
                          // button134(
                          //   strings.get(26),
                          //   () {
                          //     // modal.selectedCategory = data.name;
                          //     // Navigation.instance.navigate("/sub-category", args: data.id);
                          //   },
                          //   true,
                          //   theme.style14W800MainColor,
                          // )
                        ],
                      )),
                  UIHelper.verticalSpaceSmall,
                  SizedBox(
                    height: 190,
                    child: ListView.builder(
                      itemCount: data.services.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var serv = data.services[index];
                        return Padding(
                          padding: const EdgeInsets.all(6),
                          child: InkWell(
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => ChildCategoryView(
                              //       categoryId: data.id,
                              //       subCategoryId: serv.id,
                              //     ),
                              //   ),
                              // );

                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ServiceDetailsView(
                                    categoryId: serv.categoryId,
                                    serviceId: serv.serviceId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: constraints.maxWidth * 0.40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: SizedBox(
                                        height: 90,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: CustomNetworkImage(
                                            url: serv.imageUrl,
                                            fit: BoxFit.cover,
                                            height: 180,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        UIHelper.verticalSpaceSmall,
                                        Text(
                                          serv.title,
                                          style: theme.style11W600,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          serv.subtitle,
                                          style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 11,
                                              letterSpacing: 0.4,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                ],
              );
            }),
          ],
        );
      },
    );
  }

  _buildTestimonial() {
    final model = context.watch<HomeViewModal>();
    return LayoutBuilder(builder: (context, constraint) {
      double width = constraint.maxWidth - 28;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...model.testimonials.map((data) {
              return Container(
                width: width,
                height: 230,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(14),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Montserrat",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              "${data.rating}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Expanded(
                      child: UIHelper.verticalSpaceMedium,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "\“",
                          style: TextStyle(
                              fontSize: 26,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 0.4),
                        ),
                        Center(
                          child: Text(
                            data.description,
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.4,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "\„",
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: UIHelper.verticalSpaceSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.account_circle_outlined,
                          color: backgroundColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: backgroundColor,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            })
          ],
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
