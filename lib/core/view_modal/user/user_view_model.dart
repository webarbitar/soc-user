import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/response_modal.dart';
import 'package:socspl/core/modal/user/user_model.dart';

import '../../modal/address/user_address_model.dart';
import '../../services/user/user_service.dart';
import '../base_view_modal.dart';

class UserViewModel extends BaseViewModal {
  late UserService _userService;

  set userService(UserService value) {
    _userService = value;
  }

  UserModel? _user;

  final List<UserAddressModel> _userAddress = [];

  UserModel? get user => _user;

  List<UserAddressModel> get userAddress => _userAddress;

  Future<ResponseModal> fetchUserProfile({bool notify = false}) async {
    final res = await _userService.fetchUserProfile();
    if (res.status == ApiStatus.success) {
      _user = res.data;
    }
    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModal> fetchAddresses({bool notify = false}) async {
    final res = await _userService.fetchAddresses();
    if (res.status == ApiStatus.success) {
      _userAddress.clear();
      _userAddress.addAll(res.data ?? []);
    }
    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModal> deleteAddress(UserAddressModel data) async {
    final res = await _userService.deleteUserAddress(data.id);
    if (res.status == ApiStatus.success) {
      _userAddress.remove(data);
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

  Future<ResponseModal<UserAddressModel>> updateUserAddress(
      UserAddressModel oldData, UserAddressModel data) async {
    print(data.toMap());
    final res = await _userService.updateAddress(data.toMap());
    if (res.status == ApiStatus.success) {
      int index = _userAddress.indexOf(oldData);
      _userAddress[index] = res.data!;
    }
    return res;
  }

  Future<ResponseModal> updateUserProfile(String name, String email, String? image) async {
    final res = await _userService.updateUserProfile( image,{
      "id": "${_user?.id}",
      "name": name,
      "email": email,
      "mobile": "${_user?.mobile}",
      "vendor_id": "1",
      "city_id": "1",
    });
    if (res.status == ApiStatus.success) {
      await fetchUserProfile(notify: true);
    }
    return res;
  }
}
