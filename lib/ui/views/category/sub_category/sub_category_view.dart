import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/modal/category/category_banner_modal.dart';
import 'package:socspl/core/modal/category/category_modal.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/views/category/child_category/child_category_view.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constance/strings.dart';
import '../../../../core/constance/style.dart';
import '../../../widgets/edit26.dart';

class SubCategoryView extends StatefulWidget {
  final CategoryModal category;

  const SubCategoryView({Key? key, required this.category}) : super(key: key);

  @override
  State<SubCategoryView> createState() => _SubCategoryViewState();
}

class _SubCategoryViewState extends State<SubCategoryView> {
  final _searchCtrl = TextEditingController();
  VideoPlayerController? _videoCtrl;

  CategoryBannerModal? bannerModal;

  @override
  void initState() {
    super.initState();
    context.read<HomeViewModal>().fetchSubCategoryModal(widget.category.id);
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
        // To prevent unnecessary reinitialisation on rebuild
        if (bannerModal == null) {
          bannerModal = modal.categoryBanner;
          if (bannerModal?.type != "image") {
            _videoCtrl = VideoPlayerController.network(bannerModal!.link)
              ..initialize().then((_) {
                _videoCtrl?.setVolume(0);
                _videoCtrl?.play();
                _videoCtrl?.setLooping(true);
                setState(() {});
              });
          }
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Edit26(
                hint: strings.get(24),
                color: (darkMode) ? Colors.black : Colors.white,
                style: theme.style14W400,
                radius: 10,
                useAlpha: false,
                icon: Icons.search,
                controller: _searchCtrl,
                suffixIcon: Icons.cancel,
                onSuffixIconPress: () {
                  modal.fetchSubCategoryModal(widget.category.id, search: _searchCtrl.text.trim());
                },
              ),
              UIHelper.verticalSpaceMedium,
              if (_videoCtrl != null)
                _videoCtrl!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: _videoCtrl!.value.aspectRatio,
                          child: VideoPlayer(_videoCtrl!),
                        ),
                      )
                    : Container()
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 210,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: bannerModal?.link ?? "",
                      ),
                    ),
                  ),
                ),
              UIHelper.verticalSpaceMedium,
              LayoutBuilder(
                builder: (context, constraints) {
                  if (widget.category.subcategories.isEmpty) {
                    return Center(
                      child: Text(
                        "No data found",
                        style: theme.style10W600Grey,
                      ),
                    );
                  }
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.category.subcategories.map((data) {
                      final width = (constraints.maxWidth / 3) - 8;
                      return InkWell(
                        onTap: () {
                          // titleForServiceList = getTextByLocale(data.name);
                          // widget.callback("services");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChildCategoryView(
                                categoryId: widget.category.id,
                                subCategoryId: data.id,
                              ),
                            ),
                          );
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
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, error) {
                                      return const Center(
                                        child: Text("No image"),
                                      );
                                    },
                                    imageUrl: data.imageUrl,
                                    fit: BoxFit.cover,
                                    height: 80,
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
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoCtrl?.dispose();
  }
}
