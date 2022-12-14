import '../category/add_on_modal.dart';
import '../service/category_service_modal.dart';

class CartModel {
  int categoryId;
  int minPrice;
  List<CartItem> items;

  CartModel({
    required this.categoryId,
    required this.minPrice,
    this.items = const [],
  });

  int get totalQuantity {
    if (items.isNotEmpty) {
      return items.map((e) => e.totalQuantity).reduce((value, element) => value + element);
    }
    return 0;
  }

  int get totalPrices {
    if (items.isNotEmpty) {
      return items.map((e) => e.totalAmount).reduce((value, element) => value + element);
    }
    return 0;
  }

  Map<String, dynamic> toLocalStorageMap() {
    return {
      "categoryId": categoryId,
      "minPrice": minPrice,
      "items": items.map((e) => e.toLocalStorageMap()).toList(),
    };
  }
}

class CartItem {
  CategoryServiceModal service;
  int quantity;
  int totalPrice;
  List<AdditionalCartItem> additionalItem = [];

  CartItem({
    required this.service,
    required this.quantity,
    this.additionalItem = const [],
    required this.totalPrice,
  });

  int get totalQuantity => quantity + _getAdditionalServiceTotal();

  int _getAdditionalServiceTotal() {
    if (additionalItem.isNotEmpty) {
      return additionalItem.map((e) => e.quantity).reduce((value, element) => value + element);
    }
    return 0;
  }

  int get totalAmount => totalPrice + _getAdditionalServicePrice();

  int _getAdditionalServicePrice() {
    if (additionalItem.isNotEmpty) {
      return additionalItem.map((e) => e.totalPrice).reduce((value, element) => value + element);
    }
    return 0;
  }

  Map<String, dynamic> toBookingMap() {
    return {
      "service_id": service.id,
      "quantity": quantity,
      "add_ons": additionalItem.map((e) => e.toMap()).toList(),
    };
  }

  Map<String, dynamic> toLocalStorageMap() {
    return {
      "serviceId": service.id,
      "quantity": quantity,
      "totalPrice": totalPrice,
      "additionalItem": additionalItem.map((e) => e.toLocalStorageMap()).toList(),
    };
  }
}

class AdditionalCartItem {
  AddOnModal addOnModal;
  int quantity;
  int totalPrice;

  AdditionalCartItem({
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

  Map<String, dynamic> toLocalStorageMap() {
    return {
      "addonId": addOnModal.id,
      "quantity": quantity,
    };
  }
}
