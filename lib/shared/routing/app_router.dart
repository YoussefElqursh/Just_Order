import 'package:flutter/material.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/screens/1-splash_screen/splash_screen.dart';
import 'package:just_order/screens/2-select_your_place_screen/select_your_place_screen.dart';
import 'package:just_order/screens/3-home_screen/home_screen.dart';
import 'package:just_order/screens/4-restaurant_screen/restaurant_screen.dart';
import 'package:just_order/screens/5-meal_details_screen/meal_details_screen.dart';
import 'package:just_order/screens/6-order_screens/enter_card_data_screen.dart';
import 'package:just_order/screens/6-order_screens/my_cart_screen.dart';
import 'package:just_order/screens/6-order_screens/pay_method_screen.dart';
import 'package:just_order/screens/7-order_summary_screen/order_summary_screen.dart';
import 'package:just_order/screens/8-order_confirmed_screen/order_confirmed_screen.dart';
import 'package:just_order/screens/9-login_screen/login_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'SplashScreenRoute':
        return SplashScreen.route();
      case 'SelectYourPlaceRoute':
        return SelectYourPlace.route();
      case 'HomeScreenRoute':
        return HomeScreen.route();
      case 'MainLayoutRoute':
        return MainLayout.route();
      case 'RestaurantScreenRoute':
        return RestaurantScreen.route();
      case 'MealDetailsScreenRoute':
        return MealDetailsScreen.route();
      case 'MyCartScreenRoute':
        return MyCartScreen.route();
      case 'PayMethodScreenRoute':
        return PayMethodScreen.route();
      case 'EnterCardDataScreenRoute':
        return EnterCardDataScreen.route();
      case 'OrderSummaryScreenRoute':
        return OrderSummaryScreen.route();
      case 'OrderConfirmedScreenRoute':
        return OrderConfirmedScreen.route();
      case 'LoginScreenRoute':
        return LoginScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
      ),
    );
  }
}
