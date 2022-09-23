import 'package:flutter/material.dart';
import 'package:socspl/ui/views/auth/login_page_view.dart';
import 'package:socspl/ui/views/auth/otp_view.dart';
import 'package:socspl/ui/views/auth/signup_page_view.dart';
import 'package:socspl/ui/views/category/sub_category/sub_category_view.dart';
import 'package:socspl/ui/views/home/home_view.dart';
import 'package:socspl/ui/views/landing_page_view.dart';
import 'package:socspl/ui/views/search_page.dart';
import 'package:socspl/ui/views/splash_screen_view.dart';
import 'package:socspl/ui/widgets/dialogs/loading_dialog.dart';
import '../../../core/modal/category/category_modal.dart';
import '../../views/map/location_picker.dart';
import 'fade_transition_route.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return FadeTransitionPageRouteBuilder(page: const SplashScreenView());

    ///
    /// User Authentication Routes
    ///
    case '/login':
      return FadeTransitionPageRouteBuilder(page: const LoginPageView());
    case '/signup':
      return FadeTransitionPageRouteBuilder(page: const SignupPageView());

    case '/otp':
      return FadeTransitionPageRouteBuilder(page: OtpView());

    ///
    /// Home page routes
    ///
    case '/home':
      return FadeTransitionPageRouteBuilder(page: const HomeView());
    case '/sub-category':
      return FadeTransitionPageRouteBuilder(
        page: SubCategoryView(category: settings.arguments as CategoryModal),
      );

    case '/pick-location':
      return FadeTransitionPageRouteBuilder(
        page: const LocationPickerView(),
      );

    case '/search-location':
      return FadeTransitionPageRouteBuilder(
        page: SearchPage(text: settings.arguments as String),
      );

    case '/landing-view':
      return FadeTransitionPageRouteBuilder(page: const LandingPageView());

    case '/loadingDialog':
      return FadeTransitionPageRouteBuilder(page: LoadingDialog());

    default:
      return MaterialPageRoute(builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
          ),
          body: const Center(
            child: Text('404 Page not found'),
          ),
        );
      });
  }
}
