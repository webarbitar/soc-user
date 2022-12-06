import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';

import '../../core/enum/api_status.dart';
import '../../core/modal/city_modal.dart';
import '../../env.dart';
import '../shared/navigation/navigation.dart';

class SearchPage extends StatefulWidget {
  final String text;

  const SearchPage({Key? key, required this.text}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

    Navigation.instance.goBack();
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

      CityModal? city;
      if (res.data!.locality.isNotEmpty) {
        city = await modal.checkCityAvailability(res.data!.locality);
      }
      if (city == null && res.data!.administrativeAreaLevel2.isNotEmpty) {
        await modal.checkCityAvailability(res.data!.administrativeAreaLevel2);
      }

      if (!mounted) return;
      Navigator.pop(context, res.data!.formattedAddress);
      modal.currentAddress = res.data!.formattedAddress;
      modal.currentLatLng = latLng;
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
