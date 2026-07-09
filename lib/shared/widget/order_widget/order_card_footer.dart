import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/order_model.dart';

/// "Order ID: xxx" + total amount row, shared across every order-state card.
class OrderCardFooter extends StatelessWidget {
  const OrderCardFooter({
    super.key,
    required this.order,
    required this.state,
  });

  final Order order;
  final ThemeState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Order ID: ${order.orderId}',
            style: const TextStyle(
              color: Color(0xFF898888),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Text(
          'EGP ${order.totalAmount}',
          style: TextStyle(
            color:
                state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
