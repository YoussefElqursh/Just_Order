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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                restaurant.name,
                style: TextStyle(
                  color: _isLight ? Colors.black : Colors.white,
                  fontSize: 18.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const Spacer(),
              GestureDetector(
                onTap: onRatingTap,
                child: Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: _isLight ? Colors.black : Colors.white,
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(width: 3),
                    Icon(Icons.star, color: Colors.yellow.shade700, size: 15),
                    const SizedBox(width: 3),
                    Text(
                      '($ratingCount) ${AppLocalizations.of(context)!.ratings_30265}',
                      style: TextStyle(
                        color: const Color(0xFFAFAFAF),
                        fontSize: 10.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            AppLocalizations.of(context)!.pizza_pies_crepes,
            style: TextStyle(
              color: const Color(0xFFAFAFAF),
              fontSize: 12.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: Border.all(color: const Color(0xFFF4F4F4), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset('assets/icons/timer.png', height: 15, width: 15),
              const SizedBox(width: 6),
              Text(
                '${restaurant.orderTimeOut} mins',
                style: TextStyle(
                  color: isLight ? Colors.black : Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          const SizedBox(width: 30.0),
          const VerticalDivider(color: Color(0x66AFAFAF), width: 2),
          const SizedBox(width: 20.0),
          Row(
            children: [
              Image.asset('assets/icons/delivery_taxes.png', height: 15, width: 15),
              const SizedBox(width: 6.0),
              Text(
                restaurant.deliveryFee != null
                    ? '${AppLocalizations.of(context)!.egp} ${restaurant.deliveryFee}'
                    : AppLocalizations.of(context)!.free,
                style: TextStyle(
                  color: isLight ? Colors.black : Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
