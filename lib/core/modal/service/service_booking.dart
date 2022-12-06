import 'package:socspl/core/modal/address/user_address_model.dart';
import '../cart/cart_model.dart';

class ServiceBooking {
  UserAddressModel address;
  String date;
  String time;
  String paymentMethod;
  CartModel cart;

  ServiceBooking({
    required this.address,
    required this.date,
    required this.time,
    required this.paymentMethod,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      "address_id": address.id,
      "category_id": cart.categoryId,
      "date": date,
      "time": time,
      "payment_method": paymentMethod,
      "services": cart.items.map((e) => e.toBookingMap()).toList(),
    };
  }
}
