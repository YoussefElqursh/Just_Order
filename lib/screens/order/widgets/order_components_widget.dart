import 'package:flutter/material.dart';

Widget buildOrderComponentsWidget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: ShapeDecoration(
          image: const DecorationImage(
            image: NetworkImage("https://via.placeholder.com/40x40"),
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
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chicken Ranch Pizza',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 6.0),
            Text(
              'EGP 300.00',
              style: TextStyle(
                color: Colors.black,
                fontSize: 8,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        ),
      ),
      const Spacer(),
      Container(
        width: 29,
        height: 29,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0x0CE02C45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: const Center(
          child: Text(
            'x2',
            textAlign: TextAlign.center,
            style: TextStyle(
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
