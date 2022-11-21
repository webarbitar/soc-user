import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/modal/booking/review_model.dart';
import 'package:socspl/core/view_modal/booking/booking_view_model.dart';

import '../../../core/constance/style.dart';
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
          elevation: 0.0,
          title: const Text("How was your service?"),
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
                    UIHelper.verticalSpaceMedium,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UIHelper.verticalSpaceMedium,
                        const Center(
                          child: Text(
                            "Rate Provider Service",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: "Montserrat"),
                          ),
                        ),
                        UIHelper.verticalSpaceMedium,
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          glow: false,
                          itemSize: 45,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              rate = rating.toInt();
                            });
                          },
                        ),
                        UIHelper.verticalSpaceMedium,
                        _buildRatingIndicator(),
                        UIHelper.verticalSpaceMedium,
                        UIHelper.verticalSpaceMedium,
                        UIHelper.verticalSpaceSmall,
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: primaryColor),
                            color: primaryColor.shade50,
                          ),
                          child: TextField(
                            controller: _review,
                            minLines: 4,
                            maxLines: 8,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: "Write some notes on service",
                            ),
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceMedium,
                    CustomButton(
                      text: "Submit",
                      onTap: () async {
                        final model = context.read<BookingViewModel>();
                        loadingDialog(context);
                        await model.reviewProviderService(ReviewModel(
                          bookingId: model.bookingDetails!.id,
                          serviceProviderId: model.bookingDetails!.serviceProviderId!,
                          rating: rate,
                          review: _review.text.trim(),
                        ));
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

  _buildRatingIndicator() {
    const style = TextStyle(
      fontSize: 15,
      fontFamily: "Montserrat",
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    );
    switch (rate) {
      case 1:
        return const Text(
          "Terrible",
          style: style,
        );

      case 2:
        return const Text(
          "Bad",
          style: style,
        );

      case 3:
        return const Text(
          "Okay",
          style: style,
        );
      case 4:
        return const Text(
          "Good",
          style: style,
        );
      case 5:
        return const Text(
          "Great",
          style: style,
        );
      default:
        return const SizedBox();
    }
  }
}
