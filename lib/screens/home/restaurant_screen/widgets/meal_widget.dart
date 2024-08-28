import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_order/shared/function/functions.dart';

Widget buildMealWidget({
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      navigateTo(context, 'MealDetailsScreenRoute');
    },
    child: Row(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: ShapeDecoration(
                image: const DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/100x100"),
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
            Container(
              width: 35,
              height: 15,
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                color: Color(0xFFE02C45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              child: const Center(
                child: Text(
                  '10% Off',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 6,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10.0),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - 170,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chicken Ranch Pizza',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 1,
                ),
                SizedBox(height: 8),
                Text(
                  'Juicy chicken, tangy ranch dressing, melted cheese, fresh vegetables, crispy pizza crust.',
                  style: TextStyle(
                    color: Color(0xFFAFAFAF),
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 3,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'EGP 120.00',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Spacer(),
                    Text(
                      'EGP 130.00',
                      style: TextStyle(
                        color: Color(0xFFE02C45),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Color(0xFFE02C45),
                      ),
                    )
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
