import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/enums/status.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/order_provider.dart';
import 'package:just_order/repository/order_repository/order_repository.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:just_order/shared/widget/common_order_state_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final OrderRepository _orderRepository = OrderRepository();
  Map<String, Restaurant> restaurantMap = {};
  User? user;
  bool _isOrdersLoaded = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserFromPreferences();
  }

  void _loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final loadedUser = User.fromJson(jsonDecode(userJson));
      setState(() {
        user = loadedUser;
      });
      _getOrders();
    }
  }

  void _getOrders() async {
    if (_isOrdersLoaded) return;
    _isOrdersLoaded = true;

    setState(() {
      _isLoading = true;
    });

    final fetchedOrders = await _orderRepository.getOrders(user?.userId ?? '');
    final restaurantIds =
        fetchedOrders.map((order) => order.restaurantId).toList();
    final fetchedRestaurants =
        await _orderRepository.getRestaurants(restaurantIds);

    setState(() {
      restaurantMap = {
        for (var restaurant in fetchedRestaurants)
          restaurant.restaurantId: restaurant
      };
      _isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Provider.of<OrderProvider>(context, listen: false)
        .listenToOrders(user?.userId ?? '');
  }

  List<Order> getFilteredOrders(List<Order> orders) {
    return orders.where((order) {
      return [
        Status.delivered,
        Status.declined,
        Status.cancelled,
        Status.autoDeclined,
        Status.finalized
      ].contains(order.status);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE02C45),
              ),
            ),
          )
        : Consumer<OrderProvider>(
            builder: (
              context,
              orderProvider,
              child,
            ) {
              final orders = getFilteredOrders(orderProvider.orders);

              return BlocBuilder<ThemeCubit, ThemeState>(
                builder: (
                  context,
                  state,
                ) {
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(
                        AppLocalizations.of(context)!.history,
                        style: TextStyle(
                          color: state.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Container(
                          width: 34,
                          height: 34,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF4F4F4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 18,
                            ),
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    body: orders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                setPhoto(
                                  kind: 0,
                                  path: 'assets/images/order.png',
                                  height: 100,
                                  width: 250,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  AppLocalizations.of(context)!
                                      .no_history_orders,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              final restaurant =
                                  restaurantMap[order.restaurantId] ??
                                      Restaurant.empty();
                              return buildOrderDeliveredStateWidget(
                                context: context,
                                order: order,
                                restaurant: restaurant,
                                width: 70,
                                state: state,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemCount: orders.length,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                          ),
                  );
                },
              );
            },
          );
  }
}
