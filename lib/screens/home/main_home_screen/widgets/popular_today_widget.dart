import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/screens/home/restaurant_screen/restaurant_screen.dart';
import 'package:just_order/shared/style/colors.dart';

Widget buildPopularTodayWidget({
  required BuildContext context,
  required Restaurant restaurant,
  required User user,
  required ThemeState state,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        'RestaurantScreenRoute',
        arguments: RestaurantScreenArguments(
          restaurant: restaurant,
          user: user,
        ),
      );
    },
    child: Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 155,
              height: 120,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.50,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFFEBEBEB),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: restaurant.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image_rounded),
                memCacheWidth: (MediaQuery.of(context).size.width *
                        MediaQuery.of(context).devicePixelRatio)
                    .round(),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            //   child: Container(
            //     width: 25,
            //     height: 25,
            //     clipBehavior: Clip.antiAlias,
            //     decoration: const ShapeDecoration(
            //       color: Color(0xFFF4F4F4),
            //       shape: CircleBorder(),
            //     ),
            //     child: IconButton(
            //       onPressed: () {},
            //       icon: const Icon(
            //         Icons.favorite_border,
            //         color: Colors.black,
            //         size: 10,
            //       ),
            //       style: const ButtonStyle(
            //         shape: WidgetStatePropertyAll(
            //           CircleBorder(),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
        SizedBox(
          width: 155,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: TextStyle(
                    color: state.themeMode == ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                Text(
                  'Sandwiches, Fast Food',
                  style: TextStyle(
                    color: state.themeMode == ThemeMode.light
                        ? const Color(0xFFAFAFAF)
                        : Colors.white,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.yellow.shade700, size: 12),
                    const SizedBox(width: 6),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '4.3',
                            style: TextStyle(
                              color: state.themeMode == ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const TextSpan(
                            text: ' (86)',
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
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildPopularTodayScreen({
  required BuildContext context,
  required Restaurant restaurant,
  required User user,
  required ThemeState state,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        'RestaurantScreenRoute',
        arguments: RestaurantScreenArguments(
          restaurant: restaurant,
          user: user,
        ),
      );
    },
    child: Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.50,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0xFFEBEBEB),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 120,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.50,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFEBEBEB),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: restaurant.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image_rounded),
              memCacheWidth: (MediaQuery.of(context).size.width *
                      MediaQuery.of(context).devicePixelRatio)
                  .round(),
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      color: state.themeMode == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Sandwiches, Fast Food',
                    style: TextStyle(
                      color: state.themeMode == ThemeMode.light
                          ? const Color(0xFFAFAFAF)
                          : Colors.white,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.yellow.shade700, size: 12),
                      const SizedBox(width: 6),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '4.3',
                              style: TextStyle(
                                color: state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(
                              text: ' (86)',
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
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
