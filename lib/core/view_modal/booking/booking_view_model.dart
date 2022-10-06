import 'package:socspl/core/modal/address/user_address_model.dart';
import 'package:socspl/core/modal/response_modal.dart';
import 'package:socspl/core/modal/service/service_booking.dart';

import '../../enum/api_status.dart';
import '../../services/booking/booking_service.dart';
import '../base_view_modal.dart';

class BookingViewModel extends BaseViewModal {
  late BookingService _bookingService;

  set bookingService(BookingService value) {
    _bookingService = value;
  }

  UserAddressModel? _userAddress;

  UserAddressModel? get userAddress => _userAddress;

  set userAddress(UserAddressModel? value) {
    _userAddress = value;
    notifyListeners();
  }

  Future<ResponseModal> bookService(ServiceBooking data) async {
    final res = await _bookingService.bookServices(data.toMap());
    if (res.status == ApiStatus.success) {}
    return res;
  }
}
