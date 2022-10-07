import 'package:socspl/core/modal/address/user_address_model.dart';
import '../cart/cart_model.dart';

class ServiceBooking {
  UserAddressModel address;
  String date;
  String time;
  CartModel cart;

  ServiceBooking({
    required this.address,
    required this.date,
    required this.time,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      "address_id": address.id,
      "category_id": cart.categoryId,
      "date": date,
      "time": time,
      "services": cart.items.map((e) => e.toBookingMap()).toList()
    };
  }
}
