import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/core/theme/colors.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/screens/home/meal_details_screen/meal_details_screen.dart';

Widget buildMealWidget({
  required BuildContext context,
  required Item item,
  required ThemeState state,
  required Restaurant restaurant,
}) {
  final isLight = state.themeMode == ThemeMode.light;
  final titleColor = isLight ? Colors.black : Colors.white;
  final descColor = isLight ? Colors.grey[600] : Colors.grey[400];
  final borderColor = isLight ? Colors.black.withAlpha(8) : Colors.white.withAlpha(12);

  // Note: Set this to true later when your backend/model supports discounts
  const bool hasDiscount = false;

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MealDetailsScreen.route(item, restaurant),
      );
    },
    splashColor: AppColor.primaryColor.withAlpha(15),
    highlightColor: Colors.transparent,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Top-aligns text to image beautifully
        children: [
          // 1. Image Thumbnail Container Frame
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                width: 96.w,
                height: 96.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11.r), // Keep slightly under container radius
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: isLight ? Colors.grey[50] : Colors.grey[900],
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: isLight ? Colors.grey[100] : Colors.grey[900],
                      child: Icon(Icons.fastfood_rounded, size: 24.sp, color: Colors.grey[400]),
                    ),
                    memCacheWidth: (96.w * MediaQuery.of(context).devicePixelRatio).round(),
                  ),
                ),
              ),

              // Hidden safely until your backend Item model includes a discount field
              if (hasDiscount)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE02C45),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    '0% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 14.w),

          // 2. Metadata Context Column (Safe Expansion)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text(
                  item.name,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4.h),
                Text(
                  item.description,
                  style: TextStyle(
                    color: descColor,
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.3, // Improves multi-line reading flow
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2, // 2 lines keeps rows uniform and elegant
                ),
                SizedBox(height: 10.h),

                // Pricing Matrix Bar
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'EGP ${item.price}',
                      style: TextStyle(
                        color: AppColor.primaryColor, // Highlight color for prices
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}