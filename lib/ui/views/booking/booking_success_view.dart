import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/response_modal.dart';
import 'package:socspl/core/view_modal/booking/booking_view_model.dart';
import 'package:socspl/ui/shared/navigation/navigation.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/shared/validator_mixin.dart';
import 'package:socspl/ui/widgets/custom/custom_button.dart';

import 'booking_details_view.dart';

class BookingSuccessView extends StatefulWidget {
  final int id;
  final String bookingId;

  const BookingSuccessView({
    Key? key,
    required this.bookingId,
    required this.id,
  }) : super(key: key);

  @override
  State<BookingSuccessView> createState() => _BookingSuccessViewState();
}

class _BookingSuccessViewState extends State<BookingSuccessView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    intiBookingDetailsFetcher();
  }

  void intiBookingDetailsFetcher() {
    bool pauseReq = false;
    final model = context.read<BookingViewModel>();
    ResponseModal res;
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (!pauseReq) {
        pauseReq = true;
        res = await model.fetchBookingDetailsById(widget.id, fetchService: false);
        if (res.status == ApiStatus.success) {
          if (model.bookingDetails!.status == "confirmed") {
            showSuccessMessage("Your request have been accepted");
            Navigation.instance.navigateAndRemoveUntil("/home", args: 2);
            if (!mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BookingDetailsView(id: widget.id),
              ),
            );
            _timer?.cancel();
          }
        }
        pauseReq = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/lottie/waiting.json",
                      width: 180,
                    ),
                    UIHelper.verticalSpaceMedium,
                    const Text(
                      "Waiting for provider approval",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    UIHelper.verticalSpaceMedium,
                    Text(
                      "Your booking with id ${widget.bookingId} has been placed successfully",
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    UIHelper.verticalSpaceLarge,
                  ],
                ),
              ),
              UIHelper.verticalSpaceMedium,
              CustomButton(
                text: "Go to Home",
                onTap: () {
                  Navigation.instance.navigateAndRemoveUntil("/home", args: 2);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
