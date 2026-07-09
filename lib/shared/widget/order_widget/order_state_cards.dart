import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/shared/widget/common_button.dart';

import 'order_card_container.dart';
import 'order_card_footer.dart';
import 'order_card_header.dart';
import 'order_card_helpers.dart';
import 'order_qr_section.dart';

/// Default / generic order card (no accent strip, no action button).
Widget buildOrderStateWidget({
  required BuildContext context,
  required double width,
  required Order order,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  return OrderCardContainer(
    height: 96,
    state: state,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderCardHeader(order: order, restaurant: restaurant, state: state),
        const SizedBox(height: 12),
        OrderCardFooter(order: order, state: state),
      ],
    ),
  );
}

/// Order card shown while an order is awaiting confirmation. Shows a
/// "Cancel" button and a color-coded accent strip that reflects how close
/// the order is to timing out.
Widget buildOrderPendingStateWidget({
  required BuildContext context,
  required double width,
  required Order order,
  required Restaurant restaurant,
  required VoidCallback? onPressed,
  required ThemeState state,
}) {
  return OrderCardContainer(
    height: 146,
    state: state,
    accentColor: getOrderProgressColor(order),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderCardHeader(order: order, restaurant: restaurant, state: state),
        const SizedBox(height: 12),
        OrderCardFooter(order: order, state: state),
        const SizedBox(height: 4),
        buildMaterialButton(
          context: context,
          onPressed: onPressed,
          title: 'Cancel',
          height: 36,
        ),
      ],
    ),
  );
}

/// Order card shown while the restaurant is preparing the order. Same
/// layout as the default card, plus a color-coded accent strip.
Widget buildOrderPreparingStateWidget({
  required BuildContext context,
  required double width,
  required Order order,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  return OrderCardContainer(
    height: 96,
    state: state,
    accentColor: getOrderProgressColor(order),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderCardHeader(order: order, restaurant: restaurant, state: state),
        const SizedBox(height: 12),
        OrderCardFooter(order: order, state: state),
      ],
    ),
  );
}

/// Order card shown while the order is on its way. Tap to expand and reveal
/// a QR code + pickup/delivery code.
Widget buildOrderOnWayStateWidget({
  required BuildContext context,
  required Order order,
  required double width,
  required Restaurant restaurant,
  required ThemeState state,
  required VoidCallback? onTap,
  bool isExpanded = false,
}) {
  return OrderCardContainer(
    height: !isExpanded ? 106 : 200,
    state: state,
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        OrderCardHeader(order: order, restaurant: restaurant, state: state),
        OrderCardFooter(order: order, state: state),
        Visibility(
          visible: isExpanded,
          child: OrderQrSection(orderCode: order.orderCode, state: state),
        ),
      ],
    ),
  );
}

/// Order card shown once the order has been delivered.
Widget buildOrderDeliveredStateWidget({
  required BuildContext context,
  required Order order,
  required double width,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  return OrderCardContainer(
    height: 96,
    state: state,
    onTap: () => Navigator.pushNamed(
      context,
      'OrderDetailsScreenRoute',
      arguments: [order, restaurant],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderCardHeader(order: order, restaurant: restaurant, state: state),
        const SizedBox(height: 12),
        OrderCardFooter(order: order, state: state),
      ],
    ),
  );
}

/// Order card shown when the restaurant declined the order.
Widget buildOrderDeclinedStateWidget({
  required BuildContext context,
  required Order order,
  required double width,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  return OrderCardContainer(
    height: 96,
    state: state,
    onTap: () => Navigator.pushNamed(
      context,
      'OrderDetailsScreenRoute',
      arguments: [order, restaurant],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderCardHeader(order: order, restaurant: restaurant, state: state),
        const SizedBox(height: 12),
        OrderCardFooter(order: order, state: state),
      ],
    ),
  );
}

/// Order card shown when the order was automatically declined (e.g. it
/// timed out without a restaurant response).
Widget buildOrderAutoDeclinedStateWidget({
  required BuildContext context,
  required Order order,
  required double width,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  return OrderCardContainer(
    height: 96,
    state: state,
    onTap: () => Navigator.pushNamed(
      context,
      'OrderDetailsScreenRoute',
      arguments: [order, restaurant],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderCardHeader(order: order, restaurant: restaurant, state: state),
        const SizedBox(height: 12),
        OrderCardFooter(order: order, state: state),
      ],
    ),
  );
}
