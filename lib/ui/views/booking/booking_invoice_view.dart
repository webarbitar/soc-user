import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/ui/views/booking/review_provider_view.dart';

import '../../../core/constance/style.dart';
import '../../shared/ui_helpers.dart';
import '../../shared/validator_mixin.dart';
import '../home/component/home_booking_view.dart';
import '../../widgets/custom/custom_button.dart';
import '../../../core/enum/api_status.dart';
import '../../../core/view_modal/booking/booking_view_model.dart';

class BookingInvoiceView extends StatefulWidget {
  final bool isEstimate;

  const BookingInvoiceView({super.key, this.isEstimate = true});

  @override
  State<BookingInvoiceView> createState() => _BookingInvoiceViewState();
}

class _BookingInvoiceViewState extends State<BookingInvoiceView> {
  int userAdvance = 0;

  @override
  Widget build(BuildContext context) {
    final model = context.read<BookingViewModel>();
    userAdvance = model.bookingDetails!.advancePayment;
    int total = 0;
    int est = model.bookingDetails!.services
        .map((e) => e.total + e.addonTotalPrice)
        .reduce((value, element) => value + element);
    total = est;
    if (model.bookingDetails!.spares.isNotEmpty) {
      int totalAmount = model.bookingDetails!.spares
          .map((e) => e.total)
          .reduce((value, element) => value + element);
      est += totalAmount;
      total += totalAmount;
    }
    return Scaffold(
      appBar: AppBar(elevation: 0.0),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Job Summary",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (model.bookingDetails!.services.isNotEmpty)
                    ...model.bookingDetails!.services.map((bk) {
                      var data =
                      model.bookedServices.singleWhere((element) => element.id == bk.serviceId);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UIHelper.verticalSpaceSmall,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                    UIHelper.horizontalSpaceMedium,
                                  ],
                                ),
                                UIHelper.verticalSpaceMedium,
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "Service Charge",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "x ${bk.quantity}",
                                      style: const TextStyle(fontFamily: "Montserrat"),
                                    ),
                                    const Expanded(child: UIHelper.horizontalSpaceMedium),
                                    Text(
                                      "₹ ${bk.price}",
                                      style: const TextStyle(fontFamily: "Montserrat"),
                                    ),
                                  ],
                                ),
                                // UIHelper.verticalSpaceSmall,
                                const Divider(),
                                UIHelper.verticalSpaceSmall,
                                ...bk.addonService.map((ad) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${ad.addOn.name} x ${ad.quantity}",
                                            style: const TextStyle(fontFamily: "Montserrat"),
                                          ),
                                        ),
                                        Text(
                                          "₹ ${ad.total}",
                                          style: const TextStyle(fontFamily: "Montserrat"),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                                if (model.bookingDetails!.rateCards.isNotEmpty)
                                  ...model.bookingDetails!.rateCards.map((rt) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${rt.rateCard.name} x ${rt.quantity}",
                                              style: const TextStyle(fontFamily: "Montserrat"),
                                            ),
                                          ),
                                          Text(
                                            "₹ ${rt.amount}",
                                            style: const TextStyle(fontFamily: "Montserrat"),
                                          )
                                        ],
                                      ),
                                    );
                                  })
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  UIHelper.verticalSpaceSmall,
                  if (model.bookingDetails!.spares.isNotEmpty)
                    ...model.bookingDetails!.spares.map((data) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UIHelper.verticalSpaceSmall,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                    UIHelper.horizontalSpaceMedium,
                                  ],
                                ),
                                UIHelper.verticalSpaceMedium,
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "Spare Parts Price",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "₹ ${data.total}",
                                      style: const TextStyle(fontFamily: "Montserrat"),
                                    )
                                  ],
                                ),
                                UIHelper.verticalSpaceSmall,
                                // Row(
                                //   children: [
                                //     const Expanded(
                                //       child: Text(
                                //         "Spare Parts Amount Paid by User",
                                //         style: TextStyle(
                                //           fontSize: 13,
                                //           fontWeight: FontWeight.w500,
                                //           fontFamily: "Montserrat",
                                //         ),
                                //       ),
                                //     ),
                                //     Text(
                                //       "- ₹ ${data.amount}",
                                //       style: const TextStyle(fontFamily: "Montserrat"),
                                //     )
                                //   ],
                                // ),
                                // UIHelper.verticalSpaceSmall,
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  UIHelper.verticalSpaceSmall,
                  const Text(
                    "Order Summary",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  UIHelper.verticalSpaceSmall,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Estimate (Approx.)",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            UIHelper.verticalSpaceSmall,
                            Text(
                              "₹ $est",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            const Text(
                              "User Paid",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            UIHelper.verticalSpaceSmall,
                            Text(
                              "- ₹ $userAdvance",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                        const Divider(),
                        UIHelper.verticalSpaceSmall,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            UIHelper.verticalSpaceSmall,
                            Text(
                              "₹ ${total - userAdvance}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            UIHelper.horizontalSpaceMedium,
            if (widget.isEstimate)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      child: CustomButton(
                        text: "Reject Estimate",
                        color: Colors.red,
                        onTap: () {
                          loadingDialog(context);
                          final res = model.rejectEstimateBill();
                          res.then((value) {
                            Navigator.of(context).pop();
                            if (value.status == ApiStatus.success) {
                              Navigator.of(context).pop();
                              showSuccessMessage(value.message);
                            } else {
                              showErrorMessage(value.message);
                            }
                          });
                        },
                      ),
                    ),
                    UIHelper.horizontalSpaceMedium,
                    Flexible(
                      child: CustomButton(
                        text: "Accept Estimate",
                        color: Colors.green,
                        onTap: () {
                          loadingDialog(context);
                          final res = model.acceptEstimateBill();
                          res.then((value) {
                            Navigator.of(context).pop();
                            if (value.status == ApiStatus.success) {
                              Navigator.of(context).pop();
                              showSuccessMessage(value.message);
                            } else {
                              showErrorMessage(value.message);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              if (model.bookingDetails!.completeOtpVerified == 1 &&
                  model.bookingDetails!.paymentStatus == "pending")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "Pay Bill",
                    onTap: _buildPaymentMethodModel,
                  ),
                )
          ],
        ),
      ),
    );
  }

  void _buildPaymentMethodModel() {
    final model = context.read<BookingViewModel>();
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Payment Method",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Montserrat",
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    loadingDialog(context);
                    final res = model.payByCash();
                    res.then((value) {
                      Navigator.of(context).pop();
                      if (value.status == ApiStatus.success) {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ReviewProviderView(),
                          ),
                        );
                        showSuccessMessage(value.message);
                      } else {
                        showErrorMessage(value.message);
                      }
                    });
                  },
                  title: const Text(
                    "Cash on Service",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                const Divider(height: 2, thickness: 2),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    final model = context.read<BookingViewModel>();
                    Navigator.of(ctx).pop();
                    loadingDialog(context);
                    final res = model.initPaytmPayment();
                    res.then((value) {
                      if (value.status == ApiStatus.error) {
                        showErrorMessage(value.message);
                      }
                    });
                  },
                  title: const Text(
                    "Paytm",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
