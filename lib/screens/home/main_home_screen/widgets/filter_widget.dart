import 'package:flutter/material.dart';

Widget buildHomeFilterWidget() {
  return Container(
    width: 100,
    height: 30,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.mobiledata_off,
          color: Color(0xFF898888),
          size: 15,
        ),
        SizedBox(width: 4),
        Text(
          'Sort by',
          style: TextStyle(
            color: Color(0xFF898888),
            fontSize: 10,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        SizedBox(width: 4),
        Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Color(0xFF898888),
          size: 15,
        ),
      ],
    ),
  );
}
