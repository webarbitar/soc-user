import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/utils/string_extension.dart';
import 'package:socspl/ui/shared/validator_mixin.dart';
import 'package:socspl/ui/views/booking/booking_details_view.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/booking/booked_service_model.dart';
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
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Booking"),
          elevation: 0.2,
          bottom: const TabBar(
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 14,
            ),
            isScrollable: true,
            tabs: [
              Tab(
                child: Text("Pending"),
              ),
              Tab(
                child: Text("Confirmed"),
              ),
              Tab(
                child: Text("Ongoing"),
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
            OngoingBookingWidget(),
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
  late Timer _timer;
  bool _pause = true;

  void initDataFetcher() {
    final model = context.read<BookingViewModel>();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_pause) {
        model.fetchPendingBooking(notify: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initPendingBooking();
    initDataFetcher();
  }

  initPendingBooking() {
    final model = context.read<BookingViewModel>();
    _busyNfy.value = true;
    model.fetchPendingBooking().then((value) {
      if (value.status == ApiStatus.error) {
        showErrorMessage(value.message);
      }
      _busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingViewModel>(builder: (context, model, _) {
      return ValueListenableBuilder(
        valueListenable: _busyNfy,
        builder: (context, bool busy, _) {
          if (busy) {
            return const Center(
              child: LoaderWidget(),
            );
          }
          if (model.pendingBooking.isEmpty) {
            return const Center(
              child: Text(
                "No booking found. Please book services to view",
                style: TextStyle(fontSize: 14, fontFamily: "Montserrat"),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ...model.pendingBooking.map((data) {
                  return InkWell(
                    onTap: () async {
                      _pause = true;
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookingDetailsView(id: data.id),
                        ),
                      );
                      _pause = false;
                    },
                    child: BookedServiceCardWidget(data: data),
                  );
                })
              ],
            ),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class ConfirmedBookingWidget extends StatefulWidget {
  const ConfirmedBookingWidget({Key? key}) : super(key: key);

  @override
  State<ConfirmedBookingWidget> createState() => _ConfirmedBookingWidgetState();
}

class _ConfirmedBookingWidgetState extends State<ConfirmedBookingWidget> {
  final _busyNfy = ValueNotifier(false);
  late Timer _timer;
  bool _pause = true;

  void initDataFetcher() {
    final model = context.read<BookingViewModel>();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_pause) {
        model.fetchConfirmBooking(notify: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initConfirmedBooking();
    initDataFetcher();
  }

  initConfirmedBooking() {
    final model = context.read<BookingViewModel>();
    _busyNfy.value = true;
    model.fetchConfirmBooking().then(
      (value) {
        if (value.status == ApiStatus.error) {
          showErrorMessage(value.message);
        }
        _busyNfy.value = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingViewModel>(builder: (context, model, _) {
      return ValueListenableBuilder(
        valueListenable: _busyNfy,
        builder: (context, bool busy, _) {
          if (busy) {
            return const Center(
              child: LoaderWidget(),
            );
          }
          if (model.confirmBooking.isEmpty) {
            return const Center(
              child: Text(
                "No booking found. Please book services to view",
                style: TextStyle(fontSize: 14, fontFamily: "Montserrat"),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ...model.confirmBooking.map((data) {
                  return InkWell(
                    onTap: () async {
                      _pause = true;
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookingDetailsView(id: data.id),
                        ),
                      );
                      _pause = false;
                    },
                    child: BookedServiceCardWidget(data: data),
                  );
                })
              ],
            ),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class OngoingBookingWidget extends StatefulWidget {
  const OngoingBookingWidget({Key? key}) : super(key: key);

  @override
  State<OngoingBookingWidget> createState() => _OngoingBookingWidgetState();
}

class _OngoingBookingWidgetState extends State<OngoingBookingWidget>
    with AutomaticKeepAliveClientMixin {
  final _busyNfy = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    final model = context.read<BookingViewModel>();
    _busyNfy.value = true;
    model.fetchOngoingBooking().then((value) {
      if (value.status == ApiStatus.error) {
        showErrorMessage(value.message);
      }
      _busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<BookingViewModel>(builder: (context, model, _) {
      return ValueListenableBuilder(
        valueListenable: _busyNfy,
        builder: (context, bool busy, _) {
          if (busy) {
            return const Center(
              child: LoaderWidget(),
            );
          }
          if (model.ongoingBooking.isEmpty) {
            return const Center(
              child: Text(
                "No ongoing booking found. Please book services to view",
                style: TextStyle(fontSize: 14, fontFamily: "Montserrat"),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ...model.ongoingBooking.map((data) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookingDetailsView(id: data.id),
                        ),
                      );
                    },
                    child: BookedServiceCardWidget(data: data),
                  );
                })
              ],
            ),
          );
        },
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class CompletedBookingWidget extends StatefulWidget {
  const CompletedBookingWidget({Key? key}) : super(key: key);

  @override
  State<CompletedBookingWidget> createState() => _CompletedBookingWidgetState();
}

class _CompletedBookingWidgetState extends State<CompletedBookingWidget>
    with AutomaticKeepAliveClientMixin {
  final _busyNfy = ValueNotifier(false);
  late Timer _timer;
  bool _pause = true;

  void initDataFetcher() {
    final model = context.read<BookingViewModel>();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_pause) {
        model.fetchPendingBooking(notify: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final model = context.read<BookingViewModel>();
    _busyNfy.value = true;
    model.fetchCompletedBooking().then((value) {
      if (value.status == ApiStatus.error) {
        showErrorMessage(value.message);
      }
      _busyNfy.value = false;
    });
    initDataFetcher();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<BookingViewModel>(
      builder: (context, model, _) {
        return ValueListenableBuilder(
          valueListenable: _busyNfy,
          builder: (context, bool busy, _) {
            if (busy) {
              return const Center(
                child: LoaderWidget(),
              );
            }
            if (model.completedBooking.isEmpty) {
              return const Center(
                child: Text(
                  "No booking found. Please book services to view",
                  style: TextStyle(fontSize: 14, fontFamily: "Montserrat"),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...model.completedBooking.map((data) {
                    return InkWell(
                      onTap: () async {
                        _pause = true;
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BookingDetailsView(id: data.id),
                          ),
                        );
                        _pause = false;
                      },
                      child: BookedServiceCardWidget(data: data),
                    );
                  })
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;
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
                    const SizedBox(height: 4),
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
                    UIHelper.verticalSpaceSmall,
                    Text(
                      data.status.capitalize(),
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: data.status == "rejected" || data.status == "cancelled"
                            ? Colors.red
                            : null,
                      ),
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

void loadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const LoaderWidget();
    },
  );
}
