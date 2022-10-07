import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../../core/constance/provider.dart';
import '../../../core/constance/strings.dart';
import '../../../core/constance/style.dart';
import '../../../core/modal/service.dart';
import '../../../core/utils/storage/storage.dart';
import '../../shared/androidBackButton.dart';
import '../../shared/messenger/util.dart';
import '../../widgets/bottom/bottom13.dart';
import '../../widgets/dialogs/easyDialog2.dart';
import '../../widgets/dialogs/menu.dart';
import '../../widgets/localHero.dart';
import 'component/home.dart';
import 'component/home_booking_view.dart';

ProviderData currentProvider = ProviderData.createEmpty();
GlobalKey currentSourceKeyProvider = GlobalKey();
String titleForServiceList = "";

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  bool _startLocalHero = false;
  var windowWidth;
  var windowHeight;
  double windowSize = 0;
  bool user = false;
  final GlobalKey _keyDestProvider = GlobalKey();
  late AnimationController _controller2;
  Animation? _animation2;

  final _editControllerAddress = TextEditingController();
  final _editControllerName = TextEditingController();
  final _editControllerPhone = TextEditingController();

  @override
  void initState() {
    _init();
    super.initState();
    context.read<HomeViewModal>().initHomeModule();
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    initLocation();
  }

  @override
  void dispose() {
    _editControllerAddress.dispose();
    _editControllerName.dispose();
    _editControllerPhone.dispose();
    _controller2.dispose();
    super.dispose();
  }

  _init() async {
    _waits(false);
  }

  bool _wait = false;

  _waits(bool value) {
    _wait = value;
    _redraw();
  }

  _redraw() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);

    print(Storage.instance.token);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WillPopScope(
        onWillPop: () async {
          if (_show != 0) {
            _show = 0;
            return false;
          }
          if (_state.isNotEmpty) {
            _state = androidBackButton(_state, _lastState);
            if (_state.isNotEmpty) {
              _redraw();
              return false;
            }
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: (darkMode) ? blackColorTitleBkg : mainColorGray,
          resizeToAvoidBottomInset: false,
          body: Directionality(
            textDirection: strings.direction,
            child: LocalHero(
              getKeySource: () {
                //print("getKeySource currentSourceKeyProvider=$currentSourceKeyProvider");
                return currentSourceKeyProvider;
              },
              getKeyDest: () => _keyDestProvider,
              getStart: () => _startLocalHero,
              setStart: () {
                _startOpacity();
                Future.delayed(const Duration(milliseconds: 100), () {
                  _state = "provider";
                  dprint("_route _redraw _state=$_state");
                  _redraw();
                });
                // print("setStart");
              },
              setEnd: () {
                _startLocalHero = false;
              },
              child: Stack(
                children: <Widget>[
                  if (_state == "home")
                    HomeScreen(
                      callback: _route,
                      openDialogFilter: () {
                        _dialogOpen = "filter";
                        _openDialog();
                      },
                      openDialogService: (ServiceData item) {
                        _dialogOpen = "service";
                        selectService = item;
                        _openDialog();
                      },
                    ),
                  if (_state == "favorite") Container(),
                  if (_state == "cart") Container(),
                  if (_state == "booking") const HomeBookingView(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: BottomBar13(
                        mainColorGray: (darkMode) ? Colors.black : Colors.white,
                        colorSelect: primaryColor,
                        colorUnSelect: Colors.grey,
                        textStyle: theme.style10W600Grey,
                        textStyleSelect: theme.style11W800MainColor,
                        radius: 10,
                        callback: (int y) {
                          if (y == 0) _state = "home";
                          if (y == 1) _state = "favorite";
                          if (y == 2) _state = "cart";
                          if (y == 3) _state = "booking";
                          if (y == 4) {
                            _dialogOpen = "menu";
                            return _openDialog();
                          }
                          _redraw();
                        },
                        getItem: () {
                          switch (_state) {
                            case "home":
                              return 0;
                            case "favorite":
                              return 1;
                            case "cart":
                              return 2;
                            case "booking":
                              return 3;
                          }
                          return 0;
                        },
                        text: [
                          strings.get(19),

                          /// "Home",
                          strings.get(20),

                          /// "Favorites",
                          strings.get(21),

                          /// "Cart",
                          strings.get(82),

                          /// "Booking",
                          strings.get(23),

                          /// "Menu"
                        ],
                        getUnreadMessages: (int index) {
                          if (index == 2) return 2;
                          return 0;
                        },
                        icons: const [
                          Icons.home,
                          Icons.favorite,
                          Icons.shopping_cart,
                          Icons.copy,
                          Icons.menu
                        ]),
                  ),
                  IEasyDialog2(
                    setPosition: (double value) {
                      _show = value;
                    },
                    getPosition: () {
                      return _show;
                    },
                    color: Colors.grey,
                    getBody: _getBody,
                    backgroundColor: (darkMode) ? Colors.black : Colors.white,
                  ),
                  if (_wait)
                    const Center(
                      child: LoaderWidget(
                        color: primaryColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _state = "home";
  final List<String> _lastState = ["home"];

  _route(String state) {
    _lastState.add(state);
    if (state == "provider") {
      _startLocalHero = true;
      return _redraw();
    }
    _state = state;
    if (state == "termsBack") {
      _state = "";
      if (_fromLogin) {
        _fromLogin = false;
        _state = "login";
      }
      if (_fromRegister) {
        _fromRegister = false;
        _state = "register";
      }
    }
    if (state == "logout") {
      _state = "";
    }
    if (state == "termsFromLogin") {
      _fromLogin = true;
      _state = "terms";
    }
    if (state == "termsFromRegister") {
      _fromRegister = true;
      _state = "terms";
    }
    if (state == "orders") {
      _state = "booking";
    }

    _redraw();
  }

  //
  //
  //
  bool _addressAdded = false;
  bool _fromLogin = false;
  bool _fromRegister = false;
  ServiceData? selectService;
  double _show = 0;
  String _dialogOpen = "";

  _openDialog() {
    _show = 1;
    _redraw();
  }

  _getBody() {
    if (_dialogOpen == "menu") {
      return getBodyMenuDialog(
          _redraw,
          () {
            _show = 0;
            _redraw();
          },
          windowWidth,
          (String route) {
            _show = 0;
            _route(route);
          });
    }

    return Container();
  }

  _startOpacity() {
    _animation2 = Tween(begin: 0.0, end: 1).animate(_controller2)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller2.reset();
          _animation2 = null;
        }
      });
    _controller2.forward();
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
}
