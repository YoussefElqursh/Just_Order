import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  static const String routeName = 'OrderScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const OrderScreen(),
    );
  }

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            shadowColor: Colors.grey,
            title: Text(
              AppLocalizations.of(context)!.orders,
              style: TextStyle(
                color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            // actions: [
            //   Padding(
            //     padding:
            //         const EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
            //     child: Container(
            //       width: 34,
            //       height: 34,
            //       clipBehavior: Clip.antiAlias,
            //       decoration: ShapeDecoration(
            //         color: const Color(0xFFF4F4F4),
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(8)),
            //       ),
            //       child: IconButton(
            //         onPressed: () {},
            //         icon: const Icon(
            //           Icons.notifications_none_outlined,
            //           color: Colors.black,
            //           size: 18,
            //         ),
            //       ),
            //     ),
            //   ),
            // ],
          ),
          body: Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              final orders = orderProvider.orders;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.pending_orders,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        'PendingOrderScreenRoute',
                                        arguments: [
                                          orders
                                              .where((order) =>
                                                  order.status ==
                                                  Status.pending)
                                              .toList(),
                                          restaurantMap
                                        ]);
                                  },
                                  child: Text(
                                    '${AppLocalizations.of(context)!.view_all} (${orders.where((order) => order.status == Status.pending).length})',
                                    style: const TextStyle(
                                      color: Color(0xFFE02C45),
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Builder(
                                builder: (context) {
                                  if (orders
                                      .where((order) =>
                                          order.status == Status.pending)
                                      .isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            setPhoto(
                                              kind: 0,
                                              path: 'assets/images/order.png',
                                              height: 100,
                                              width: 250,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!.no_pending_orders,
                                              style: TextStyle(
                                                color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
                                          buildOrderPendingStateWidget(
                                              context: context,
                                              width: 70,
                                              order: orders
                                                  .where((order) =>
                                                      order.status ==
                                                      Status.pending)
                                                  .toList()[index],
                                              restaurant: restaurantMap[orders
                                                      .where((order) =>
                                                          order.status ==
                                                          Status.pending)
                                                      .toList()[index]
                                                      .restaurantId] ??
                                                  Restaurant.empty(),
                                              onPressed: () {
                                                setState(() {
                                                  Order order = orders
                                                      .where((order) =>
                                                          order.status ==
                                                          Status.pending)
                                                      .toList()[index];
                                                  orderProvider
                                                      .updateOrderStatus(
                                                          order.orderId,
                                                          Status.cancelled);
                                                });
                                              }, state: state),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 12.0,
                                      ),
                                      itemCount: min(
                                          3,
                                          orders
                                              .where((order) =>
                                                  order.status ==
                                                  Status.pending)
                                              .length),
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFF4F4F4),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.preparing_orders,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        'PreparingOrderScreenRoute',
                                        arguments: [
                                          orders
                                              .where((order) =>
                                                  order.status ==
                                                  Status.preparing)
                                              .toList(),
                                          restaurantMap
                                        ]);
                                  },
                                  child: Text(
                                    '${AppLocalizations.of(context)!.view_all} (${orders.where((order) => order.status == Status.preparing).length})',
                                    style: const TextStyle(
                                      color: Color(0xFFE02C45),
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Builder(
                                builder: (context) {
                                  if (orders
                                      .where((order) =>
                                          order.status == Status.preparing)
                                      .isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            setPhoto(
                                              kind: 0,
                                              path: 'assets/images/order.png',
                                              height: 100,
                                              width: 250,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!.no_preparing_orders,
                                              style: TextStyle(
                                                color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
                                          buildOrderPreparingStateWidget(
                                              context: context,
                                              width: 70,
                                              order: orders
                                                  .where((order) =>
                                                      order.status ==
                                                      Status.preparing)
                                                  .toList()[index],
                                              restaurant: restaurantMap[orders
                                                      .where((order) =>
                                                          order.status ==
                                                          Status.preparing)
                                                      .toList()[index]
                                                      .restaurantId] ??
                                                  Restaurant.empty(), state: state),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 12.0,
                                      ),
                                      itemCount: min(
                                          3,
                                          orders
                                              .where((order) =>
                                                  order.status ==
                                                  Status.preparing)
                                              .length),
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFF4F4F4),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.on_way_orders,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        'OnWayOrderScreenRoute',
                                        arguments: [
                                          orders
                                              .where((order) =>
                                                  order.status ==
                                                  Status.onTheWay)
                                              .toList(),
                                          restaurantMap
                                        ]);
                                  },
                                  child: Text(
                                    '${AppLocalizations.of(context)!.view_all} (${orders.where((order) => order.status == Status.onTheWay).length})',
                                    style: const TextStyle(
                                      color: Color(0xFFE02C45),
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Builder(
                                builder: (context) {
                                  if (orders
                                      .where((order) =>
                                          order.status == Status.onTheWay)
                                      .isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            setPhoto(
                                              kind: 0,
                                              path: 'assets/images/order.png',
                                              height: 100,
                                              width: 250,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!.no_on_way_orders,
                                              style: TextStyle(
                                                color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
                                          buildOrderOnWayStateWidget(
                                              context: context,
                                              order: orders
                                                  .where((order) =>
                                                      order.status ==
                                                      Status.onTheWay)
                                                  .toList()[index],
                                              width: 70,
                                              restaurant: restaurantMap[orders
                                                      .where((order) =>
                                                          order.status ==
                                                          Status.onTheWay)
                                                      .toList()[index]
                                                      .restaurantId] ??
                                                  Restaurant.empty(), state: state),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 12.0,
                                      ),
                                      itemCount: min(
                                          3,
                                          orders
                                              .where((order) =>
                                                  order.status ==
                                                  Status.onTheWay)
                                              .length),
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFF4F4F4),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.delivered_orders,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        'DeliveredOrderScreenRoute',
                                        arguments: [
                                          orders
                                              .where((order) =>
                                                  order.status ==
                                                  Status.delivered)
                                              .toList(),
                                          restaurantMap
                                        ]);
                                  },
                                  child: Text(
                                    '${AppLocalizations.of(context)!.view_all} (${orders.where((order) => order.status == Status.delivered).length})',
                                    style: const TextStyle(
                                      color: Color(0xFFE02C45),
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Builder(
                                builder: (context) {
                                  if (orders
                                      .where((order) =>
                                          order.status == Status.delivered)
                                      .isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            setPhoto(
                                              kind: 0,
                                              path: 'assets/images/order.png',
                                              height: 100,
                                              width: 250,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!.no_delivered_orders,
                                              style: TextStyle(
                                                color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
                                                  .where((order) =>
                                                      order.status ==
                                                      Status.delivered && order.status ==
                                                          Status.finalized )
                                                  .toList()[index],
                                              width: 70,
                                              restaurant: restaurantMap[orders
                                                      .where((order) =>
                                                          order.status ==
                                                          Status.delivered && order.status ==
                                                              Status.finalized )
                                                      .toList()[index]
                                                      .restaurantId] ??
                                                  Restaurant.empty(), state: state),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 12.0,
                                      ),
                                      itemCount: min(
                                          3,
                                          orders
                                              .where((order) =>
                                                  order.status ==
                                                  Status.delivered && order.status ==
                                                      Status.finalized )
                                              .length),
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFF4F4F4),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.declined_orders,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        'DeclineOrderScreenRoute',
                                        arguments: [
                                          orders
                                              .where((order) =>
                                                  order.status ==
                                                      Status.declined ||
                                                  order.status ==
                                                      Status.autoDeclined)
                                              .toList(),
                                          restaurantMap
                                        ]);
                                  },
                                  child: Text(
                                    '${AppLocalizations.of(context)!.view_all} (${orders.where((order) => order.status == Status.declined || order.status == Status.autoDeclined).length})',
                                    style: const TextStyle(
                                      color: Color(0xFFE02C45),
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Builder(
                                builder: (context) {
                                  if (orders
                                      .where((order) =>
                                          order.status == Status.declined ||
                                          order.status == Status.autoDeclined)
                                      .isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            setPhoto(
                                              kind: 0,
                                              path: 'assets/images/order.png',
                                              height: 100,
                                              width: 250,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!.no_declined_orders,
                                              style: TextStyle(
                                                color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
                                      itemBuilder: (context, index) {
                                        final orderList = orders
                                            .where((order) =>
                                                order.status ==
                                                    Status.declined ||
                                                order.status ==
                                                    Status.autoDeclined)
                                            .toList();
                                        final order = orderList[index];
                                        return order.status ==
                                                Status.autoDeclined
                                            ? buildOrderAutoDeclinedStateWidget(
                                                context: context,
                                                order: order,
                                                width: 70,
                                                restaurant: restaurantMap[
                                                        order.restaurantId] ??
                                                    Restaurant.empty(), state: state)
                                            : buildOrderDeclinedStateWidget(
                                                context: context,
                                                order: order,
                                                width: 70,
                                                restaurant: restaurantMap[
                                                        order.restaurantId] ??
                                                    Restaurant.empty(), state: state);
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 12.0,
                                      ),
                                      itemCount: min(
                                          3,
                                          orders
                                              .where((order) =>
                                                  order.status ==
                                                      Status.declined ||
                                                  order.status ==
                                                      Status.autoDeclined)
                                              .length),
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
