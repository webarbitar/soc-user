import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/response_modal.dart';

import '../../modal/address/user_address_model.dart';
import '../../services/user/user_service.dart';
import '../base_view_modal.dart';

class UserViewModel extends BaseViewModal {
  late UserService _userService;

  set userService(UserService value) {
    _userService = value;
  }

  final List<UserAddressModel> _userAddress = [];

  List<UserAddressModel> get userAddress => _userAddress;

  Future<ResponseModal> fetchAddresses() async {
    final res = await _userService.fetchAddresses();
    if (res.status == ApiStatus.success) {
      _userAddress.clear();
      _userAddress.addAll(res.data ?? []);
    }
    return res;
  }

  Future<ResponseModal<UserAddressModel>> addUserAddress(UserAddressModel data) async {
    print(data.toMap());
    final res = await _userService.addAddress(data.toMap());
    if (res.status == ApiStatus.success) {
      _userAddress.add(res.data!);
    }
    return res;
  }
}
