import 'package:socspl/core/modal/address/user_address_model.dart';
import '../cart/cart_model.dart';

class ServiceBooking {
  UserAddressModel address;
  String date;
  String time;
  List<CartModel> carts = [];

  ServiceBooking({
    required this.address,
    required this.date,
    required this.time,
    required this.carts,
  });

  Map<String, dynamic> toMap() {
    return {
      "address_id": address.id,
      "category_id": 1,
      "date": date,
      "time": time,
      "services": carts.map((e) => e.toBookingMap())
    };
  }
}
