import 'package:flutter/material.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/invoice_model.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/screens/order/order_state/decline_order_screen.dart';
import 'package:just_order/screens/order/order_state/delivered_order_screen.dart';
import 'package:just_order/screens/order/order_state/on_way_order_screen.dart';
import 'package:just_order/screens/order/order_state/order_details_screen.dart';
import 'package:just_order/screens/order/order_state/pending_order_screen.dart';
import 'package:just_order/screens/order/order_state/preparing_order_screen.dart';
import 'package:just_order/screens/order/orders/order_screen.dart';
import 'package:just_order/screens/payment/payment_gateway_screen.dart';
import 'package:just_order/screens/sign_up/sign_up_screen.dart';
import 'package:just_order/screens/splash/splash_screen.dart';
import 'package:just_order/screens/account/my_profile_screen/profile_screen.dart';
import 'package:just_order/screens/QR/select_your_place_screen.dart';
import 'package:just_order/screens/home/main_home_screen/home_screen.dart';
import 'package:just_order/screens/home/restaurant_screen/restaurant_screen.dart';
import 'package:just_order/screens/home/meal_details_screen/meal_details_screen.dart';
import 'package:just_order/screens/payment/enter_card_data_screen.dart';
import 'package:just_order/screens/cart/my_cart_screen.dart';
import 'package:just_order/screens/payment/pay_method_screen.dart';
import 'package:just_order/screens/order/order_summary_screen.dart';
import 'package:just_order/screens/order/order_confirmed_screen.dart';
import 'package:just_order/screens/login/login_screen.dart';

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
        if (settings.arguments is Restaurant) {
          final restaurant = settings.arguments as Restaurant;
          return RestaurantScreen.route(restaurant);
        }
        return _errorRoute();
      case 'MealDetailsScreenRoute':
        if (settings.arguments is Item) {
          final args = settings.arguments as Item;
          return MealDetailsScreen.route(args);
        }
        return _errorRoute();
      case 'MyCartScreenRoute':
        return MyCartScreen.route();
      case 'PayMethodScreenRoute':
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final order = args['order'] as Order;
          final cartItems = args['cartItems'] as List<CartItem>;
          final invoice = args['invoice'] as Invoice;
          return PayMethodScreen.route(
            order: order,
            cartItems: cartItems,
            invoice: invoice,
          );
        }
        return _errorRoute();
      case 'EnterCardDataScreenRoute':
        return EnterCardDataScreen.route();
      case 'OrderSummaryScreenRoute':
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final order = args['order'] as Order;
          final cartItems = args['cartItems'] as List<CartItem>;
          final invoice = args['invoice'] as Invoice;
          return OrderSummaryScreen.route(
            order: order,
            cartItems: cartItems,
            invoice: invoice,
          );
        }
        return _errorRoute();
      case 'PaymentGatewayRoute':
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final String secretClient = args["clientSecret"];
          final Order order = args["order"];
          final List<CartItem> cartItems=args["cartItems"];
          final Invoice invoice= args["invoice"];
          return PaymentGatewayScreen.route(
          secretClient: secretClient,
          order: order,
          cartItems: cartItems,
          invoice: invoice);
        }
        return _errorRoute();
      case 'OrderConfirmedScreenRoute':
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final order = args['order'] as Order;
          final cartItems = args['cartItems'] as List<CartItem>;
          final invoice = args['invoice'] as Invoice;
          return OrderConfirmedScreen.route(
            order: order,
            cartItems: cartItems,
            invoice: invoice,
          );
        }
        return _errorRoute();
      case 'OrderScreenRoute':
        return OrderScreen.route();
      case 'PendingOrderScreenRoute':
      if (settings.arguments is List) {
        final args = settings.arguments as List;
        final orders = args[0] as List<Order>;
        final restaurantMap = args[1] as Map<String, Restaurant>;
        return PendingOrderScreen.route(orders: orders, restaurantMap: restaurantMap);
      }
      return _errorRoute();
      case 'PreparingOrderScreenRoute':
        if (settings.arguments is List) {
          final args = settings.arguments as List;
          final orders = args[0] as List<Order>;
          final restaurantMap = args[1] as Map<String, Restaurant>;
          return PreparingOrderScreen.route(orders: orders, restaurantMap: restaurantMap);
        }
        return _errorRoute();
      case 'OnWayOrderScreenRoute':
        if (settings.arguments is List) {
          final args = settings.arguments as List;
          final orders = args[0] as List<Order>;
          final restaurantMap = args[1] as Map<String, Restaurant>;
          return OnWayOrderScreen.route(orders: orders, restaurantMap: restaurantMap);
        }
        return _errorRoute();
      case 'DeliveredOrderScreenRoute':
        if (settings.arguments is List) {
          final args = settings.arguments as List;
          final orders = args[0] as List<Order>;
          final restaurantMap = args[1] as Map<String, Restaurant>;
          return DeliveredOrderScreen.route(orders: orders, restaurantMap: restaurantMap);
        }
        return _errorRoute();
      case 'DeclineOrderScreenRoute':
        if (settings.arguments is List) {
          final args = settings.arguments as List;
          final orders = args[0] as List<Order>;
          final restaurantMap = args[1] as Map<String, Restaurant>;
          return DeclineOrderScreen.route(orders: orders, restaurantMap: restaurantMap);
        }
        return _errorRoute();
      case 'OrderDetailsScreenRoute':
        if (settings.arguments is List<dynamic>) {
          final args = settings.arguments as List<dynamic>;
          final order = args[0] as Order;
          final restaurant = args[1] as Restaurant;
          return OrderDetailsScreen.route(order: order, restaurant: restaurant);
        }
        return _errorRoute();
      case 'LoginScreenRoute':
        return LoginScreen.route();
      case 'SignUpScreenRoute':
        return SignUpScreen.route();
      case 'ProfileScreenRoute':
        return ProfileScreen.route();
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