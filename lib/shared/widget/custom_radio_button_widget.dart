import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';

Widget customRadioButtonWidget({
  required BuildContext context,
  String? extraText,
  bool hasExtraText = false,
  bool hasDivider = true,
  required double width,
  required String label,
  required String value,
  String? groupName,
  required Function(String?) onChanged,
  required ThemeState state,
}) {
  return SizedBox(
    width: width,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const Spacer(),
            SizedBox(
              child: hasExtraText == true
                  ? Text(
                      extraText!,
                      style: const TextStyle(
                        color: Color(0xFFAFAFAF),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  : null,
            ),
            Radio(
                value: value,
                activeColor: const Color(0xFFE02C45),
                groupValue: groupName,
                onChanged: onChanged),
          ],
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 1,
          child: hasDivider == true
              ? const Divider(
                  height: 1,
                  color: Color(0x4CC8C8C8),
                )
              : null,
        ),
      ],
    ),
  );
}
