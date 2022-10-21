import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:socspl/core/services/category/category_service.dart';
import 'package:socspl/core/view_modal/booking/booking_view_model.dart';
import 'package:socspl/core/view_modal/cart/cart_view_model.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/core/view_modal/user/user_view_model.dart';

import 'core/services/booking/booking_service.dart';
import 'core/services/cart/cart_service.dart';
import 'core/services/home/home_service.dart';
import 'core/services/map/map_service.dart';
import 'core/services/user/user_service.dart';
import 'core/view_modal/auth/auth_view_modal.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableServices
];

List<SingleChildWidget> independentServices = [
  Provider(create: (_) => HomeService()),
  Provider(create: (_) => UserService()),
  Provider(create: (_) => CategoryService()),
  Provider(create: (_) => MapService()),
  Provider(create: (_) => CartService()),
  Provider(create: (_) => BookingService()),
];
List<SingleChildWidget> dependentServices = [
  ChangeNotifierProxyProvider<UserService, AuthViewModal>(
    create: (_) => AuthViewModal(),
    update: (context, UserService userService, AuthViewModal? authModal) =>
        authModal!..userService = userService,
  ),
  ChangeNotifierProxyProvider<UserService, UserViewModel>(
    create: (_) => UserViewModel(),
    update: (context, UserService userService, UserViewModel? userModel) =>
        userModel!..userService = userService,
  ),
  ChangeNotifierProxyProvider<MapService, HomeViewModal>(
    create: (_) => HomeViewModal(),
    update: (context, MapService mapService, HomeViewModal? homeModal) =>
        homeModal!..mapService = mapService,
  ),
  ChangeNotifierProxyProvider2<CartService, CategoryService, CartViewModel>(
    create: (_) => CartViewModel(),
    update: (context, CartService cartService, CategoryService categoryService,
            CartViewModel? cartModel) =>
        cartModel!
          ..cartService = cartService
          ..categoryService = categoryService,
  ),
  ChangeNotifierProxyProvider<BookingService, BookingViewModel>(
    create: (_) => BookingViewModel(),
    update: (context, BookingService bookingService, BookingViewModel? bookingModel) =>
        bookingModel!..bookingService = bookingService,
  ),
];
List<SingleChildWidget> uiConsumableServices = [];
