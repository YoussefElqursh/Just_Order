import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';

/// Shared card shell used by every order-state card: rounded border,
/// theme-aware background, fixed [height], an optional colored accent
/// strip on the left edge (used to show order urgency/progress), and an
/// optional [onTap] handler for the whole card.
class OrderCardContainer extends StatelessWidget {
  const OrderCardContainer({
    super.key,
    required this.height,
    required this.state,
    required this.child,
    this.accentColor,
    this.onTap,
  });

  final double height;
  final ThemeState state;
  final Widget child;
  final Color? accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: height,
      width: MediaQuery.sizeOf(context).width,
      decoration: ShapeDecoration(
        color: state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x4CAFAFAF),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (accentColor != null)
            Container(
              width: 5,
              height: height,
              decoration: ShapeDecoration(
                color: accentColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: accentColor!,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: child,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}
