import 'package:flutter/material.dart';
import 'package:just_order/shared/function/functions.dart';

/// FAB that opens the cart, badged with the current item count.
class CartFabButton extends StatelessWidget {
  final int itemCount;

  const CartFabButton({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text('$itemCount'),
      alignment: AlignmentDirectional.topStart,
      backgroundColor: Colors.white,
      textColor: const Color(0xFFE02C45),
      isLabelVisible: true,
      smallSize: 12,
      child: FloatingActionButton(
        onPressed: () => navigateTo(context, 'MyCartScreenRoute'),
        backgroundColor: const Color(0xFFE02C45),
        shape: const CircleBorder(side: BorderSide(color: Color(0xFFE02C45))),
        child: Image.asset('assets/icons/cart.png', height: 20, width: 20),
      ),
    );
  }
}
