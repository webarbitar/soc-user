import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:socspl/core/modal/address/user_address_model.dart';
import 'package:socspl/core/modal/city_modal.dart';
import 'package:socspl/core/view_modal/booking/booking_view_model.dart';
import 'package:socspl/core/view_modal/user/user_view_model.dart';
import 'package:socspl/ui/widgets/loader/loader_widget.dart';

import '../../../core/constance/style.dart';
import '../../../core/enum/api_status.dart';
import '../../../core/view_modal/home/home_view_modal.dart';
import '../../../env.dart';
import '../../shared/map/map_conf_mixin.dart';
import '../../shared/navigation/navigation.dart';
import '../../shared/ui_helpers.dart';
import '../../widgets/custom/custom_button.dart';
import '../../widgets/custom/custom_text_field.dart';
import 'booking_date_view.dart';

class BookingAddressView extends StatefulWidget {
  const BookingAddressView({Key? key}) : super(key: key);

  @override
  State<BookingAddressView> createState() => _BookingAddressViewState();
}

class _BookingAddressViewState extends State<BookingAddressView> with MapConfig {
  final _dragController = DraggableScrollableController();
  final _addressNfy = ValueNotifier("Pick location");
  final _busyNfy = ValueNotifier(false);

  final Completer<GoogleMapController> _controller = Completer();
  late LatLng _currentLatLng;
  CityModal? _city;

  late final AnimationController _animateCtrl;
  late final Animation<Offset> _offsetAnimation;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _houseNoCtrl = TextEditingController();
  final TextEditingController _areaCtrl = TextEditingController();
  final TextEditingController _landmarkCtrl = TextEditingController();
  final _tagNfy = ValueNotifier("");
  final _tagData = const ["Home", "Office"];
  String _pinCode = "";

  @override
  void initState() {
    super.initState();
    final modal = context.read<HomeViewModal>();
    _currentLatLng = modal.currentLatLng;
    _addressNfy.value = modal.currentAddress;
    _fetchLocation();
    // _animateCtrl = AnimationController(
    //   vsync: this,
    //   duration: const Duration(
    //     milliseconds: 500,
    //   ),
    // );
    // _offsetAnimation = Tween<Offset>(
    //   begin: const Offset(0, 0.4),
    //   end: Offset.zero,
    // ).animate(
    //   CurvedAnimation(
    //     parent: _animateCtrl,
    //     curve: Curves.decelerate,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _currentLatLng,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            onCameraIdle: () {
              // _animateCtrl.reverse();
              _fetchLocation();
            },
            onCameraMove: (pos) {
              // _animateCtrl.forward();
              Future.delayed(const Duration(milliseconds: 400), () {
                _currentLatLng = pos.target;
              });
            },
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 50,
            left: 2,
            right: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigation.instance.maybeGoBack();
                  },
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin: const EdgeInsets.only(left: 16),
                    child: const Icon(
                      Icons.keyboard_backspace_rounded,
                      color: primaryColor,
                    ),
                  ),
                ),
                UIHelper.horizontalSpaceSmall,
              ],
            ),
          ),
          Center(
            child: RepaintBoundary(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/icons/location-pin.png",
                    cacheHeight: 35,
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            controller: _dragController,
            initialChildSize: 0.4,
            minChildSize: 0.35,
            maxChildSize: 0.8,
            snap: true,
            builder: (context, scrollController) {
              return ValueListenableBuilder(
                  valueListenable: _busyNfy,
                  builder: (context, bool busy, _) {
                    if (busy) {
                      return const Center(
                        child: LoaderWidget(),
                      );
                    }
                    return SafeArea(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                          boxShadow: [dropShadow],
                        ),
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  children: [
                                    UIHelper.verticalSpaceSmall,
                                    const ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      child: SizedBox(
                                        width: 60,
                                        child: Divider(
                                          thickness: 6,
                                          height: 6,
                                        ),
                                      ),
                                    ),
                                    UIHelper.verticalSpaceSmall,
                                    Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              _dragController.animateTo(
                                                1.0,
                                                duration: const Duration(milliseconds: 500),
                                                curve: Curves.decelerate,
                                              );
                                              final res = await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BookingSearchPage(text: ""),
                                                ),
                                              );
                                              if (res != null) {
                                                if (res["city"] != null) {
                                                  _addressNfy.value = res["address"];
                                                  _currentLatLng = res["points"];
                                                  _city = res["city"];
                                                  _pinCode = res["pinCode"];
                                                  _updateCameraView(res["points"]);
                                                  _dragController.animateTo(
                                                    0.4,
                                                    duration: const Duration(milliseconds: 500),
                                                    curve: Curves.decelerate,
                                                  );
                                                } else {
                                                  if (!mounted) return;
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Location not in service. Please try other location,",
                                                      ),
                                                      backgroundColor: Colors.red,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            child: Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.grey),
                                                // boxShadow: const [dropShadow],
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: const [
                                                  UIHelper.horizontalSpaceSmall,
                                                  Icon(
                                                    Icons.search_outlined,
                                                    color: primaryColor,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      "Search Location",
                                                      style: TextStyle(fontFamily: "Montserrat"),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  UIHelper.horizontalSpaceSmall,
                                                ],
                                              ),
                                            ),
                                          ),
                                          UIHelper.verticalSpaceSmall,
                                          const Divider(height: 4),
                                          UIHelper.verticalSpaceSmall,
                                          InkWell(
                                            onTap: () async {
                                              final model = context.read<HomeViewModal>();
                                              final pos = await model.currentLocation();
                                              _currentLatLng = LatLng(pos.latitude, pos.longitude);
                                              _updateCameraView(_currentLatLng);
                                              _fetchLocation();
                                            },
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.my_location_outlined,
                                                  color: Colors.orange,
                                                  size: 22,
                                                ),
                                                UIHelper.horizontalSpaceSmall,
                                                Text(
                                                  "Use current location",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Montserrat",
                                                    fontSize: 15,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          UIHelper.verticalSpaceMedium,
                                          Material(
                                            elevation: 1.0,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              side: const BorderSide(color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 12,
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.location_on_outlined),
                                                  UIHelper.horizontalSpaceSmall,
                                                  Flexible(
                                                    child: ValueListenableBuilder(
                                                      valueListenable: _addressNfy,
                                                      builder: (context, String adr, _) {
                                                        return Text(
                                                          adr,
                                                          style: const TextStyle(
                                                            fontSize: 13,
                                                            fontFamily: "Montserrat",
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          UIHelper.verticalSpaceMedium,
                                          CustomTextField(
                                            controller: _nameCtrl,
                                            labelText: "Full Name",
                                          ),
                                          UIHelper.verticalSpaceMedium,
                                          CustomTextField(
                                            controller: _mobileCtrl,
                                            labelText: "Mobile Number",
                                          ),
                                          UIHelper.verticalSpaceMedium,
                                          CustomTextField(
                                            controller: _houseNoCtrl,
                                            labelText: "House/Flat Number",
                                          ),
                                          UIHelper.verticalSpaceMedium,
                                          CustomTextField(
                                            controller: _areaCtrl,
                                            labelText: "Area",
                                          ),
                                          UIHelper.verticalSpaceMedium,
                                          CustomTextField(
                                            controller: _landmarkCtrl,
                                            labelText: "Landmark",
                                          ),
                                          UIHelper.verticalSpaceMedium,
                                          const Text(
                                            "Save as",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          UIHelper.verticalSpaceSmall,
                                          Row(
                                            children: [
                                              ..._tagData.map((tag) {
                                                return ValueListenableBuilder(
                                                  valueListenable: _tagNfy,
                                                  builder: (context, String value, _) {
                                                    bool isActive = tag == value;

                                                    return Padding(
                                                      padding: const EdgeInsets.only(right: 20),
                                                      child: InkWell(
                                                        onTap: () {
                                                          _tagNfy.value = tag;
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            color: isActive
                                                                ? Colors.green.shade100
                                                                : Colors.grey.shade200,
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              tag,
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                fontFamily: "Montserrat",
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                              child: CustomButton(
                                text: "Save and proceed to slots",
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  final model = context.read<UserViewModel>();
                                  if (_city != null) {
                                    _busyNfy.value = true;
                                    var usrAdr = UserAddressModel(
                                      name: _nameCtrl.text.trim(),
                                      mobile: _mobileCtrl.text.trim(),
                                      flatNo: _houseNoCtrl.text.trim(),
                                      area: _areaCtrl.text.trim(),
                                      landmark: _landmarkCtrl.text.trim(),
                                      latLng: _currentLatLng,
                                      pinCode: _pinCode.isNotEmpty?_pinCode:"N/A",
                                      cityId: _city!.id,
                                      type: _tagNfy.value.toLowerCase(),
                                    );
                                    final res = model.addUserAddress(usrAdr);
                                    res.then((value) {
                                      if (value.status == ApiStatus.success) {
                                        context.read<BookingViewModel>().userAddress = value.data;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const BookingDateView(),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              value.message,
                                              style: const TextStyle(fontFamily: "Montserrat"),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                      _busyNfy.value = false;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Location not in service. Please try other location,",
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }

  void _fetchLocation() async {
    _busyNfy.value = true;
    final modal = context.read<HomeViewModal>();
    final res = await modal.fetchAddressFromGeocode(_currentLatLng);

    if (res.status == ApiStatus.success) {
      _addressNfy.value = res.data!.formattedAddress;
      // Check city availability
      // print(res.data!.locality);
      _pinCode = res.data!.postalCode;
      print(res.data!.postalCode);
      print('****');
      print('****');
      _city = await modal.checkCityAvailability(res.data!.locality, notify: false);
      _city ??=
          await modal.checkCityAvailability(res.data!.administrativeAreaLevel2, notify: false);
    }
      _busyNfy.value = false;
  }

  void _updateCameraView(LatLng latLng) async {
    final ctrl = await _controller.future;
    ctrl.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          bearing: 0,
          zoom: 15,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _animateCtrl.dispose();
    _houseNoCtrl.dispose();
    _landmarkCtrl.dispose();
    _controller.future.then((value) => value.dispose());
    _dragController.dispose();
  }
}

class BookingSearchPage extends StatefulWidget {
  final String text;

  const BookingSearchPage({Key? key, required this.text}) : super(key: key);

  @override
  State<BookingSearchPage> createState() => _BookingSearchPageState();
}

class _BookingSearchPageState extends State<BookingSearchPage> {
  TextEditingController searchController = TextEditingController();
  List<Prediction> alPredictions = [];

  Future<void> onSearchChanged(String text) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=$mapToken&components=country:in";
    print(url);
    http.Response response = await http.get(Uri.parse(url));
    print(jsonDecode(response.body));
    PlacesAutocompleteResponse placeResponse =
        PlacesAutocompleteResponse.fromJson(jsonDecode(response.body));
    if ((placeResponse.predictions ?? []).isNotEmpty) {
      print('predictions ${placeResponse.predictions}');
      alPredictions = placeResponse.predictions ?? [];
      setState(() {});
    }
    print(alPredictions.length);
  }

  Future<void> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    final modal = context.read<HomeViewModal>();
    FocusManager.instance.primaryFocus?.unfocus();
    Navigation.instance.navigate("/loadingDialog");
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=$mapToken";
    http.Response response = await http.get(Uri.parse(url));

    PlaceDetails placeDetails = PlaceDetails.fromJson(jsonDecode(response.body));
    prediction.lat = placeDetails.result?.geometry?.location?.lat.toString();
    prediction.lng = placeDetails.result?.geometry?.location?.lng.toString();
    // final result = await Navigation.instance.navigate("/locationSelect",args: LatLng(double.parse(prediction.lat ?? "0"), double.parse(prediction.lng ?? "0")));
    final latLng = LatLng(double.parse(prediction.lat ?? "0"), double.parse(prediction.lng ?? "0"));

    final res = await modal.fetchAddressFromGeocode(latLng);
    print(res.data?.formattedAddress);
    if (res.status == ApiStatus.success) {
      // Check city availability
      print(res.data!.locality);

      var city = await modal.checkCityAvailability(res.data!.locality);
      city ??= await modal.checkCityAvailability(res.data!.administrativeAreaLevel2);

      Navigation.instance.goBack();
      if (!mounted) return;
      Navigator.pop(context, {
        "address": res.data!.formattedAddress,
        "pinCode": res.data!.postalCode,
        "points": latLng,
        "city": city,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    searchController.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            UIHelper.verticalSpaceMedium,
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  IconButton(
                      onPressed: Navigation.instance.goBack,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: TextField(
                        controller: searchController,
                        onChanged: (val) {
                          if (val.length > 2) {
                            onSearchChanged(val);
                          } else {
                            alPredictions.clear();
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey.shade200)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey.shade200)),
                          contentPadding: const EdgeInsets.only(left: 16, right: 16),
                          hintText: "Search Location",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alPredictions.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, pos) {
                  Prediction prediction = alPredictions[pos];
                  return GestureDetector(
                    onTap: () {
                      getPlaceDetailsFromPlaceId(prediction);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            prediction.description ?? "",
                            style: const TextStyle(fontSize: 13.5, height: 1.6),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Divider(
                          color: Colors.grey.shade300,
                          height: 1,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
