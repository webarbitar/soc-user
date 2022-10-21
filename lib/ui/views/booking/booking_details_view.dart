import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/booking/booked_service_details_model.dart';
import 'package:socspl/core/modal/service/category_service_modal.dart';
import 'package:socspl/core/utils/string_extension.dart';
import 'package:socspl/core/view_modal/booking/booking_view_model.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constance/style.dart';
import '../../../core/modal/category/add_on_modal.dart';
import '../../shared/ui_helpers.dart';

class BookingDetailsView extends StatefulWidget {
  final int id;

  const BookingDetailsView({Key? key, required this.id}) : super(key: key);

  @override
  State<BookingDetailsView> createState() => _BookingDetailsViewState();
}

class _BookingDetailsViewState extends State<BookingDetailsView> {
  final _busyNfy = ValueNotifier(false);

  BookedServiceDetailsModel? details;

  List<CategoryServiceModal> services = [];

  @override
  void initState() {
    super.initState();
    _busyNfy.value = true;
    final model = context.read<BookingViewModel>();
    final res = model.fetchBookingDetailsById(widget.id);
    res.then(
      (value) async {
        if (value.status == ApiStatus.success) {
          details = value.data;
          for (var element in details!.services) {
            await fetchServices(element);
          }
        }
        _busyNfy.value = false;
      },
    );
  }

  Future<void> fetchServices(BookedService serv) async {
    print(serv.serviceId);
    final model = context.read<HomeViewModal>();
    final res = await model.fetchServicesById("${serv.serviceId}", cityId: "${details?.city.id}");
    if (res.status == ApiStatus.success) {
      services.add(res.data!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
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
            if (details == null) {
              return const Center(
                child: Text("Something went wrong please try again later."),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (details?.serviceProvider != null)
                    Column(
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
                          child: Row(
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
                                    imageUrl: details?.serviceProvider?.imageUrl ?? "",
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
                                      "${details?.serviceProvider?.name}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    Text(
                                      "${details?.serviceProvider?.role.split("_").join(" ").capitalize()}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    if (details?.serviceProvider?.verifiedByVendor == 1)
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
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      launch("tel:+91${details!.serviceProvider?.mobile}");
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
                                  Container(
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
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
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
                  ...services.map((data) {
                    return _buildServiceCard(data);
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
                          "${details?.address.type.capitalize()}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat",
                          ),
                        ),
                        UIHelper.verticalSpaceSmall,
                        Text(
                          "${details?.address.name}-${details?.address.mobile}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat",
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "${details?.address.formattedAddress}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat",
                          ),
                        ),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
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
                              "Order Services x${details?.services.map((e) => e.quantity).reduce((value, element) => value + element)}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            UIHelper.verticalSpaceSmall,
                            Text(
                              "₹ ${details?.services.map((e) => e.total).reduce((value, element) => value + element)}",
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
                              "Additional Services x${details?.services.map((e) => e.addonQuantity).reduce((value, element) => value + element)}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            UIHelper.verticalSpaceSmall,
                            Text(
                              "₹ ${details?.services.map((e) => e.addonTotalPrice).reduce((value, element) => value + element)}",
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
                              "₹ ${details?.amount}",
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
            );
          }),
    );
  }

  Widget _buildServiceCard(CategoryServiceModal data) {
    var bkServ = details!.services.singleWhere((element) => element.serviceId == data.id);

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
