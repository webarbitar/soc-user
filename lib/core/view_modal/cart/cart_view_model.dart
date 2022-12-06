import 'package:socspl/core/enum/api_status.dart';
import 'package:socspl/core/modal/category/category_modal.dart';

import '../../modal/cart/cart_model.dart';
import '../../modal/category/add_on_modal.dart';
import '../../modal/service/category_service_modal.dart';
import '../../services/cart/cart_service.dart';
import '../../services/category/category_service.dart';
import '../../utils/storage/storage.dart';
import '../base_view_modal.dart';

class CartViewModel extends BaseViewModal {
  late CartService _cartService;
  late CategoryService _categoryService;

  set cartService(CartService value) {
    _cartService = value;
  }

  set categoryService(CategoryService value) {
    _categoryService = value;
  }

  final List<CartModel> _carts = [];

  CategoryModal? _category;

  CartModel? _currentCart;

  int? _currentCartIndex;

  List<CartModel> get carts => _carts;

  CartModel? get currentCart => _currentCart;

  bool get isNotEmpty => _carts.isNotEmpty;

  // Determine whether cart with determine category id is present or not
  bool get isPresent {
    return _currentCart != null;
  }

  int get totalPrice {
    assert(_currentCart != null, "Cart module is not initialized or no item in the cart");
    return _currentCart!.totalPrices;
  }

  String? get hasValidMinOrderPrice {
    assert(_currentCart != null, "Cart module is not initialized or no item in the cart");
    if (_currentCart!.minPrice > 0) {
      if (_currentCart!.minPrice > totalPrice) {
        return "Min order price is ${_currentCart!.minPrice}";
      }
    }
    return null;
  }

  void initLocalCartModule(String cityId, List<CategoryModal> cateList) async {
    final carts = Storage.instance.carts;
    print(carts);
    if (carts.isNotEmpty) {
      for (var e in carts) {
        final flCate = cateList.where((element) => element.id == e["categoryId"]).toList();
        if (flCate.isNotEmpty) {
          List<CartItem> items = await parseCartItem(e["items"] ?? [], cityId);
          _carts.add(CartModel(
            categoryId: e["categoryId"],
            minPrice: flCate.first.minOrderPrice ?? 0,
            items: items,
          ));
        }
      }
    }
    notifyListeners();
  }

  Future<List<CartItem>> parseCartItem(List list, String cityId) async {
    List<CartItem> items = [];
    for (var e in list) {
      List<AdditionalCartItem> addCList = [];

      final res = await _categoryService.fetchServiceById("${e["serviceId"]}", cityId);
      if (res.status == ApiStatus.success) {
        CategoryServiceModal flService = res.data!;

        // Parsing additional items data from map
        if ((e["additionalItem"] as List).isNotEmpty) {
          addCList = parseAdditionalCartItem(flService, e["additionalItem"] ?? []);
        }

        // calculating service total price
        int servTotal = flService.prices.first.price * (e["quantity"] as int);

        items.add(CartItem(
          service: flService,
          quantity: e["quantity"],
          totalPrice: servTotal,
          additionalItem: addCList,
        ));
      }
    }
    return items;
  }

  List<AdditionalCartItem> parseAdditionalCartItem(CategoryServiceModal data, List list) {
    return list.map((ade) {
      print(list);
      print(data.addOns.map((e) => e.id));
      // Filter addon data from list
      var flAddon = data.addOns.singleWhere((element) => element.id == ade["addonId"]);

      // calculating addon total price
      int adTotal = flAddon.price * (ade["quantity"] as int);

      return AdditionalCartItem(
        addOnModal: flAddon,
        quantity: ade["quantity"],
        totalPrice: adTotal,
      );
    }).toList();
  }

  void initCartModule(CategoryModal category) {
    _category = category;

    // Filter out the current category cart items if present
    var filterCart = _carts.where((element) => element.categoryId == category.id);
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
      _carts.add(
        CartModel(
          categoryId: _category!.id,
          minPrice: _category!.minOrderPrice ?? 0,
          items: [item],
        ),
      );
    }
    _updateCart();
    notifyListeners();
  }

  void clearCartData() {
    _carts.removeAt(_currentCartIndex!);
    _carts.remove(_currentCart);
    _currentCart = null;
    _currentCartIndex = null;
    Storage.instance.updateLocalCart(_carts);
    notifyListeners();
  }

  // void updateServiceCart(CartModel cart) {
  //   int index = _carts.indexOf(cart);
  //   _carts[index] = cart;
  //   notifyListeners();
  // }

  void _updateCart() {
    // update current cart data in [CartModel] list i.e _cart
    initCartModule(_category!);
    if (_currentCartIndex != null) {
      _carts[_currentCartIndex!] = _currentCart!;
    }
    Storage.instance.updateLocalCart(_carts);
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

  void removeCart(CartModel cart) {
    _carts.remove(cart);
    Storage.instance.updateLocalCart(_carts);
    notifyListeners();
  }
}
