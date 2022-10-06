import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

class RateCardView extends StatefulWidget {
  final int childCategoryId;

  const RateCardView({Key? key, required this.childCategoryId}) : super(key: key);

  @override
  State<RateCardView> createState() => _RateCardViewState();
}

class _RateCardViewState extends State<RateCardView> {
  final _busyNfy = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _busyNfy.value = true;
    final model = context.read<HomeViewModal>();
    final res = model.fetchRateCard(widget.childCategoryId);
    res.then((value) {
      _busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Card"),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: ValueListenableBuilder(
          valueListenable: _busyNfy,
          builder: (context, bool busy, _) {
            if (busy) {
              return const Center(
                child: LoaderWidget(),
              );
            }
            final model = context.read<HomeViewModal>();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  ...model.rateCards.map((data) {
                    return Column(
                      children: [
                        UIHelper.verticalSpaceMedium,
                        Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ),
                              VerticalDivider(thickness: 2),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Service Charge",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Html(
                                    data: data.description,
                                    style: {
                                      "body": Style(
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.zero,
                                      )
                                    },
                                  )),
                              const VerticalDivider(thickness: 2),
                               Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    "₹ ${data.price}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            );
          }),
    );
  }
}
