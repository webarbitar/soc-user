import 'dart:convert';

import 'package:socspl/core/modal/address/user_address_model.dart';
import 'package:socspl/core/modal/booking/booked_service_model.dart';
import 'package:socspl/core/modal/response_modal.dart';
import 'package:socspl/core/modal/service/service_booking.dart';
import 'package:socspl/core/modal/time_slot_model.dart';

import '../../enum/api_status.dart';
import '../../services/booking/booking_service.dart';
import '../base_view_modal.dart';

class BookingViewModel extends BaseViewModal {
  late BookingService _bookingService;

  set bookingService(BookingService value) {
    _bookingService = value;
  }

  UserAddressModel? _userAddress;

  List<TimeSlotModel> _timeSlots = [];

  UserAddressModel? get userAddress => _userAddress;

  List<TimeSlotModel> get timerSlots => _timeSlots;

  set userAddress(UserAddressModel? value) {
    _userAddress = value;
    notifyListeners();
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

  Future<ResponseModal> fetchPendingBooking() async {
    return await _bookingService.fetchPendingBooking(1);
  }

  Future<ResponseModal> fetchConfirmBooking() async {
    return await _bookingService.fetchConfirmedBooking(1);
  }

  Future<ResponseModal> fetchCompletedBooking() async {
    return await _bookingService.fetchCompletedBooking(1);
  }

  Future<ResponseModal> fetchBookingDetailsById(int id) async {
    return await _bookingService.fetchBookingDetailsById(id);
  }
}
