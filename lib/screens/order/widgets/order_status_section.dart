import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';

import 'order_empty_state.dart';
import 'order_section_header.dart';

/// One "status group" block on the Orders screen: title + "view all" link,
/// then either an empty-state placeholder or a capped, scrollable list of
/// order cards built via [itemBuilder].
///
/// This is what removes the duplicated title/view-all/empty-state/list
/// boilerplate that used to be repeated for pending, preparing, on-the-way,
/// delivered, and declined orders.
class OrderStatusSection extends StatelessWidget {
  const OrderStatusSection({
    super.key,
    required this.title,
    required this.viewAllLabel,
    required this.emptyMessage,
    required this.orders,
    required this.restaurantMap,
    required this.state,
    required this.itemBuilder,
    required this.onViewAll,
    this.maxItems = 3,
  });

  final String title;
  final String viewAllLabel;
  final String emptyMessage;
  final List<Order> orders;
  final Map<String, Restaurant> restaurantMap;
  final ThemeState state;
  final VoidCallback onViewAll;
  final int maxItems;

  /// Builds a single order card. [restaurant] is already resolved from
  /// [restaurantMap] (falling back to [Restaurant.empty]) so callers never
  /// need to touch the map themselves.
  final Widget Function(
    BuildContext context,
    Order order,
    Restaurant restaurant,
    int index,
  ) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderSectionHeader(
            title: title,
            itemCount: orders.length,
            viewAllLabel: viewAllLabel,
            state: state,
            onViewAll: onViewAll,
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: orders.isEmpty
                ? OrderEmptyState(message: emptyMessage, state: state)
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final restaurant =
                          restaurantMap[order.restaurantId] ?? Restaurant.empty();
                      return itemBuilder(context, order, restaurant, index);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12.0),
                    itemCount:
                        orders.length > maxItems ? maxItems : orders.length,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                  ),
          ),
        ],
      ),
    );
  }
}
