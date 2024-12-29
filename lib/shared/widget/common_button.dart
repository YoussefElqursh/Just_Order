import 'package:flutter/material.dart';

MaterialButton buildMaterialButton({
  required BuildContext context,
  required Function()? onPressed,
  required String title,
  Color color = const Color(0xFFE02C45),
  Color textColor = const Color(0xFFFFFFFF),
  required double height,
  double width = double.infinity,
}) {
  return MaterialButton(
    onPressed: onPressed,
    height: height,
    color: color,
    minWidth: width,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      side: const BorderSide(
        width: 1,
        strokeAlign: BorderSide.strokeAlignCenter,
        color: Color(0x4CAFAFAF),
      ),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      softWrap: true,
      textAlign: TextAlign.center,
    ),
  );
}
