import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/models/restaurant_model.dart';

/// Name + rating row, cuisine tagline, and the delivery-time/fee pill.
///
/// Purely presentational: it receives [rating]/[ratingCount] rather than
/// reading them itself, and reports taps via [onRatingTap].
class RestaurantInfoSection extends StatelessWidget {
  final Restaurant restaurant;
  final ThemeState state;
  final double rating;
  final int ratingCount;
  final VoidCallback onRatingTap;

  const RestaurantInfoSection({
    super.key,
    required this.restaurant,
    required this.state,
    required this.rating,
    required this.ratingCount,
    required this.onRatingTap,
  });

  bool get _isLight => state.themeMode == ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    final titleColor = _isLight ? Colors.black : Colors.white;
    final subtitleColor = _isLight ? Colors.grey[600] : Colors.grey[400];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align to top for multi-line protection
            children: [
              // 1. Restaurant Name Title
              Expanded(
                child: Text(
                  restaurant.name,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 22.sp, // Bumped up slightly for a bold hero feel
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 2, // Allow a 2-line break gracefully if title is extra long
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 16.w),

              // 2. Interactive Premium Rating Badge
              GestureDetector(
                onTap: onRatingTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _isLight ? Colors.amber.shade50 : Colors.amber.shade50.withAlpha(120),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.amber.withAlpha(_isLight ? 40 : 60),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: _isLight ? Colors.amber.shade900 : Colors.amber.shade200,
                          fontSize: 13.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),

        // 3. Ratings Total + Cuisine Tag Subtitle Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${AppLocalizations.of(context)!.pizza_pies_crepes}  •  ($ratingCount ${AppLocalizations.of(context)!.ratings_30265})',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),

        // 4. Clean Metadata Context Frame
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _DeliveryInfoPill(restaurant: restaurant, isLight: _isLight),
        ),
      ],
    );
  }
}

class _DeliveryInfoPill extends StatelessWidget {
  final Restaurant restaurant;
  final bool isLight;

  const _DeliveryInfoPill({required this.restaurant, required this.isLight});

  @override
  Widget build(BuildContext context) {
    final frameColor = isLight ? Colors.grey[100] : const Color(0xFF1E1E1E);
    final borderColor = isLight ? Colors.black.withAlpha(10) : Colors.white.withAlpha(12);
    final textColor = isLight ? Colors.black87 : Colors.white;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: frameColor,
        borderRadius: BorderRadius.circular(14), // Softer, cohesive roundness profile
        border: Border.all(color: borderColor, width: 1),
      ),
      child: IntrinsicHeight( // Fixes native VerticalDivider constraint crashes layout bugs
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Left Feature Section: Order Fulfillment Speed Time
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/timer.png', height: 16.sp, width: 16.sp, errorBuilder: (_, _, _) => Icon(Icons.access_time_rounded, size: 16.sp, color: Colors.grey)),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      '${restaurant.orderTimeOut} mins',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Clean Separator Element Line
            VerticalDivider(
              color: isLight ? Colors.black12 : Colors.white24,
              thickness: 1,
              width: 1,
            ),

            // Right Feature Section: Delivery Pricing Taxes
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/delivery_taxes.png', height: 16.sp, width: 16.sp, errorBuilder: (_, _, _) => Icon(Icons.delivery_dining_rounded, size: 16.sp, color: Colors.grey)),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      restaurant.deliveryFee != null
                          ? '${AppLocalizations.of(context)!.egp} ${restaurant.deliveryFee}'
                          : AppLocalizations.of(context)!.free,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}