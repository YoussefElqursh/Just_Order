import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildOrderComponentsWidget(CartItem cartItem, ThemeState state) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage(cartItem.item.imageUrl),
            fit: BoxFit.cover,
          ),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Color(0xFFEBEBEB),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cartItem.item.name,
              style: TextStyle(
                color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 6.0),
            if (cartItem.extras != null && cartItem.extras!.isNotEmpty)
              ...cartItem.extras!.entries.map((entry) => Text(
                    '${entry.key}: EGP ${entry.value}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
            const SizedBox(height: 6.0),
            if (cartItem.size != null && cartItem.size!.isNotEmpty)
              ...cartItem.size!.entries.map((entry) => Text(
                    '${entry.key}: EGP ${entry.value}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
            const SizedBox(height: 6.0),
            Text(
              'EGP ${cartItem.totalPrice}',
              style: TextStyle(
                color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                fontSize: 8,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
      const Spacer(),
      Container(
        width: 29,
        height: 29,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: state.themeMode == ThemeMode.light ? const Color(0x0CE02C45) : const Color(0x5FE02C45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Center(
          child: Text(
            'x${cartItem.quantity}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE02C45),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    ],
  );
}
