import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/service/category_service_modal.dart';
import 'package:socspl/core/utils/invoice/booking_invoice_util.dart';
import 'package:socspl/core/utils/storage/storage.dart';
import 'package:socspl/core/utils/string_extension.dart';
import 'package:socspl/core/view_modal/booking/booking_view_model.dart';
import 'package:socspl/ui/shared/validator_mixin.dart';
import 'package:socspl/ui/views/chat_room_view.dart';
import 'package:socspl/ui/views/home/component/home_booking_view.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constance/style.dart';
import '../../shared/ui_helpers.dart';
import '../../widgets/custom/custom_button.dart';

class BookingDetailsView extends StatefulWidget {
  final int id;

  const BookingDetailsView({Key? key, required this.id}) : super(key: key);

  @override
  State<BookingDetailsView> createState() => _BookingDetailsViewState();
}

class _BookingDetailsViewState extends State<BookingDetailsView> {
  final _busyNfy = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _busyNfy.value = true;
    final model = context.read<BookingViewModel>();
    final res = model.fetchBookingDetailsById(widget.id);
    res.then(
      (value) async {
        if (value.status == ApiStatus.success) {}
        _busyNfy.value = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(Storage.instance.token);
    final model = context.watch<BookingViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          ValueListenableBuilder(
            valueListenable: _busyNfy,
            builder: (context, bool busy, _) {
              if (!busy && model.bookingDetails?.status == "completed") {
                return TextButton.icon(
                  onPressed: () async {
                    loadingDialog(context);
                    final invoiceServ = BookingInvoiceUtil(
                        bookingDetails: model.bookingDetails!,
                        bookedServices: model.bookedServices);
                    final file = await invoiceServ.generate();
                    await OpenFile.open(file.path);
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.description),
                  label: const Text(
                    "Invoice",
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: ValueListenableBuilder(
          valueListenable: _busyNfy,
          builder: (context, bool busy, _) {
            if (busy) {
              return const Center(
                child: LoaderWidget(),
              );
            }
            if (model.bookingDetails == null) {
              return const Center(
                child: Text("Something went wrong please try again later."),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (model.bookingDetails?.serviceProvider != null)
                          _buildProviderInfo(model),
                        UIHelper.verticalSpaceMedium,
                        const Text(
                          "Booked Services",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        UIHelper.verticalSpaceSmall,
                        ...model.services.map((data) {
                          return _buildServiceCard(data, model);
                        }),
                        if (model.bookingDetails!.spares.isNotEmpty) UIHelper.verticalSpaceMedium,
                        if (model.bookingDetails!.spares.isNotEmpty)
                          const Text(
                            "Additional Spare Parts",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        UIHelper.verticalSpaceMedium,
                        const Text(
                          "Service Address",
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
                              Text(
                                "${model.bookingDetails?.address.type.capitalize()}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Divider(),
                              Text(
                                "${model.bookingDetails?.address.name}-${model.bookingDetails?.address.mobile}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${model.bookingDetails?.address.formattedAddress}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              Text(
                                "${model.bookingDetails?.address.address}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpaceMedium,
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
                                  Text(
                                    "Order Services x${model.bookingDetails?.services.map((e) => e.quantity).reduce((value, element) => value + element)}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Text(
                                    "₹ ${model.bookingDetails?.services.map((e) => e.total).reduce((value, element) => value + element)}",
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
                                children: [
                                  Text(
                                    "Additional Services x${model.bookingDetails?.services.map((e) => e.addonQuantity).reduce((value, element) => value + element)}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Text(
                                    "₹ ${model.bookingDetails?.services.map((e) => e.addonTotalPrice).reduce((value, element) => value + element)}",
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Additional Spare Parts x ${model.bookingDetails?.totalSparePartsQuantity}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Text(
                                    "₹ ${model.bookingDetails?.totalSparePartsPrice}",
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
                                    "₹ ${model.bookingDetails?.amount}",
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
                ),
                if ((model.bookingDetails!.status == "pending" ||
                        model.bookingDetails!.status == "confirmed") &&
                    model.bookingDetails!.jobStartTime == null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Cancel Booking",
                      onTap: () {
                        loadingDialog(context);
                        final res = model.cancelBooking(model.bookingDetails!.id);
                        res.then((value) {
                          if (value.status == ApiStatus.success) {
                            showSuccessMessage(value.message);
                            Navigator.of(context).pop(true);
                          } else {
                            showErrorMessage(value.message);
                          }
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ),
              ],
            );
          }),
    );
  }

  Widget _buildProviderInfo(BookingViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Service Provider",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        imageUrl: model.bookingDetails?.serviceProvider?.imageUrl ?? "",
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpaceSmall,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${model.bookingDetails?.serviceProvider?.name}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat",
                          ),
                        ),
                        Text(
                          "${model.bookingDetails?.serviceProvider?.role.split("_").join(" ").capitalize()}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (model.bookingDetails?.serviceProvider?.verifiedByVendor == 1)
                          Row(
                            children: const [
                              Icon(
                                Icons.verified_outlined,
                                size: 16,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                "Verified",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        UIHelper.verticalSpaceSmall,
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  UIHelper.horizontalSpaceMedium,
                  if (model.bookingDetails!.status != "completed" &&
                      model.bookingDetails!.status != "cancelled")
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            launch("tel:+91${model.bookingDetails!.serviceProvider?.mobile}");
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatRoomView(
                                  data: model.bookingDetails,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: const Icon(
                              Icons.wechat,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
              if (model.bookingDetails!.status != "completed" &&
                  model.bookingDetails!.status != "cancelled")
                UIHelper.verticalSpaceMedium,
              if (model.bookingDetails!.status != "completed" &&
                  model.bookingDetails!.status != "cancelled")
                Row(
                  children: [
                    const Text(
                      "Booking OTP",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall,
                    Container(
                      width: 110,
                      height: 35,
                      decoration: const BoxDecoration(color: highlightColor),
                      child: Center(
                        child: Text(
                          "${model.bookingDetails?.estimatedBillStatus == "pending" ? model.bookingDetails?.otp : model.bookingDetails!.completeOtp ?? ""}",
                          style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(CategoryServiceModal data, BookingViewModel model) {
    var bkServ =
        model.bookingDetails!.services.singleWhere((element) => element.serviceId == data.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 60,
                  width: 90,
                  child: CachedNetworkImage(
                    imageUrl: data.imageUrl,
                    height: 60,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              UIHelper.horizontalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(fontFamily: "Montserrat"),
                    ),
                    UIHelper.verticalSpaceSmall,
                    if (bkServ.addonService.isNotEmpty)
                      ...bkServ.addonService.map((el) {
                        return Row(
                          children: [
                            const Icon(Icons.circle, size: 6, color: Colors.grey),
                            UIHelper.horizontalSpaceSmall,
                            Text(
                              "${el.addOn.name} x${el.quantity} ",
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                  height: 1.6),
                            ),
                          ],
                        );
                      }),
                    if (bkServ.rateCards.isNotEmpty)
                      ...bkServ.rateCards.map((el) {
                        return Row(
                          children: [
                            const Icon(Icons.circle, size: 6, color: Colors.grey),
                            UIHelper.horizontalSpaceSmall,
                            Text(
                              "${el.rateCard.name} x${el.quantity} ",
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                  height: 1.6),
                            ),
                          ],
                        );
                      })
                  ],
                ),
              ),
              UIHelper.horizontalSpaceMedium,
              Text(
                "x ${bkServ.quantity}",
                style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: "Montserrat"),
              ),
            ],
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Text(
          //     timeago.format(data.createdAt),
          //     style: const TextStyle(
          //       fontFamily: "Montserrat",
          //       fontSize: 13,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
