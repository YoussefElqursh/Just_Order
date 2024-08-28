import 'package:flutter/material.dart';
import 'package:just_order/shared/function/functions.dart';

Widget buildPopularTodayWidget({
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      navigateTo(context, 'RestaurantScreenRoute');
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
                image: DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/155x120"),
                  fit: BoxFit.cover,
                ),
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10.0),
              child: Container(
                width: 25,
                height: 25,
                clipBehavior: Clip.antiAlias,
                decoration: const ShapeDecoration(
                  color: Color(0xFFF4F4F4),
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                    size: 10,
                  ),
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      CircleBorder(),
                    ),
                  ),
                ),
              ),
            )
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
                const Text(
                  'Havarti',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Sandwiches, Fast Food',
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.yellow.shade700, size: 12),
                    const SizedBox(width: 6),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '4.3',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
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
