import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/cart_item_model.dart';

Widget buildOrderCartWidget({
  required BuildContext context,
  required void Function()? onPressed1,
  required void Function()? onPressed2,
  required int counter,
  required CartItem cartItem,
  required ThemeState state,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        width: 70,
        height: 70,
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
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width - 134,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                cartItem.item.name,
                style: TextStyle(
                  color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 5.0),
              Text(
                cartItem.extras!.keys.join(', '),
                style: const TextStyle(
                  color: Color(0xFFAFAFAF),
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 5.0),
              Text(
                cartItem.size?.keys.join(', ') ?? '',
                style: const TextStyle(
                  color: Color(0xFFAFAFAF),
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'EGP ${cartItem.totalPrice}',
                    style: TextStyle(
                      color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: state.themeMode == ThemeMode.light ? const Color(0x0CE02C45) : const Color(0x5FE02C45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: IconButton(
                      onPressed: onPressed1,
                      icon: const Icon(
                        Icons.remove,
                        color: Color(0xFFE02C45),
                        size: 18,
                      ),
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text('$counter',
                      style: TextStyle(
                        color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  const SizedBox(width: 10.0),
                  Container(
                    width: 34,
                    height: 34,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: state.themeMode == ThemeMode.light ? const Color(0x0CE02C45) : const Color(0x5FE02C45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: IconButton(
                      onPressed: onPressed2,
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFFE02C45),
                        size: 18,
                      ),
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ],
  );
}
