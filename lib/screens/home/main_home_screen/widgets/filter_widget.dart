import 'package:flutter/material.dart';
import 'package:just_order/screens/home/main_home_screen/models/filter_model.dart';

Widget buildHomeFilterWidget(FilterModel filter, int index,
    {required void Function()? onPressed}) {
  return Container(
    width: 135,
    height: 30,
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          width: 1,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Color(0x7FAFAFAF),
        ),
        borderRadius: BorderRadius.circular(100),
      ),
    ),
    child: MaterialButton(
      height: 30,
      minWidth: 135,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          width: 1,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Color(0x7FAFAFAF),
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            filter.prefix,
            color: const Color(0xFF898888),
            size: 15,
          ),
          const SizedBox(width: 4),
          Text(
            filter.filterTitle,
            style: const TextStyle(
              color: Color(0xFF898888),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(width: 4),
          index == 0
              ? Icon(
                  filter.suffix,
                  color: const Color(0xFF898888),
                  size: 15,
                )
              : const SizedBox(),
        ],
      ),
    ),
  );
}

List<FilterModel> filters = [
  FilterModel(Icons.keyboard_arrow_down_outlined,
      prefix: Icons.mobiledata_off, filterTitle: 'Sort by'),
  FilterModel(Icons.keyboard_arrow_down_outlined,
      prefix: Icons.star_border, filterTitle: 'Rating 0.4+'),
  FilterModel(Icons.keyboard_arrow_down_outlined,
      prefix: Icons.delivery_dining_outlined, filterTitle: 'Free Delivery '),
  FilterModel(Icons.keyboard_arrow_down_outlined,
      prefix: Icons.timer_outlined, filterTitle: 'Under 30 mins'),
];
