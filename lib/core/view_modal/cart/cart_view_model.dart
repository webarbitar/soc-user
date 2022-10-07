import '../../modal/cart/cart_model.dart';
import '../../modal/category/add_on_modal.dart';
import '../../modal/service/category_service_modal.dart';
import '../../services/cart/cart_service.dart';
import '../base_view_modal.dart';

class CartViewModel extends BaseViewModal {
  late CartService _cartService;

  set cartService(CartService value) {
    _cartService = value;
  }

  final List<CartModel> _carts = [];

  int? _categoryId;

  CartModel? _currentCart;

  int? _currentCartIndex;

  CartModel get currentCart => _currentCart!;

  bool get isNotEmpty => _carts.isNotEmpty;

  // Determine whether cart with determine category id is present or not
  bool get isPresent {
    return _currentCart != null;
  }

  int get totalPrice {
    assert(_currentCart != null, "Cart module is not initialized or no item in the cart");
    return _currentCart!.totalPrices;
  }

  void initCartModule(int categoryId) {
    _categoryId = categoryId;

    // Filter out the current category cart items if present
    var filterCart = _carts.where((element) => element.categoryId == _categoryId);
    if (filterCart.isNotEmpty) {
      _currentCart = filterCart.first;
      _currentCartIndex = _carts.indexOf(_currentCart!);
    } else {
      _currentCart = null;
      _currentCartIndex = null;
    }
  }

  void addServiceToCart(CartItem item) {
    if (_currentCart != null) {
      _currentCart!.items = [..._currentCart!.items, item];
    } else {
      _carts.add(CartModel(categoryId: _categoryId!, items: [item]));
    }
    _updateCart();
    notifyListeners();
  }

  // void updateServiceCart(CartModel cart) {
  //   int index = _carts.indexOf(cart);
  //   _carts[index] = cart;
  //   notifyListeners();
  // }

  void _updateCart() {
    // update current cart data in [CartModel] list i.e _cart
    initCartModule(_categoryId!);
    if (_currentCartIndex != null) {
      _carts[_currentCartIndex!] = _currentCart!;
    }
  }

  void increaseServiceQty(CartItem cart) {
    int index = _currentCart!.items.indexOf(cart);
    int price = 0;
    if (cart.service.prices.isNotEmpty) {
      price = cart.service.prices.first.price;
    }
    cart.quantity++;
    cart.totalPrice += price;
    _currentCart!.items[index] = cart;
    _updateCart();
    notifyListeners();
  }

  void decreaseServiceQty(CartItem cart) {
    // check if qty is greater than 1. If greater than 1 then decrease qty.
    // If qty is 1 or less then remove item from cart.
    print(cart);
    if (cart.quantity > 1) {
      int index = _currentCart!.items.indexOf(cart);
      int price = 0;
      if (cart.service.prices.isNotEmpty) {
        price = cart.service.prices.first.price;
      }
      cart.quantity--;
      cart.totalPrice -= price;
      _currentCart!.items[index] = cart;
    } else {
      // if [CartItem] length is less or equal to one remove [CartModel] instance.
      // As for other case remove [CartItem] instance as it also has quantity of 1.
      if (_currentCart!.items.length <= 1) {
        print("remove main");
        _carts.remove(_currentCart);
      } else {
        _currentCart!.items.remove(cart);
        print("remove items");
      }
    }
    _updateCart();
    notifyListeners();
  }

  CartItem? containsService(CategoryServiceModal service) {
    final flLis = _currentCart?.items.where((element) => element.service.id == service.id) ?? [];
    if (flLis.isNotEmpty) {
      return flLis.first;
    }
    return null;
  }

  void addAddOnServiceToCart(CategoryServiceModal data, AddOnModal addon) {
    var cart = containsService(data);
    var cas = AdditionalCartItem(
      addOnModal: addon,
      quantity: 1,
      totalPrice: addon.price,
    );
    if (cart != null) {
      cart.additionalItem = [...cart.additionalItem, cas];
    } else {
      addServiceToCart(
        CartItem(
          service: data,
          quantity: 0,
          totalPrice: 0,
          additionalItem: [cas],
        ),
      );
    }
    _updateCart();
    notifyListeners();
  }

  void removeAddOnServiceFromCart(CartItem cart, AdditionalCartItem additionalItem) {
    int index = _currentCart!.items.indexOf(cart);
    if (cart.quantity == 0 && cart.additionalItem.length <= 1) {
      _currentCart!.items.remove(cart);
    } else {
      _currentCart!.items[index].additionalItem.remove(additionalItem);
    }
    _updateCart();
    notifyListeners();
  }

  AdditionalCartItem? containsAdditionalService(CategoryServiceModal service, AddOnModal addon) {
    final flLis =
        _currentCart?.items.where((element) => element.service.id == addon.serviceId) ?? [];
    print(flLis);
    if (flLis.isNotEmpty) {
      CartItem crt = flLis.first;
      var filAdd = crt.additionalItem.where((element) => element.addOnModal.id == addon.id);
      if (filAdd.isNotEmpty) {
        return filAdd.first;
      }
    }
    return null;
  }

  void increaseAdditionalServiceQty(CartItem cart, AdditionalCartItem additionalItem) {
    int index = _currentCart!.items.indexOf(cart);
    int index2 = cart.additionalItem.indexOf(additionalItem);
    int price = 0;
    price = additionalItem.addOnModal.price;
    additionalItem.quantity++;
    additionalItem.totalPrice += price;
    _currentCart!.items[index].additionalItem[index2] = additionalItem;
    _updateCart();
    notifyListeners();
  }

  void decreaseAdditionalServiceQty(CartItem cart, AdditionalCartItem additionalItem) {
    // check if qty is greater than 1. If greater than 1 then decrease qty.
    // If qty is 1 or less then remove item from cart.
    int index = _currentCart!.items.indexOf(cart);

    if (additionalItem.quantity > 1) {
      int index2 = cart.additionalItem.indexOf(additionalItem);
      int price = 0;
      price = additionalItem.addOnModal.price;
      additionalItem.quantity--;
      additionalItem.totalPrice -= price;
      _currentCart!.items[index].additionalItem[index2] = additionalItem;
    } else {
      _currentCart!.items[index].additionalItem.remove(additionalItem);
    }
    _updateCart();
    notifyListeners();
  }
}
