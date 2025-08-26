import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/shared/style/colors.dart';

Widget customCheckBoxButtonWidget({
  required BuildContext context,
  String? extraText,
  bool hasExtraText = false,
  bool hasDivider = true,
  required String label,
  required bool value,
  required Function(bool?) onChanged,
  required ThemeState state,
}) {
  return SizedBox(
    width: MediaQuery.sizeOf(context).width,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: state.themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
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
            ],
          ),
          contentPadding: const EdgeInsets.all(0),
          tileColor: state.themeMode == ThemeMode.light
              ? Colors.white
              : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          activeColor: AppColor.primaryColor,
          checkColor: state.themeMode == ThemeMode.light
              ? Colors.white
              : Colors.black,
          controlAffinity: ListTileControlAffinity.trailing,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: const BorderSide(color: Color(0xFF898888), width: 1.5),
          value: value,
          onChanged: onChanged,
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 1,
          child: hasDivider == true
              ? const Divider(height: 1, color: Color(0x4CC8C8C8))
              : null,
        ),
      ],
    ),
  );
}
