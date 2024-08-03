import 'package:flutter/material.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/meal_widget.dart';

Widget buildFilterWidget(){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Trending',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          width: double.infinity,
          child: ListView.separated(
            itemBuilder: (context, index) => buildMealWidget(context: context),
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(height: 1, color: Colors.grey,),
            ),
            itemCount: 5,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
          ),
        ),
      ],
    ),
  );
}
