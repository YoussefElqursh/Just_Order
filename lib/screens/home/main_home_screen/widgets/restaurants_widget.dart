import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/restaurant_model.dart';

Widget buildRestaurantsWidget({
  required BuildContext context,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, 'RestaurantScreenRoute',
          arguments: restaurant);
    },
    child: Row(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: ShapeDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  restaurant.imageUrl ?? 'https://via.placeholder.com/150'),
              fit: BoxFit.cover,
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1.50,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Color(0xFFEBEBEB),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - 155,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 160,
                  height: 27.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        restaurant.name,
                        style: TextStyle(
                          color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      // const Spacer(),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: const Icon(
                      //     Icons.favorite_border,
                      //     color: Colors.black,
                      //     size: 15,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const Text(
                  'Fast Food, Snacks, Beverages',
                  style: TextStyle(
                    color: Color(0xFFAFAFAF),
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow.shade700, size: 15),
                    const SizedBox(width: 6),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '4.8',
                            style: TextStyle(
                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: ' (79)',
                            style: TextStyle(
                              color: Color(0xFFAFAFAF),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: Color(0xFFE02C45),
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          restaurant.orderTimeOut.toString(),
                          style: TextStyle(
                            color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '•',
                      style: TextStyle(
                        color: Color(0xFFAFAFAF),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(width: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delivery_dining_outlined,
                          color: Color(0xFFE02C45),
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          (restaurant.deliveryFee != null)
                              ? 'EGP ${restaurant.deliveryFee}'
                              : 'Free',
                          style: TextStyle(
                            color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
