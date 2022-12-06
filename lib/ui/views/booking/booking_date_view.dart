import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/service/service_booking.dart';
import 'package:socspl/core/modal/time_slot_model.dart';
import 'package:socspl/core/utils/string_extension.dart';
import 'package:socspl/core/view_modal/booking/booking_view_model.dart';
import 'package:socspl/core/view_modal/cart/cart_view_model.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/views/booking/booking_success_view.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../widgets/custom/custom_button.dart';
import '../home/component/home_booking_view.dart';
import 'payment_method_view.dart';

class BookingDateView extends StatefulWidget {
  const BookingDateView({Key? key}) : super(key: key);

  @override
  State<BookingDateView> createState() => _BookingDateViewState();
}

class _BookingDateViewState extends State<BookingDateView> {
  final _monthFormat = DateFormat("MMM");
  final _dateFormat = DateFormat("yyyy/MM/dd");
  final _timeFormat = DateFormat("hh:mm");
  final List<DateTime> days = [];
  late DateTime _currentFilter;
  TimeSlotModel? _selectedTime;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    final model = context.read<BookingViewModel>();
    model.fetchTimeSlots(context.read<CartViewModel>().currentCart!.categoryId);

    now.subtract(const Duration(days: 7));
    buildDays(startDate: now, endDate: now.add(const Duration(days: 30)));
  }

  void buildDays({required DateTime startDate, required DateTime endDate}) {
    final now = DateTime.parse(DateTime.now().toString().split(" ")[0]);
    var date = startDate;
    while (date.difference(endDate).inDays <= 0) {
      days.add(DateTime.parse(date.toString().split(" ")[0]));
      date = date.add(const Duration(days: 1));
    }
    _currentFilter = now;
    // days.add(now);
  }

  @override
  Widget build(BuildContext context) {
    print(now.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
        elevation: 0.2,
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpaceMedium,
                      const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          "Select date of service",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat",
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(14),
                        child: Wrap(
                          spacing: 14,
                          children: [
                            ...days.map(
                              (e) {
                                bool isActive = _currentFilter.compareTo(e) == 0;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _currentFilter = e;
                                    });
                                  },
                                  child: Material(
                                    color: isActive ? primaryColor.shade100 : Colors.white,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(
                                        color: isActive ? primaryColor : Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Container(
                                      width: 60,
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        children: [
                                          Text(
                                            _monthFormat.format(e),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: isActive ? Colors.black87 : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "${e.day}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: isActive ? Colors.black87 : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      UIHelper.verticalSpaceMedium,
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Select start time of service",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            UIHelper.verticalSpaceMedium,
                            Consumer<BookingViewModel>(builder: (context, model, _) {
                              double width = (constraints.maxWidth / 3) - 22;
                              final filterTimeSlot = model.timerSlots.where((e) {
                                if (_currentFilter
                                        .compareTo(DateTime(now.year, now.month, now.day)) ==
                                    0) {
                                  if (e.timeSlot.isBefore(now.add(const Duration(hours: 1)))) {
                                    return false;
                                  }
                                }
                                return true;
                              });
                              if (filterTimeSlot.isEmpty) {
                                return SizedBox(
                                  height: constraints.maxHeight / 2,
                                  child: const Center(
                                    child: Text(
                                      "Service Time not available for today",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Wrap(
                                spacing: 14,
                                runSpacing: 14,
                                children: [
                                  ...filterTimeSlot.map((e) {
                                    bool isActive = _selectedTime == e;
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedTime = e;
                                        });
                                      },
                                      child: Material(
                                        color: isActive ? primaryColor.shade100 : Colors.white,
                                        elevation: 1.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          side: BorderSide(
                                              color:
                                                  isActive ? primaryColor : Colors.grey.shade200),
                                        ),
                                        child: Container(
                                          width: width,
                                          padding: const EdgeInsets.all(14),
                                          child: Center(
                                            child: Text(
                                              _timeFormat.format(e.timeSlot),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Montserrat",
                                                  color: isActive ? Colors.black87 : Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              );
                            }),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
            child: CustomButton(
              text: "Proceed to checkout",
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Montserrat",
                fontSize: 14,
                color: Colors.white,
              ),
              onTap: () {
                if (_selectedTime != null) {
                  showBottomPaymentModel();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select the operation time"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void showBottomPaymentModel() {
    final model = context.read<BookingViewModel>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.home),
                  UIHelper.horizontalSpaceSmall,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.userAddress!.type.capitalize(),
                        style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${model.userAddress!.name} - ${model.userAddress!.mobile}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Montserrat",
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        model.userAddress!.formattedAddress,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Montserrat",
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 4),
              const Divider(thickness: 2, color: highlightColor),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.timer_sharp),
                  UIHelper.horizontalSpaceSmall,
                  Text(
                    "${_currentFilter.toString().split(" ")[0]} ${_timeFormat.format(_selectedTime!.timeSlot)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(thickness: 2, color: highlightColor),
              UIHelper.verticalSpaceMedium,
              CustomButton(
                text: "Continue To Payment",
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentMethodView(
                        onSelected: (val) {
                          final dateFormat = DateFormat("yyyy-MM-dd");
                          final model = context.read<BookingViewModel>();
                          busyDialog();
                          final res = model.bookService(
                            ServiceBooking(
                              address: model.userAddress!,
                              date: dateFormat.format(_currentFilter),
                              time: _timeFormat.format(_selectedTime!.timeSlot),
                              paymentMethod: val,
                              cart: context.read<CartViewModel>().currentCart!,
                            ),
                          );
                          res.then((value) {
                            context.read<CartViewModel>().clearCartData();
                            Navigator.of(context).pop();
                            if (value.status == ApiStatus.success) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BookingSuccessView(
                                    id: value.data!.id,
                                    bookingId: value.data!.bookingId,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(value.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              UIHelper.verticalSpaceMedium,
              const Text(
                "By proceeding you agree to our T&C, Privacy and Cancellation policy",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void busyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const LoaderWidget();
      },
    );
  }
}
