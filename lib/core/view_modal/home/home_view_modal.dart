import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/banner/promo_banner.dart';
import 'package:socspl/core/modal/category/add_on_modal.dart';
import 'package:socspl/core/modal/category/rate_card_model.dart';
import 'package:socspl/core/modal/category/sub_category_modal.dart';
import 'package:socspl/core/modal/category/trending_category_modal.dart';
import 'package:socspl/core/modal/city_modal.dart';
import 'package:socspl/core/modal/section/section_modal.dart';
import 'package:socspl/core/modal/service/category_service_modal.dart';
import 'package:socspl/core/modal/testimonial/testimonial_model.dart';
import 'package:socspl/core/services/banner/banner_service.dart';
import 'package:socspl/core/services/category/category_service.dart';
import 'package:socspl/core/services/home/home_service.dart';
import 'package:socspl/core/services/map/map_service.dart';
import 'package:socspl/core/utils/permission/permission_handler_service.dart';
import 'package:socspl/core/view_modal/base_view_modal.dart';
import 'package:socspl/ui/shared/navigation/navigation.dart';
import 'package:socspl/ui/views/auth/permission_handler_page.dart';

import '../../modal/address/geocode_address.dart';
import '../../modal/banner/banner_modal.dart';
import '../../modal/category/category_banner_modal.dart';
import '../../modal/category/category_modal.dart';
import '../../modal/category/child_category_modal.dart';
import '../../modal/response_modal.dart';
import '../../utils/storage/storage.dart';
import '../cart/cart_view_model.dart';

class HomeViewModal extends BaseViewModal with PermissionHandlerService {
  final HomeService _homeService = HomeService();
  CategoryService categoryService = CategoryService();
  BannerService bannerService = BannerService();
  late MapService _mapService;

  set mapService(MapService value) {
    _mapService = value;
  }

  List<BannerModal> banners = [];

  List<PromoBannerModal> offerBanners = [];

  List<PromoBannerModal> workBanners = [];

  List<BannerModal> homeBanner = const [];

  List<CategoryModal> categories = [];

  List<SubCategoryModal> subCategories = [];

  List<ChildCategoryModal> childCategories = [];

  List<CategoryServiceModal> categoryServices = [];

  CategoryServiceModal? serviceModal;

  List<AddOnModal> addOnList = [];

  List<SectionModal> sections = [];

  List<RateCardModel> rateCards = [];

  late CategoryBannerModal categoryBanner;

  List<TrendingCategoryModal> trendingCategories = [];

  List<TestimonialModel> testimonials = [];

  late PermissionStatus _permissionStatus = PermissionStatus.denied;

  CityModal? city;

  String selectedCategory = "";

  String selectedSubCategory = "";

  String currentAddress = "";

  LatLng currentLatLng = const LatLng(22.5726, 88.3639);

  Future<void> initHomeModule(BuildContext context, {bool initLocation = true}) async {
    final cartModel = context.read<CartViewModel>();
    setBusy(true);
    final pref = Storage.instance;
    print(pref.address);
    print(pref.city);
    if (pref.address == null) {
      if (initLocation) await myCurrentLocation();
    } else {
      currentAddress = pref.address!;
      currentLatLng = pref.latLng;
      await checkCityAvailability(pref.city!, notify: false);
    }

    final res = await bannerService.fetchAllBanner("${city?.id ?? ""}");
    if (res.status == ApiStatus.success) {
      banners.clear();
      banners.addAll(res.data!);
    }

    print("${city?.id ?? ""}");
    final res2 = await categoryService.fetchAllCategory("${city?.id ?? ""}");
    if (res2.status == ApiStatus.success) {
      categories.clear();
      categories.addAll(res2.data!);
    }

    if (city != null) {
      cartModel.initLocalCartModule("${city!.id}", categories);
    }

    final res3 = categoryService.fetchTrendingCategory("${city?.id ?? ""}");
    res3.then((value) {
      if (value.status == ApiStatus.success) {
        trendingCategories.clear();
        trendingCategories.addAll(value.data!);
        notifyListeners();
      }
    });
    fetchOfferBanner();
    fetchWorkBanner();
    fetchHomeBanners();
    fetchSections();
    fetchAllTestimonials();
    busy = false;
    notifyListeners();
  }

  Future<void> fetchOfferBanner() async {
    final res = await bannerService.fetchAllOfferBanner("${city?.id ?? ""}");
    print(res.status);
    if (res.status == ApiStatus.success) {
      offerBanners.clear();
      offerBanners.addAll(res.data!);
    }
    notifyListeners();
  }

  Future<void> fetchWorkBanner() async {
    final res = await bannerService.fetchAllWorkBanner("${city?.id ?? ""}");
    if (res.status == ApiStatus.success) {
      workBanners.clear();
      workBanners.addAll(res.data!);
    }
    notifyListeners();
  }

  Future<void> fetchHomeBanners() async {
    final res = await bannerService.fetchHomeBanners();
    if (res.status == ApiStatus.success) {
      homeBanner = res.data!;
    }
    notifyListeners();
  }

  Future<CityModal?> checkCityAvailability(String search, {bool notify = true}) async {
    if (notify) {
      setBusy(true);
    }
    final res = await categoryService.checkCityAvailability(search);
    if (res.status == ApiStatus.success) {
      if (res.data!.isNotEmpty) {
        city = res.data!.first;
      } else {
        city = null;
      }
    }
    if (notify) {
      setBusy(false);
      notifyListeners();
    }
    return city;
  }

  fetchSubCategoryModal(int id, {String search = ""}) async {
    setBusy(true);
    final res = await categoryService.fetchSubCategoryById(id, "${city?.id ?? ""}");
    if (res.status == ApiStatus.success) {
      categoryBanner = res.data!;
    }
    busy = false;
    notifyListeners();
  }

  fetchChildCategoryModal(String categoryId, String subCategoryId, {String search = ""}) async {
    // setBusy(true);
    final res = await categoryService.fetchChildCategoryById(
      categoryId,
      subCategoryId,
      "${city?.id ?? ""}",
      search: search,
    );
    if (res.status == ApiStatus.success) {
      childCategories.clear();
      childCategories.addAll(res.data!);
    }
    // busy = false;
    notifyListeners();
  }

  Future<void> fetchAllServicesByCategoryIds(String categoryId, String subCategoryId,
      {String childCategoryId = "", String search = ""}) async {
    // setBusy(true);
    categoryServices.clear();
    final res = await categoryService.fetchAllServicesByCategoryIds(
      categoryId,
      subCategoryId,
      childCategoryId,
      "${city?.id ?? ""}",
      search: search,
    );
    if (res.status == ApiStatus.success) {
      categoryServices.addAll(res.data!);
    }
    // busy = false;
    notifyListeners();
  }

  Future<ResponseModal<CategoryServiceModal>> fetchServicesById(String id, {String? cityId}) async {
    setBusy(true);
    final res = await categoryService.fetchServiceById(
      id,
      "${cityId ?? (city?.id ?? "")}",
    );
    if (res.status == ApiStatus.success) {
      serviceModal = res.data;
      addOnList = serviceModal?.addOns ?? [];
    }
    busy = false;
    return res;
  }

  Future<void> fetchAddOnModal(int childCategoryId, {String search = ""}) async {
    setBusy(true);
    final res = await categoryService.fetchAddOnCategoryByChildCategory(
      childCategoryId,
      search: search,
    );
    if (res.status == ApiStatus.success) {
      addOnList.clear();
      addOnList.addAll(res.data!);
    }
    busy = false;
  }

  Future<void> fetchSections({String search = ""}) async {
    setBusy(true);
    final res = await categoryService.fetchSections(search: search);
    if (res.status == ApiStatus.success) {
      sections.clear();
      sections.addAll(res.data!);
    }
    busy = false;
  }

  Future<void> fetchRateCard(int childCategoryId) async {
    final res = await categoryService.fetchRateCard(childCategoryId);
    if (res.status == ApiStatus.success) {
      rateCards.clear();
      rateCards.addAll(res.data!);
    }
  }

  Future<void> fetchAllTestimonials() async {
    final res = await _homeService.fetchAllTestimonials();
    if (res.status == ApiStatus.success) {
      testimonials = res.data!;
      notifyListeners();
    }
  }

  Future<void> fetchLocation(LatLng latLng, {bool notify = false}) async {
    final res = await fetchAddressFromGeocode(latLng);
    currentLatLng = latLng;
    if (res.status == ApiStatus.success) {
      currentAddress = res.data!.formattedAddress;
      // Check city availability
      print(res.data!.locality);
      final city = await checkCityAvailability(res.data!.locality, notify: false);
      if (city == null) {
        await checkCityAvailability(res.data!.administrativeAreaLevel2, notify: false);
      }
    }
  }

  Future<void> _checkLocationPermission() async {
    _permissionStatus = await requestLocationPermission(false);
    if (_permissionStatus.isDenied || _permissionStatus.isPermanentlyDenied) {
      await Navigation.instance.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => PermissionHandlerDialog(
            permissionType: "location",
            onTap: () async {
              _permissionStatus = await requestLocationPermission(true);
              if (_permissionStatus.isGranted || _permissionStatus.isLimited) {
                Navigation.instance.goBack();
              }
              notifyListeners();
            },
          ),
        ),
      );
    }
  }

  Future<void> myCurrentLocation() async {
    await _checkLocationPermission();
    bool serviceEnabled;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    Position position = await Geolocator.getCurrentPosition();
    await fetchLocation(LatLng(position.latitude, position.longitude), notify: false);
    if (city != null) {
      Storage.instance.setLocation(
        latLng: currentLatLng,
        address: currentAddress,
        city: city!,
      );
    }
  }

  Future<Position> currentLocation() async {
    await _checkLocationPermission();
    bool serviceEnabled;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<ResponseModal<GeocodeAddress>> fetchAddressFromGeocode(LatLng latLng) async {
    final res = await _mapService.fetchAddressFromGeocode(position: latLng);
    return res;
  }
}
