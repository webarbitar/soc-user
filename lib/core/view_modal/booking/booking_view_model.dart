import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:socspl/core/modal/address/user_address_model.dart';
import 'package:socspl/core/modal/booking/booked_service_model.dart';
import 'package:socspl/core/modal/booking/review_model.dart';
import 'package:socspl/ui/shared/navigation/navigation.dart';
import 'package:socspl/ui/views/booking/booking_invoice_view.dart';
import 'package:socspl/core/modal/response_modal.dart';
import 'package:socspl/core/modal/service/service_booking.dart';
import 'package:socspl/core/modal/time_slot_model.dart';

import '../../../env.dart';
import '../../enum/api_status.dart';
import '../../modal/booking/booked_service_details_model.dart';
import '../../modal/service/category_service_modal.dart';
import '../../services/booking/booking_service.dart';
import '../../services/category/category_service.dart';
import '../base_view_modal.dart';

class BookingViewModel extends BaseViewModal {
  late BookingService _bookingService;
  late CategoryService _categoryService;

  set bookingService(BookingService value) {
    _bookingService = value;
  }

  set categoryService(CategoryService value) {
    _categoryService = value;
  }

  // ======================== Variables ========================

  BookedServiceDetailsModel? _bookingDetails;

  List<BookedServiceModel> _pendingBooking = [];

  List<BookedServiceModel> _confirmBooking = [];

  List<BookedServiceModel> _ongoingBooking = [];

  List<BookedServiceModel> _completedBooking = [];

  List<CategoryServiceModal> _bookedServices = [];

  final List<CategoryServiceModal> _services = [];

  UserAddressModel? _userAddress;

  Timer? _timer;

  bool _pauseApiFetch = false;

  List<TimeSlotModel> _timeSlots = [];

  // ======================== Getter Methods ========================

  BookedServiceDetailsModel? get bookingDetails => _bookingDetails;

  List<BookedServiceModel> get pendingBooking => _pendingBooking;

  List<BookedServiceModel> get confirmBooking => _confirmBooking;

  List<BookedServiceModel> get ongoingBooking => _ongoingBooking;

  List<BookedServiceModel> get completedBooking => _completedBooking;

  List<CategoryServiceModal> get bookedServices => _bookedServices;

  List<CategoryServiceModal> get services => _services;

  UserAddressModel? get userAddress => _userAddress;

  List<TimeSlotModel> get timerSlots => _timeSlots;

  set userAddress(UserAddressModel? value) {
    _userAddress = value;
    notifyListeners();
  }

  void initOngoingBookingFetcher() {
    if (_timer != null) return;
    final context = Navigation.instance.navigatorKey.currentContext!;
    final navigation = Navigator.of(context);
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (!_pauseApiFetch) {
        final res = await _bookingService.fetchOngoingBooking(1);
        if (res.status == ApiStatus.success) {
          if (res.data!.isNotEmpty) {
            for (var data in res.data!) {
              if (data.estimatedBillSubmitted == 1 && data.estimatedBillStatus == "pending") {
                _pauseApiFetch = true;
                _bookedServices = [];
                await fetchBookingDetailsById(data.id);
                await showBillingApprovalModal();
              }

              if (data.completeOtpVerified == 1 && data.paymentStatus == "pending") {
                _pauseApiFetch = true;
                _bookedServices = [];
                await fetchBookingDetailsById(data.id);
                await navigation.push(
                  MaterialPageRoute(
                    builder: (context) => const BookingInvoiceView(isEstimate: false),
                  ),
                );
              }
              _pauseApiFetch = false;
            }
          }
        }
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;
    _pauseApiFetch = false;
  }

  Future<void> fetchTimeSlots(int categoryId) async {
    _timeSlots.clear();
    final res = await _bookingService.fetchTimeSlots(categoryId);
    if (res.status == ApiStatus.success) {
      _timeSlots = res.data!;
    }
    notifyListeners();
  }

  Future<ResponseModal<BookedServiceModel>> bookService(ServiceBooking data) async {
    print(jsonEncode(data.toMap()));
    final res = await _bookingService.bookServices(data.toMap());
    if (res.status == ApiStatus.success) {}
    // return ResponseModal.error(message: "dsf");
    return res;
  }

  Future<ResponseModal> cancelBooking(int bookingId) async {
    return await _bookingService.cancelBooking(bookingId);
  }

  Future<ResponseModal> fetchPendingBooking({bool notify = false}) async {
    final res = await _bookingService.fetchPendingBooking(1);
    if (res.status == ApiStatus.success) {
      _pendingBooking = res.data ?? [];
    }
    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModal> fetchConfirmBooking({bool notify = false}) async {
    final res = await _bookingService.fetchConfirmedBooking(1);
    if (res.status == ApiStatus.success) {
      _confirmBooking = (res.data ?? []).where((element) => element.jobStartTime == null).toList();
      //remove duplicate data in pending section
      if (_pendingBooking.isNotEmpty) {
        for (var data in _confirmBooking) {
          _pendingBooking.removeWhere((element) => element.id == data.id);
        }
      }
    }
    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModal> fetchOngoingBooking({bool notify = false}) async {
    final res = await _bookingService.fetchOngoingBooking(1);
    if (res.status == ApiStatus.success) {
      _ongoingBooking = res.data ?? [];
      //remove duplicate data in confirm section
      if (_confirmBooking.isNotEmpty) {
        for (var data in _ongoingBooking) {
          _confirmBooking.removeWhere((element) => element.id == data.id);
        }
      }
    }
    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModal> fetchCompletedBooking({bool notify = false}) async {
    final res = await _bookingService.fetchCompletedBooking(1);
    if (res.status == ApiStatus.success) {
      _completedBooking = res.data ?? [];
      //remove duplicate data in ongoing section
      if (_ongoingBooking.isNotEmpty) {
        for (var data in _completedBooking) {
          _ongoingBooking.removeWhere((element) => element.id == data.id);
        }
      }
    }

    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModal> fetchBookingDetailsById(int id,
      {bool fetchService = true, bool notify = false}) async {
    final res = await _bookingService.fetchBookingDetailsById(id);
    if (res.status == ApiStatus.success) {
      _bookingDetails = res.data;
      if (fetchService) {
        _bookedServices = [];
        ResponseModal res2;
        for (var element in _bookingDetails!.services) {
          res2 = await _fetchServicesById(
            element.serviceId.toString(),
            cityId: _bookingDetails!.cityId.toString(),
          );
          if (res2.status == ApiStatus.error) {
            res.status = res2.status;
            res.message = res2.message;
            _bookingDetails = null;
            _bookedServices = [];
            break;
          }
        }
      }
    }
    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModal> _fetchServicesById(String id, {required String cityId}) async {
    final res = await _categoryService.fetchServiceById(id, cityId);
    if (res.status == ApiStatus.success) {
      _bookedServices.add(res.data!);
    }
    return res;
  }

  Future<ResponseModal> acceptEstimateBill() async {
    return await _bookingService.acceptServiceBooking(_bookingDetails!.id);
  }

  Future<ResponseModal> rejectEstimateBill() async {
    return await _bookingService.rejectServiceBooking(_bookingDetails!.id);
  }

  Future<ResponseModal> payByCash() async {
    return await _bookingService.payBookingByCash(_bookingDetails!.id);
  }

  Future<ResponseModal> initPaytmPayment() async {
    final res = await _bookingService.generatePaytmToken(_bookingDetails!.id);
    if (res.status == ApiStatus.success) {
      try {
        var response = AllInOneSdk.startTransaction(
            liveMerchantId, res.data!.orderId, "1.0", res.data!.body.txnToken, "", false, true);
        response.then((value) {
          print(value);
        }).catchError((onError) {
          res.status = ApiStatus.error;
          if (onError is PlatformException) {
            res.message = "${onError.message} ${onError.details}";
          } else {
            res.message = onError.toString();
          }
        });
      } catch (err) {
        print(err.toString());
      }
    }
    return res;
  }

  Future<ResponseModal> reviewProviderService(ReviewModel data) async {
    return await _bookingService.reviewProviderService(data);
  }
}

Future<void> showBillingApprovalModal() async {
  await showDialog(
    context: Navigation.instance.navigatorKey.currentContext!,
    builder: (context) {
      return const BookingInvoiceView();
    },
  );
}
