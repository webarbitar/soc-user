import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/booking/BookedServiceModel.dart';
import 'package:socspl/core/view_modal/booking/booking_view_model.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../../shared/ui_helpers.dart';

class HomeBookingView extends StatefulWidget {
  const HomeBookingView({Key? key}) : super(key: key);

  @override
  State<HomeBookingView> createState() => _HomeBookingViewState();
}

class _HomeBookingViewState extends State<HomeBookingView> {
  final _busyNfy = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _busyNfy.value = true;
    Future.delayed(const Duration(seconds: 2)).then((value) {
      _busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Booking"),
          backgroundColor: Colors.white,
          elevation: 0.2,
          bottom: const TabBar(
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 14,
            ),
            tabs: [
              Tab(
                child: Text("Pending"),
              ),
              Tab(
                child: Text("Confirmed"),
              ),
              Tab(
                child: Text("Completed"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PendingBookingWidget(),
            ConfirmedBookingWidget(),
            CompletedBookingWidget(),
          ],
        ),
      ),
    );
  }
}

class PendingBookingWidget extends StatefulWidget {
  const PendingBookingWidget({Key? key}) : super(key: key);

  @override
  State<PendingBookingWidget> createState() => _PendingBookingWidgetState();
}

class _PendingBookingWidgetState extends State<PendingBookingWidget> {
  final _busyNfy = ValueNotifier(false);
  List<BookedServiceModel> _bookedServices = [];

  @override
  void initState() {
    super.initState();
    final model = context.read<BookingViewModel>();
    _busyNfy.value = true;
    model.fetchPendingBooking().then((value) {
      if (value.status == ApiStatus.success) {
        _bookedServices = value.data!;
      }
      _busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _busyNfy,
      builder: (context, bool busy, _) {
        if (busy) {
          return const Center(
            child: LoaderWidget(),
          );
        }
        if (_bookedServices.isEmpty) {
          return const Center(
            child: Text(
              "No booking found. Please book services to view",
              style: TextStyle(fontSize: 14, fontFamily: "Montserrat"),
            ),
          );
        }
        return Column(
          children: [
            ..._bookedServices.map((data) {
              return BookedServiceCardWidget(data: data);
            })
          ],
        );
      },
    );
  }
}

class ConfirmedBookingWidget extends StatefulWidget {
  const ConfirmedBookingWidget({Key? key}) : super(key: key);

  @override
  State<ConfirmedBookingWidget> createState() => _ConfirmedBookingWidgetState();
}

class _ConfirmedBookingWidgetState extends State<ConfirmedBookingWidget> {
  final _busyNfy = ValueNotifier(false);
  List<BookedServiceModel> _bookedServices = [];

  @override
  void initState() {
    super.initState();
    final model = context.read<BookingViewModel>();
    _busyNfy.value = true;
    model.fetchConfirmBooking().then((value) {
      if (value.status == ApiStatus.success) {
        _bookedServices = value.data!;
      }
      _busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _busyNfy,
      builder: (context, bool busy, _) {
        if (busy) {
          return const Center(
            child: LoaderWidget(),
          );
        }
        if (_bookedServices.isEmpty) {
          return const Center(
            child: Text(
              "No booking found. Please book services to view",
              style: TextStyle(fontSize: 14, fontFamily: "Montserrat"),
            ),
          );
        }
        return Column(
          children: [
            ..._bookedServices.map((data) {
              return BookedServiceCardWidget(data: data);
            })
          ],
        );
      },
    );
  }
}

class CompletedBookingWidget extends StatefulWidget {
  const CompletedBookingWidget({Key? key}) : super(key: key);

  @override
  State<CompletedBookingWidget> createState() => _CompletedBookingWidgetState();
}

class _CompletedBookingWidgetState extends State<CompletedBookingWidget> {
  final _busyNfy = ValueNotifier(false);
  List<BookedServiceModel> _bookedServices = [];

  @override
  void initState() {
    super.initState();
    final model = context.read<BookingViewModel>();
    _busyNfy.value = true;
    model.fetchConfirmBooking().then((value) {
      if (value.status == ApiStatus.success) {
        _bookedServices = value.data!;
      }
      _busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _busyNfy,
      builder: (context, bool busy, _) {
        if (busy) {
          return const Center(
            child: LoaderWidget(),
          );
        }
        if (_bookedServices.isEmpty) {
          return const Center(
            child: Text(
              "No booking found. Please book services to view",
              style: TextStyle(fontSize: 14, fontFamily: "Montserrat"),
            ),
          );
        }
        return Column(
          children: [
            ..._bookedServices.map((data) {
              return BookedServiceCardWidget(data: data);
            })
          ],
        );
      },
    );
  }
}

class BookedServiceCardWidget extends StatelessWidget {
  final BookedServiceModel data;

  const BookedServiceCardWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: highlightColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(12),
                child: CachedNetworkImage(
                  imageUrl: data.category.imageUrl,
                  height: 80,
                  width: 80,
                ),
              ),
              UIHelper.horizontalSpaceMedium,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.category.name,
                      style: const TextStyle(fontFamily: "Montserrat"),
                    ),
                    UIHelper.verticalSpaceSmall,
                    Row(
                      children: [
                        const Icon(
                          Icons.location_city_outlined,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          data.city.name,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              UIHelper.horizontalSpaceMedium,
              Text(
                "₹ ${data.amount}",
                style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: "Montserrat"),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              timeago.format(data.createdAt),
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
