import 'package:socspl/core/modal/category/add_on_modal.dart';
import 'package:socspl/core/modal/section/section_modal.dart';
import 'package:socspl/core/services/cart/cart_service.dart';

import '../../modal/cart/cart_model.dart';
import '../../modal/service/category_service_modal.dart';
import '../base_view_modal.dart';

class CartViewModel extends BaseViewModal {
  late CartService _cartService;

  set cartService(CartService value) {
    _cartService = value;
  }

  final List<CartModel> _carts = [];

  List<CartModel> get carts => _carts;

  bool get isNotEmpty => _carts.isNotEmpty;

  int getTotalPrice() {
    List<int> filter = _carts.map((e) => e.totalAmount).toList();
    if (filter.isNotEmpty) {
      return filter.reduce((value, element) => value + element);
    }
    return 0;
  }

  void addServiceToCart(CartModel cart) {
    _carts.add(cart);
    notifyListeners();
  }

  void updateServiceCart(CartModel cart) {
    int index = _carts.indexOf(cart);
    _carts[index] = cart;
    notifyListeners();
  }

  void increaseServiceQty(CartModel cart) {
    int index = _carts.indexOf(cart);
    int price = 0;
    if (cart.service.prices.isNotEmpty) {
      price = cart.service.prices.first.price;
    }
    cart.quantity++;
    cart.totalPrice += price;
    _carts[index] = cart;
    notifyListeners();
  }

  void decreaseServiceQty(CartModel cart) {
    // check if qty is greater than 1. If greater than 1 then decrease qty.
    // If qty is 1 or less then remove item from cart.
    if (cart.quantity > 1) {
      int index = _carts.indexOf(cart);
      int price = 0;
      if (cart.service.prices.isNotEmpty) {
        price = cart.service.prices.first.price;
      }
      cart.quantity--;
      cart.totalPrice -= price;
      _carts[index] = cart;
    } else {
      _carts.remove(cart);
    }
    notifyListeners();
  }

  CartModel? containsService(CategoryServiceModal service) {
    final flLis = _carts.where((element) => element.service.id == service.id);
    if (flLis.isNotEmpty) {
      return flLis.first;
    }
    return null;
  }

  void addAddOnServiceToCart(CategoryServiceModal data, AddOnModal addon) {
    var cart = containsService(data);
    print(cart);
    var cas = CartAdditionalService(
      addOnModal: addon,
      quantity: 1,
      totalPrice: addon.price,
    );
    if (cart != null) {
      cart.additionalServices = [...cart.additionalServices, cas];
    } else {
      _carts.add(CartModel(
        service: data,
        quantity: 0,
        totalPrice: 0,
        additionalServices: [cas],
      ));
    }
    notifyListeners();
  }

  void removeAddOnServiceToCart(CartModel cart, CartAdditionalService additionalService) {
    int index = _carts.indexOf(cart);
    if (cart.quantity == 0 && cart.additionalServices.length <= 1) {
      _carts.remove(cart);
    } else {
      _carts[index].additionalServices.remove(additionalService);
    }
    notifyListeners();
  }

  CartAdditionalService? containsAdditionalService(CategoryServiceModal service, AddOnModal addon) {
    final flLis = _carts.where((element) => element.service.id == addon.serviceId).toList();
    print(flLis);
    if (flLis.isNotEmpty) {
      CartModel crt = flLis.first;
      var filAdd = crt.additionalServices.where((element) => element.addOnModal.id == addon.id);
      if (filAdd.isNotEmpty) {
        return filAdd.first;
      }
    }
    return null;
  }

  void increaseAdditionalServiceQty(CartModel cart, CartAdditionalService additionalService) {
    int index = _carts.indexOf(cart);
    int index2 = cart.additionalServices.indexOf(additionalService);
    int price = 0;
    price = additionalService.addOnModal.price;
    additionalService.quantity++;
    additionalService.totalPrice += price;
    _carts[index].additionalServices[index2] = additionalService;
    notifyListeners();
  }

  void decreaseAdditionalServiceQty(CartModel cart, CartAdditionalService additionalService) {
    // check if qty is greater than 1. If greater than 1 then decrease qty.
    // If qty is 1 or less then remove item from cart.
    int index = _carts.indexOf(cart);

    if (additionalService.quantity > 1) {
      int index2 = cart.additionalServices.indexOf(additionalService);
      int price = 0;
      price = additionalService.addOnModal.price;
      additionalService.quantity--;
      additionalService.totalPrice -= price;
      _carts[index].additionalServices[index2] = additionalService;
    } else {
      _carts[index].additionalServices.remove(additionalService);
    }
    notifyListeners();
  }
}
