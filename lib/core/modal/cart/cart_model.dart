import '../category/add_on_modal.dart';
import '../service/category_service_modal.dart';

class CartModel {
  CategoryServiceModal service;
  int quantity;
  int totalPrice;
  List<CartAdditionalService> additionalServices = [];

  CartModel({
    required this.service,
    required this.quantity,
    this.additionalServices = const [],
    required this.totalPrice,
  });

  int get totalQuantity => quantity + _getAdditionalServiceTotal();

  int _getAdditionalServiceTotal() {
    if (additionalServices.isNotEmpty) {
      return additionalServices.map((e) => e.quantity).reduce((value, element) => value + element);
    }
    return 0;
  }

  int get totalAmount => totalPrice + _getAdditionalServicePrice();

  int _getAdditionalServicePrice() {
    if (additionalServices.isNotEmpty) {
      return additionalServices
          .map((e) => e.totalPrice)
          .reduce((value, element) => value + element);
    }
    return 0;
  }

  Map<String, dynamic> toBookingMap() {
    return {
      "service_id": service.id,
      "quantity": quantity,
      "add_ons": additionalServices.map((e) => e.toMap()),
    };
  }
}

class CartAdditionalService {
  AddOnModal addOnModal;
  int quantity;
  int totalPrice;

  CartAdditionalService({
    required this.addOnModal,
    required this.quantity,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      "add_on_id": addOnModal.id,
      "quantity": quantity,
    };
  }
}
