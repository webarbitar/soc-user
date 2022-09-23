import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/address/geocode_address.dart';
import 'package:socspl/core/modal/city_modal.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/ui/shared/navigation/navigation.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/widgets/buttons/button134.dart';

import '../../../core/constance/style.dart';

class LocationPickerView extends StatefulWidget {
  const LocationPickerView({Key? key}) : super(key: key);

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  // Revert back to the previous changes
  late String prevAddress;
  late LatLng prevLocation;
  CityModal? prevCity;

  final Completer<GoogleMapController> _controller = Completer();
  final _addressNfy = ValueNotifier("Pick location");
  final _searchNfy = ValueNotifier("");

  CityModal? city;

  late LatLng _currentLatLng;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    final modal = context.read<HomeViewModal>();
    _currentLatLng = modal.currentLatLng;
    prevAddress = modal.currentAddress;
    prevLocation = modal.currentLatLng;
    prevCity = modal.city;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final modal = context.read<HomeViewModal>();
        modal.currentLatLng = prevLocation;
        modal.currentAddress = prevAddress;
        modal.city = prevCity;
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
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
                      _fetchLocation();
                    },
                    onCameraMove: (pos) {
                      _currentLatLng = pos.target;
                    },
                    onTap: (arg) {
                      FocusManager.instance.primaryFocus?.unfocus();
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
                        Flexible(
                          child: InkWell(
                            onTap: () async {
                              final modal = context.read<HomeViewModal>();
                              final res = await Navigation.instance
                                  .navigate("/search-location", args: _searchNfy.value);
                              if (res != null) {
                                _searchNfy.value = res;
                                _updateCameraView(modal.currentLatLng);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 10, right: 10),
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  UIHelper.horizontalSpaceSmall,
                                  const Icon(
                                    Icons.search_outlined,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: ValueListenableBuilder<String>(
                                      valueListenable: _searchNfy,
                                      builder: (context, String val, _) {
                                        return Text(
                                          val.isEmpty ? "Search Location" : val,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      },
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          constraints:
                              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: primaryColor,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: ValueListenableBuilder(
                              valueListenable: _addressNfy,
                              builder: (context, String val, _) {
                                return Text(
                                  val,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }),
                        ),
                        Container(
                          height: 14,
                          width: 4,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                      ],
                    ),
                  ),
                  _currentLocationButton(),
                  Positioned(
                    bottom: 30,
                    left: 30,
                    right: 30,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: primaryColor,
                      ),
                      alignment: Alignment.centerRight,
                      child: button134(
                        "Confirm Location",
                        () {
                          final modal = context.read<HomeViewModal>();
                          modal.currentAddress = _addressNfy.value;
                          modal.currentLatLng = _currentLatLng;
                          modal.initHomeModule(initLocation: false);
                          Navigation.instance.goBack();
                        },
                        true,
                        const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat",
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchLocation() async {
    final modal = context.read<HomeViewModal>();
    LatLng latLng = LatLng(_currentLatLng.latitude, _currentLatLng.longitude);
    final res = await modal.fetchAddressFromGeocode(latLng);
    print(res.data?.formattedAddress);
    if (res.status == ApiStatus.success) {
      _addressNfy.value = res.data!.formattedAddress;
      // Check city availability
      print(res.data!.locality);
      final city = await modal.checkCityAvailability(res.data!.locality);
      if (city == null) {
        modal.checkCityAvailability(res.data!.administrativeAreaLevel2);
      }
    }
  }

  Widget _currentLocationButton() {
    return Positioned(
      right: 30,
      bottom: 140,
      child: SizedBox(
        height: 40,
        width: 40,
        child: FloatingActionButton(
          onPressed: () async {
            final modal = context.read<HomeViewModal>();
            await modal.myCurrentLocation();
            _updateCameraView(modal.currentLatLng);
          },
          elevation: 0.5,
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.my_location,
            color: Colors.blue,
          ),
        ),
      ),
    );
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.grey,
      ),
    );
  }
}
