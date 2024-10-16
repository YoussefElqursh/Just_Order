import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_order/models/enums/status.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserFromPreferences();
  }

  void _loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      setState(() {
        user = User.fromJson(jsonDecode(userJson));
      });
    }
    _getOrders();
  }

  void _getOrders() async {
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
    });
    // ignore: use_build_context_synchronously
    Provider.of<OrderProvider>(context, listen: false)
        .listenToOrders(user?.userId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, orderProvider, child) {
      final orders = orderProvider.orders;

      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
            child: Container(
              width: 34,
              height: 34,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFF4F4F4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(20),
            child: Builder(
              builder: (context) {
                if (orders
                    .where((order) => order.status == Status.pending)
                    .isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          setPhoto(
                            kind: 0,
                            path: 'assets/images/order.png',
                            height: 100,
                            width: 100,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'No History Orders',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return ListView.separated(
                    itemBuilder: (context, index) =>
                        buildOrderDeliveredStateWidget(
                            context: context,
                            order: orders
                                .where(
                                    (order) => order.status == Status.delivered)
                                .toList()[index],
                            width: 70,
                            restaurant: restaurantMap[orders
                                    .where((order) =>
                                        order.status == Status.delivered)
                                    .toList()[index]
                                    .restaurantId] ??
                                Restaurant.empty()),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12.0,
                    ),
                    itemCount: min(
                        3,
                        orders
                            .where((order) => order.status == Status.delivered)
                            .length),
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                  );
                }
              },
            ),
          ),
        ),
      );
    });
  }
}
