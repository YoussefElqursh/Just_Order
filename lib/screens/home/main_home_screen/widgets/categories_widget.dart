import 'package:flutter/material.dart';
import 'package:just_order/models/restaurant_model.dart';

Widget buildCategoriesWidget(Restaurant restaurant) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0x0CE02C45),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 70,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(left: 5, bottom: 10, right: 5),
                child: Text(
                  restaurant.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        width: 70,
        height: 70,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage(restaurant.imageUrl ?? 'https://via.placeholder.com/150'),
            fit: BoxFit.cover,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ],
  );
}
