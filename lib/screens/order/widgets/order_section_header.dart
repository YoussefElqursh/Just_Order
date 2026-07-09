import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';

/// Section title on the left, tappable "View all (count)" link on the
/// right. Used at the top of every status section on the Orders screen.
class OrderSectionHeader extends StatelessWidget {
  const OrderSectionHeader({
    super.key,
    required this.title,
    required this.itemCount,
    required this.viewAllLabel,
    required this.state,
    required this.onViewAll,
  });

  final String title;
  final int itemCount;
  final String viewAllLabel;
  final ThemeState state;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final textColor =
        state.themeMode == ThemeMode.light ? Colors.black : Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            '$viewAllLabel ($itemCount)',
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
    );
  }
}
