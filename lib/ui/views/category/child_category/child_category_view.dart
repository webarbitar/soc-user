import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/constance/end_points.dart';
import 'package:socspl/core/modal/category/add_on_modal.dart';
import 'package:socspl/core/modal/section/section_modal.dart';
import 'package:socspl/ui/views/service/service_view.dart';

import '../../../../core/constance/strings.dart';
import '../../../../core/constance/style.dart';
import '../../../../core/modal/category/child_category_modal.dart';
import '../../../../core/view_modal/home/home_view_modal.dart';
import '../../../shared/messenger/util.dart';
import '../../../shared/ui_helpers.dart';
import '../../../widgets/buttons/button134.dart';
import '../../../widgets/buttons/button2.dart';
import '../../../widgets/buttons/button202z.dart';
import '../../../widgets/edit26.dart';
import '../../../widgets/loader/loader_widget.dart';

class ChildCategoryView extends StatefulWidget {
  final int? categoryId;
  final int? subCategoryId;
  final String searchKey;

  const ChildCategoryView({Key? key, this.categoryId, this.subCategoryId, this.searchKey = ""})
      : super(key: key);

  @override
  State<ChildCategoryView> createState() => _ChildCategoryViewState();
}

class _ChildCategoryViewState extends State<ChildCategoryView> {
  final _searchCtrl = TextEditingController();
  final _totalNfy = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    context.read<HomeViewModal>().fetchChildCategoryModal(
          "${widget.categoryId ?? ""}",
          "${widget.subCategoryId ?? ""}",
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
          context.read<HomeViewModal>().selectedSubCategory,
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
        // modal.busy =false;
        if (modal.busy) {
          return const Center(
            child: LoaderWidget(),
          );
        }
        // To prevent unnecessary reinitialisation on rebuild
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
                onSubmit: (val) {
                  modal.fetchChildCategoryModal(
                    "${widget.categoryId ?? ""}",
                    "${widget.subCategoryId ?? ""}",
                    search: val.trim(),
                  );
                },
              ),
              UIHelper.verticalSpaceMedium,
              LayoutBuilder(
                builder: (context, constraints) {
                  if (modal.childCategories.isEmpty) {
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
                    children: modal.childCategories.map((data) {
                      final width = (constraints.maxWidth / 3) - 8;
                      return InkWell(
                        onTap: () {
                          // titleForServiceList = getTextByLocale(data.name);
                          // widget.callback("services");
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => ServiceView(
                          //       categoryId: widget.categoryId,
                          //       subCategoryId: widget.subCategoryId,
                          //       childCategoryId: data.id,
                          //     ),
                          //   ),
                          // );
                          //
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ServiceView(
                                categoryId: widget.categoryId,
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
}
