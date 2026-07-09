import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/screens/order/widgets/order_status_section.dart';
import 'package:provider/provider.dart';

import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/core/storage/storage_service.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/models/enums/status.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/order_provider.dart';
import 'package:just_order/repository/order_repository/order_repository.dart';
import 'package:just_order/shared/widget/order_widget/common_order_state_widget.dart';


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

  Map<String, Restaurant> _restaurantMap = {};
  User? _user;

  // NOTE: this mirrors the original behavior, where a single flag toggles
  // the QR/code panel for every "on the way" card at once (tapping any one
  // card expands/collapses all of them together). If each card should
  // expand independently, track the expanded order's id instead of a bool.
  bool _isOnWayCardExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadUserFromPreferences();
  }

  Future<void> _loadUserFromPreferences() async {
    final prefs = StorageService.instance;
    final userJson = prefs.getString('user');
    if (userJson != null) {
      setState(() {
        _user = User.fromJson(jsonDecode(userJson));
      });
    }
    await _loadOrders();
  }

  Future<void> _loadOrders() async {
    final fetchedOrders =
        await _orderRepository.getOrders(_user?.userId ?? '');
    final restaurantIds =
        fetchedOrders.map((order) => order.restaurantId).toList();
    final fetchedRestaurants =
        await _orderRepository.getRestaurants(restaurantIds);

    setState(() {
      _restaurantMap = {
        for (final restaurant in fetchedRestaurants)
          restaurant.restaurantId: restaurant,
      };
    });

    if (!mounted) return;
    Provider.of<OrderProvider>(context, listen: false)
        .listenToOrders(_user?.userId ?? '');
  }

  void _cancelOrder(Order order) {
    Provider.of<OrderProvider>(context, listen: false)
        .updateOrderStatus(order.orderId, Status.cancelled);
  }

  void _toggleOnWayCard() {
    setState(() => _isOnWayCardExpanded = !_isOnWayCardExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              return _buildBody(context, state, orderProvider.orders);
            },
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeState state) {
    return AppBar(
      centerTitle: true,
      shadowColor: Colors.grey,
      leading: const SizedBox.shrink(),
      title: Text(
        AppLocalizations.of(context)!.orders,
        style: TextStyle(
          color:
              state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeState state,
    List<Order> orders,
  ) {
    final l10n = AppLocalizations.of(context)!;

    final pendingOrders =
        orders.where((o) => o.status == Status.pending).toList();
    final preparingOrders =
        orders.where((o) => o.status == Status.preparing).toList();
    final onWayOrders =
        orders.where((o) => o.status == Status.onTheWay).toList();
    final deliveredOrders = orders
        .where((o) => o.status == Status.delivered || o.status == Status.finalized)
        .toList();
    final declinedOrders = orders
        .where((o) => o.status == Status.declined || o.status == Status.autoDeclined)
        .toList();

    List<Order> getFilteredTimeOrders(List<Order> orders) {
      // Sort by deliveredAt or other relevant datetime field
      orders.sort((a, b) => (b.deliveredDateTime ?? b.createdAt)
          .compareTo(a.deliveredDateTime ?? a.createdAt)); // Descending order

      return orders;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderStatusSection(
              title: l10n.pending_orders,
              viewAllLabel: l10n.view_all,
              emptyMessage: l10n.no_pending_orders,
              orders: pendingOrders,
              restaurantMap: _restaurantMap,
              state: state,
              onViewAll: () => Navigator.of(context).pushNamed(
                'PendingOrderScreenRoute',
                arguments: [pendingOrders, _restaurantMap],
              ),
              itemBuilder: (context, order, restaurant, index) {
                final order = getFilteredTimeOrders(pendingOrders)[index];
                return buildOrderPendingStateWidget(
                context: context,
                width: 70,
                order: order,
                restaurant: restaurant,
                state: state,
                onPressed: () => _cancelOrder(order),
              );
              },
            ),
            const Divider(color: Color(0xFFF4F4F4)),
            OrderStatusSection(
              title: l10n.preparing_orders,
              viewAllLabel: l10n.view_all,
              emptyMessage: l10n.no_preparing_orders,
              orders: preparingOrders,
              restaurantMap: _restaurantMap,
              state: state,
              onViewAll: () => Navigator.of(context).pushNamed(
                'PreparingOrderScreenRoute',
                arguments: [preparingOrders, _restaurantMap],
              ),
              itemBuilder: (context, order, restaurant, index) {
                final order = getFilteredTimeOrders(preparingOrders)[index];
                return buildOrderPreparingStateWidget(
                context: context,
                width: 70,
                order: order,
                restaurant: restaurant,
                state: state,
              );
              },
            ),
            const Divider(color: Color(0xFFF4F4F4)),
            OrderStatusSection(
              title: l10n.on_way_orders,
              viewAllLabel: l10n.view_all,
              emptyMessage: l10n.no_on_way_orders,
              orders: onWayOrders,
              restaurantMap: _restaurantMap,
              state: state,
              onViewAll: () => Navigator.of(context).pushNamed(
                'OnWayOrderScreenRoute',
                arguments: [onWayOrders, _restaurantMap],
              ),
              itemBuilder: (context, order, restaurant, index) {
                final order = getFilteredTimeOrders(onWayOrders)[index];
                return buildOrderOnWayStateWidget(
                context: context,
                order: order,
                width: 70,
                restaurant: restaurant,
                state: state,
                isExpanded: _isOnWayCardExpanded,
                onTap: _toggleOnWayCard,
              );
              },
            ),
            const Divider(color: Color(0xFFF4F4F4)),
            OrderStatusSection(
              title: l10n.delivered_orders,
              viewAllLabel: l10n.view_all,
              emptyMessage: l10n.no_delivered_orders,
              orders: deliveredOrders,
              restaurantMap: _restaurantMap,
              state: state,
              onViewAll: () => Navigator.of(context).pushNamed(
                'DeliveredOrderScreenRoute',
                arguments: [deliveredOrders, _restaurantMap],
              ),
              itemBuilder: (context, order, restaurant, index) {
                final order = getFilteredTimeOrders(deliveredOrders)[index];
                return buildOrderDeliveredStateWidget(
                context: context,
                order: order,
                width: 70,
                restaurant: restaurant,
                state: state,
              );
              },
            ),
            const Divider(color: Color(0xFFF4F4F4)),
            OrderStatusSection(
              title: l10n.declined_orders,
              viewAllLabel: l10n.view_all,
              emptyMessage: l10n.no_declined_orders,
              orders: declinedOrders,
              restaurantMap: _restaurantMap,
              state: state,
              onViewAll: () => Navigator.of(context).pushNamed(
                'DeclineOrderScreenRoute',
                arguments: [declinedOrders, _restaurantMap],
              ),
              itemBuilder: (context, order, restaurant, index) {
                final order = getFilteredTimeOrders(declinedOrders)[index];
                return order.status == Status.autoDeclined
                      ? buildOrderAutoDeclinedStateWidget(
                          context: context,
                          order: order,
                          width: 70,
                          restaurant: restaurant,
                          state: state,
                        )
                      : buildOrderDeclinedStateWidget(
                          context: context,
                          order: order,
                          width: 70,
                          restaurant: restaurant,
                          state: state,
                        );
              },
            ),
          ],
        ),
      ),
    );
  }
}
