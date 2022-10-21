import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:socspl/ui/shared/navigation/navigation.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/widgets/custom/custom_button.dart';

class BookingSuccessView extends StatelessWidget {
  final String bookingId;

  const BookingSuccessView({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
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
                    Lottie.asset("assets/lottie/book-now.json", width: 180, repeat: false),
                    UIHelper.verticalSpaceMedium,
                    Text(
                      "Your booking with id $bookingId has been successfully placed",
                      style: const TextStyle(
                        fontSize: 14,
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
                  Navigation.instance.navigateAndRemoveUntil("/home");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
