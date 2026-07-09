import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/shared/function/functions.dart';

/// Placeholder shown inside a section when there are no orders of that
/// status yet.
class OrderEmptyState extends StatelessWidget {
  const OrderEmptyState({
    super.key,
    required this.message,
    required this.state,
  });

  final String message;
  final ThemeState state;

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 15),
            Text(
              message,
              style: TextStyle(
                color:
                    state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
  }
}
