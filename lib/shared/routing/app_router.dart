import 'package:flutter/material.dart';
import 'package:just_order/screens/1-splash_screen/splash_screen.dart';
import 'package:just_order/screens/2-select_your_place/select_your_place.dart';
import 'package:just_order/screens/3-home_screen/home_screen.dart';
import 'package:just_order/screens/4-restaurant_screen/restaurant_screen.dart';
import 'package:just_order/screens/5-meal_details_screen/meal_details_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'SplashScreenRoute':
        return SplashScreen.route();
      case 'SelectYourPlaceRoute':
        return SelectYourPlace.route();
      case 'HomeScreenRoute':
        return HomeScreen.route();
      case 'RestaurantScreenRoute':
        return RestaurantScreen.route();
      case 'MealDetailsScreenRoute':
        return MealDetailsScreen.route();
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
