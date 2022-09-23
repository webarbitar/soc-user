import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';

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
  Provider(create: (_) => MapService()),
];
List<SingleChildWidget> dependentServices = [
  ChangeNotifierProxyProvider<UserService, AuthViewModal>(
    create: (_) => AuthViewModal(),
    update: (context, UserService userService, AuthViewModal? authModal) =>
        authModal!..userService = userService,
  ),
  ChangeNotifierProxyProvider<MapService, HomeViewModal>(
    create: (_) => HomeViewModal(),
    update: (context, MapService mapService, HomeViewModal? homeModal) =>
        homeModal!..mapService = mapService,
  ),
];
List<SingleChildWidget> uiConsumableServices = [];
