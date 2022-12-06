import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/view_modal/booking/booking_view_model.dart';
import 'package:socspl/ui/views/booking/payment_method_view.dart';
import 'package:socspl/ui/views/home/component/home_cart_view.dart';

import '../../../core/constance/style.dart';
import '../../../core/view_modal/home/home_view_modal.dart';
import 'component/home.dart';
import 'component/home_booking_view.dart';
import 'component/home_menu_view.dart';

class HomeView extends StatefulWidget {
  final int? pageIndex;

  const HomeView({Key? key, this.pageIndex}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final BookingViewModel _bookingViewModel;
  late final HomeViewModal _homeViewModal;
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageIndex ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
    _bookingViewModel = context.read<BookingViewModel>();
    initFirebasePushNotification();
    _homeViewModal = context.read<HomeViewModal>();
    _homeViewModal.initHomeModule(context).then((value) {
      _bookingViewModel.initOngoingBookingFetcher();
    });

    initLocation();
  }

  void initFirebasePushNotification() async {
    // FirebaseMessaging.instance;
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      print(token);
    });
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('message click one');
      print(message?.data);
      print('***');
      if (message != null) {
        // LocalNotificationService.showNotification(message);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      print('message click two');
      print(message.data);
      fcmPushMessageHandler(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('message click three');
      print(message.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: primaryColor,
      ),
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: (darkMode) ? blackColorTitleBkg : mainColorGray,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: primaryColor,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle: theme.style10W600Grey,
            selectedLabelStyle: theme.style11W800MainColor,
            onTap: (index) {
              _pageController.jumpToPage(index);
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.copy,
                ),
                label: "Booking",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: "Menu",
              ),
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => PaymentMethodView(
          //         onSelected: (p0) {},
          //       ),
          //     ));
          //   },
          // ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const [
              HomeScreen(),
              HomeCartView(),
              HomeBookingView(),
              HomeMenuView(),
            ],
          ),
        ),
      ),
    );
  }

  void initLocation() async {
    final modal = context.read<HomeViewModal>();
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // Position position = await Geolocator.getCurrentPosition();
  }

  void fcmPushMessageHandler(RemoteMessage message) async {
    if (message.notification != null) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Random().nextInt(8),
          channelKey: 'message_channel',
          title: message.notification!.title,
          body: message.notification!.body,
        ),
      );
    } else {
      final model = context.read<BookingViewModel>();
      final data = message.data;
      if (data.isNotEmpty) {
        switch (data["event"]) {
          case "service:booking:confirm":
            model.fetchConfirmBooking(notify: true);
            break;
          case "service:booking:started":
            // model.fetchOngoingBooking(notify: true);
            print(data["data"].toString());
            model.fetchBookingDetailsById(
              int.parse(data["data"].toString()),
              fetchService: false,
              notify: true,
            );
            break;
          case "service:booking:completeOtp":
            model.fetchBookingDetailsById(
              int.parse(data["data"].toString()),
              fetchService: false,
              notify: true,
            );
            break;
          case "service:booking:completed":
            model.fetchOngoingBooking(notify: true);
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bookingViewModel.resetTimer();
  }
}
