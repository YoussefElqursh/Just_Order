import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';

Widget accountFunctionWidget({
  required BuildContext context,
  required IconData icon,
  required String label,
  bool isText = false,
  String? text,
  required void Function()? onPressed,
  required ThemeState state,
}) {
  return MaterialButton(
    onPressed: onPressed,
    height: 52,
    color: Colors.transparent,
    elevation: 0.0,
    highlightElevation: 0.0,
    shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
    minWidth: MediaQuery.sizeOf(context).width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0x0CE02C45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: const Color(0xFFE02C45),
              size: 20,
            ),
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        Text(
          label,
          style: TextStyle(
            color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const Spacer(),
        isText ? Text(text!) : Icon(
          Icons.arrow_forward_ios,
          color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
          size: 18,
        ),
      ],
    ),
  );
}
