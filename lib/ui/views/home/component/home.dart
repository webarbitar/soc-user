import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/modal/messsage_model.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/ui/shared/navigation/navigation.dart';
import 'package:socspl/ui/views/chat_room_view.dart';
import 'package:socspl/ui/views/home/component/home_booking_view.dart';
import 'package:socspl/ui/widgets/custom/custom_network_image.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../../../core/constance/style.dart';
import '../../../../core/modal/category/category_modal.dart';
import '../../../../core/view_modal/booking/booking_view_model.dart';
import '../../../../core/view_modal/user/user_view_model.dart';
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
  late final UserViewModel _userViewModel;
  final _searchFocus = FocusNode();
  String _searchText = "";
  Query<Map<String, dynamic>>? fcmQuery;

  @override
  void initState() {
    super.initState();
    _userViewModel = context.read<UserViewModel>();
    _initFirebaseMessage();
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'message_channel_group',
          channelKey: 'message_channel',
          channelName: 'Message notifications',
          channelDescription: 'Notification channel for message',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
      // // Channel groups are only visual and are not required
      // channelGroups: [
      //   NotificationChannelGroup(
      //       channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')
      // ],
      debug: true,
    );
    _searchFocus.addListener(() {
      setState(() {});
    });
  }

  _initFirebaseMessage() {
    if (_userViewModel.user != null) {
      fcmQuery = FirebaseFirestore.instance
          .collection('chat_message')
          .where("read", isEqualTo: false)
          .where("receiverId", isEqualTo: _userViewModel.user?.id)
          .orderBy('createdAt', descending: true);
      fcmQuery?.snapshots().listen((event) {
        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              if (!change.doc.get("delivered")) {
                change.doc.reference.update({"delivered": true});
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: Random().nextInt(8),
                    channelKey: 'message_channel',
                    title: change.doc.get("messageBy"),
                    body: change.doc.get("message"),
                    category: NotificationCategory.Message,
                  ),
                );
              }
              break;
            case DocumentChangeType.modified:
              break;
            default:
              break;
          }
        }
      });
    }
  }

  showLocalNotification() {}

  @override
  void dispose() {
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(_searchFocus.hasFocus);
    return Scaffold(
      backgroundColor: mainColorGray,
      body: SafeArea(
        child: Consumer<HomeViewModal>(builder: (context, modal, _) {
          print(modal.city?.name);
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                elevation: 2.0,
                shadowColor: Colors.grey.shade200,
                primary: false,
                backgroundColor: primaryColor,
                expandedHeight: 120,
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
                    child: SizedBox(
                      height: 45,
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
                                          fontSize: 13,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          if (_userViewModel.user != null)
                            Flexible(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (fcmQuery != null)
                                      StreamBuilder(
                                          stream: fcmQuery!.snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                                  snapshot) {
                                            return IconButton(
                                                onPressed: () {
                                                  final messages = MessageModel.parseFCMList(
                                                      snapshot.data?.docs ?? []);
                                                  // fcmQuery?.get().then((value) {
                                                  //   final batch =
                                                  //       FirebaseFirestore.instance.batch();
                                                  //   for (var el in value.docs) {
                                                  //     batch.update(el.reference, {"read": true});
                                                  //   }
                                                  //   batch.commit();
                                                  // });
                                                  showMessageViewDialog(messages);
                                                },
                                                icon: Stack(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.all(6.0),
                                                      child: Icon(
                                                        Icons.chat,
                                                        size: 22,
                                                      ),
                                                    ),
                                                    if (snapshot.data != null &&
                                                        snapshot.data!.docs.isNotEmpty)
                                                      Positioned(
                                                        top: 0,
                                                        right: -3,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 3, right: 3),
                                                          child: Container(
                                                            height: 16,
                                                            width: 16,
                                                            decoration: const BoxDecoration(
                                                              color: Colors.red,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "${snapshot.data!.docs.length}",
                                                                style: theme.style10W400White,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ],
                                                ));
                                          }),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Stack(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: Icon(
                                                Icons.notifications,
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
                ),
                bottom: PreferredSize(
                  preferredSize: const Size(double.maxFinite, 70),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: Stack(
                      children: [
                        Edit26(
                          // hint: strings.get(24),
                          color: (darkMode) ? Colors.black : Colors.white,
                          style: theme.style14W400,
                          radius: 10,
                          useAlpha: false,
                          icon: Icons.search,
                          suffixIcon: Icons.cancel,
                          type: TextInputType.text,
                          controller: _controllerSearch,
                          focusNode: _searchFocus,
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
                        if (!_searchFocus.hasFocus)
                          Positioned(
                            top: 0,
                            left: 60,
                            bottom: 0,
                            child: Center(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Search for \'Plumber\'',
                                    textStyle: theme.style14W400,
                                    speed: const Duration(milliseconds: 400),
                                  ),
                                  TypewriterAnimatedText(
                                    'Search for \'Cleaning\'',
                                    textStyle: theme.style14W400,
                                    speed: const Duration(milliseconds: 200),
                                  ),
                                ],
                                repeatForever: true,
                                pause: const Duration(seconds: 1),
                                onTap: () {
                                  _searchFocus.requestFocus();
                                },
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              if (modal.busy || modal.city == null || modal.categories.isEmpty)
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
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: constraints.remainingPaintExtent,
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              Image.asset("assets/images/service-unavailable.jpg"),
                              const Center(
                                child: SizedBox(
                                  width: 320,
                                  child: Text(
                                    "Our Services are not available in this City yet. We will come here soon! Please try another location for now or connect with our customer care.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Montserrat"
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                )
              else
                SliverList(
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
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width * 0.45,
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
                              padding: const EdgeInsets.all(14),
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
                                            serviceId: hb.serviceId, categoryId: hb.categoryId),
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
                            if (modal.offerBanners.isNotEmpty) _buildPromoBanner(modal),
                            // UIHelper.verticalSpaceMedium,
                            // Container(
                            //   color: primaryColor.shade50,
                            //   padding: const EdgeInsets.all(14),
                            //   child: _trendingCategories(),
                            // ),

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
                                          categoryId: hb.categoryId,
                                        ),
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
                              color: Colors.blue.shade50,
                              padding: const EdgeInsets.all(14),
                              child: _buildSectionView(),
                            ),
                            UIHelper.verticalSpaceMedium,
                            if (modal.workBanners.isNotEmpty) UIHelper.verticalSpaceMedium,
                            if (modal.workBanners.isNotEmpty)
                              Center(
                                child: PromoBanner(
                                  modal.workBanners,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width * 0.45,
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
                                            serviceId: hb.serviceId, categoryId: hb.categoryId),
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
                _searchFocus.unfocus();
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
                  Flexible(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          height: 1.4),
                    ),
                  ),
                  UIHelper.horizontalSpaceMedium,
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
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

  Widget _buildPromoBanner(HomeViewModal model) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        viewportFraction: 0.84,
        enlargeCenterPage: true,
        height: 180,
      ),
      items: [
        ...model.offerBanners.map(
          (data) {
            return InkWell(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailsView(
                      categoryId: data.categoryId,
                      serviceId: data.serviceId,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: CachedNetworkImage(
                  placeholder: (context, url) => UnconstrainedBox(
                      child: Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    child: const CircularProgressIndicator(),
                  )),
                  imageUrl: data.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  // Widget _trendingCategories() {
  //   final modal = context.read<HomeViewModal>();
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       return ListView.builder(
  //         itemCount: modal.trendingCategories.length,
  //         physics: const NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         itemBuilder: (context, index) {
  //           final cate = modal.trendingCategories[index];
  //           return Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           cate.name,
  //                           style: const TextStyle(
  //                             fontSize: 16,
  //                             fontFamily: "Montserrat",
  //                             height: 1.4,
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         ),
  //                         if (cate.description.isNotEmpty) const SizedBox(height: 6),
  //                         if (cate.description.isNotEmpty)
  //                           Text(
  //                             cate.description,
  //                             style: const TextStyle(
  //                               color: Colors.grey,
  //                               fontSize: 13,
  //                               fontWeight: FontWeight.w400,
  //                             ),
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                       ],
  //                     ),
  //                   ),
  //                   UIHelper.horizontalSpaceSmall,
  //                   // button134(
  //                   //   strings.get(26),
  //                   //   () {
  //                   //     // modal.selectedCategory = cate.name;
  //                   //     // Navigation.instance.navigate("/sub-category", args: cate);
  //                   //   },
  //                   //   true,
  //                   //   theme.style14W800MainColor,
  //                   // )
  //                 ],
  //               ),
  //               UIHelper.horizontalSpaceSmall,
  //               const Divider(),
  //               UIHelper.horizontalSpaceSmall,
  //               SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 child: Wrap(
  //                   spacing: 12,
  //                   runSpacing: 12,
  //                   // crossAxisAlignment: WrapCrossAlignment.start,
  //                   alignment: WrapAlignment.start,
  //                   children: cate.subCategories.map((data) {
  //                     final width = (constraints.maxWidth / 3) - 8;
  //                     return InkWell(
  //                       onTap: () {
  //                         modal.selectedSubCategory = data.name;
  //                         Navigation.instance.navigate("/sub-category", args: data);
  //                       },
  //                       child: SizedBox(
  //                         width: width,
  //                         child: Column(
  //                           children: [
  //                             ClipRRect(
  //                               borderRadius: BorderRadius.circular(5),
  //                               child: Container(
  //                                 decoration: const BoxDecoration(
  //                                   color: highlightColor,
  //                                   borderRadius: BorderRadius.all(
  //                                     Radius.circular(4),
  //                                   ),
  //                                 ),
  //                                 width: width,
  //                                 height: 90,
  //                                 child: CustomNetworkImage(
  //                                   url: data.imageUrl,
  //                                   fit: BoxFit.fitHeight,
  //                                   height: 240,
  //                                 ),
  //                               ),
  //                             ),
  //                             UIHelper.verticalSpaceSmall,
  //                             Text(
  //                               data.name,
  //                               style: const TextStyle(
  //                                 fontFamily: "Montserrat",
  //                                 letterSpacing: 0.4,
  //                                 fontSize: 11,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: Colors.black,
  //                               ),
  //                               textAlign: TextAlign.center,
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   }).toList(),
  //                 ),
  //               ),
  //               UIHelper.verticalSpaceMedium,
  //               UIHelper.verticalSpaceSmall,
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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
                        return InkWell(
                          onTap: () {

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
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        viewportFraction: 1.0,
        height: 270,
      ),
      items: [
        ...model.testimonials.map(
          (data) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
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
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                            color: primaryColor.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      UIHelper.horizontalSpaceSmall,
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: primaryColor.shade900,
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            "${data.rating}",
                            style: TextStyle(
                              color: primaryColor.shade600,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  UIHelper.verticalSpaceMedium,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "“",
                          style: TextStyle(
                              fontSize: 26,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              color: primaryColor.shade900,
                              height: 0.4),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              data.description,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                color: primaryColor.shade800,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "„",
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              color: primaryColor.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        color: primaryColor.shade900,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: primaryColor.shade900,
                          fontFamily: "Montserrat",
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }

  void showMessageViewDialog(List<MessageModel> list) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Messages",
              style: TextStyle(
                fontFamily: "Montserrat",
              ),
            ),
          ),
          body: list.isEmpty
              ? const Center(
                  child: Text(
                    "No new Messages",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(14),
                  children: [
                    ...list.map((data) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              onTap: () {
                                loadingDialog(context);
                                final res = context
                                    .read<BookingViewModel>()
                                    .fetchBookingDetailsById(data.bookingId, fetchService: false);
                                res.then((value) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatRoomView(data: value.data),
                                  ));
                                });
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.messageBy,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Text(
                                    data.message,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
