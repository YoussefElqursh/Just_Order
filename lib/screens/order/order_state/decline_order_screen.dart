import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/enums/status.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/shared/function/functions.dart';

import '../../../shared/widget/order_widget/common_order_state_widget.dart';

class DeclineOrderScreen extends StatefulWidget {
  final List<Order> orders;
  final Map<String, Restaurant> restaurantMap;

  const DeclineOrderScreen(
      {super.key, required this.orders, required this.restaurantMap});

  static const String routeName = 'DeclineOrderScreenRoute';

  static Route route(
      {required List<Order> orders,
      required Map<String, Restaurant> restaurantMap}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) =>
          DeclineOrderScreen(orders: orders, restaurantMap: restaurantMap),
    );
  }

  @override
  State<DeclineOrderScreen> createState() => _DeclineOrderScreenState();
}

class _DeclineOrderScreenState extends State<DeclineOrderScreen> {

  List<Order> getFilteredTimeOrders(List<Order> orders) {
    final filtered = orders.where((order) {
      return [
        Status.declined,
        Status.cancelled,
        Status.autoDeclined,
      ].contains(order.status);
    }).toList();

    // Sort by deliveredAt or other relevant datetime field
    filtered.sort((a, b) => (b.deliveredDateTime ?? b.createdAt)
        .compareTo(a.deliveredDateTime ?? a.createdAt)); // Descending order

    return filtered;
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.declined_orders,
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
              padding:
                  const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
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
                  if (widget.orders.isEmpty) {
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
                              width: 250,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              AppLocalizations.of(context)!.no_declined_orders,
                              style: TextStyle(
                                color: state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
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
                        final order = getFilteredTimeOrders(widget.orders)[index];
                        final restaurant =
                            widget.restaurantMap[order.restaurantId] ??
                                Restaurant.empty();
                        return buildOrderStateWidget(
                          context: context,
                          width: 70,
                          order: order,
                          restaurant: restaurant,
                          state: state,
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 12.0,
                      ),
                      itemCount: widget.orders.length,
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
      },
    );
  }
}
