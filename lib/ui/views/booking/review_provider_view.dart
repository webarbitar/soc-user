import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../shared/navigation/navigation.dart';
import '../../shared/ui_helpers.dart';
import '../../widgets/custom/custom_button.dart';
import '../home/component/home_booking_view.dart';


class ReviewProviderView extends StatefulWidget {
  const ReviewProviderView({Key? key}) : super(key: key);

  @override
  State<ReviewProviderView> createState() => _ReviewProviderViewState();
}

class _ReviewProviderViewState extends State<ReviewProviderView> {
  final _busyNfy = ValueNotifier(false);
  final _review = TextEditingController();
  int rate = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text("Review Provider"),
        ),
        body: ValueListenableBuilder(
            valueListenable: _busyNfy,
            builder: (context, bool busy, _) {
              if (busy) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Column(
                      children: [
                        UIHelper.verticalSpaceMedium,
                        Card(
                          child: Column(
                            children: [
                              UIHelper.verticalSpaceMedium,
                              const Center(
                                child: Text(
                                  "Rate Provider Service",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              UIHelper.verticalSpaceMedium,
                              RatingBar.builder(
                                initialRating: 0,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                glow: false,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                  setState(() {
                                    rate = rating.toInt();
                                  });
                                },
                              ),
                              UIHelper.verticalSpaceMedium,
                              UIHelper.verticalSpaceMedium,
                              Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(
                                      color: Colors.grey,
                                    )),
                                child: TextField(
                                  controller: _review,
                                  minLines: 4,
                                  maxLines: 8,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none, hintText: "Write your review.."),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    UIHelper.verticalSpaceMedium,
                    CustomButton(
                      text: "Submit",
                      onTap: () async {
                        loadingDialog(context);
                        await Future.delayed(const Duration(seconds: 2));
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        Navigation.instance.navigateAndRemoveUntil("/home", args: 1);
                      },
                    ),
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              );
            }),
      ),
    );
  }
}
