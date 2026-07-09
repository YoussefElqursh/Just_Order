import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/core/theme/colors.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';

/// Restaurant image + name + "more" button + created-at date row,
/// shared across every order-state card.
class OrderCardHeader extends StatelessWidget {
  const OrderCardHeader({
    super.key,
    required this.order,
    required this.restaurant,
    required this.state,
    this.onMoreTap,
  });

  final Order order;
  final Restaurant restaurant;
  final ThemeState state;

  /// Defaults to navigating to OrderDetailsScreenRoute if not provided.
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    final textColor =
        state.themeMode == ThemeMode.light ? Colors.black : Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Color(0xFFF4F4F4),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: restaurant.imageUrl ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 40,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: AppColor.primaryColor),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image_rounded),
            memCacheWidth: (MediaQuery.of(context).size.width *
                    MediaQuery.of(context).devicePixelRatio)
                .round(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      restaurant.name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: onMoreTap ??
                        () {
                          Navigator.pushNamed(
                            context,
                            'OrderDetailsScreenRoute',
                            arguments: [order, restaurant],
                          );
                        },
                    child: const Icon(
                      Icons.more_horiz,
                      color: Color(0xFF898888),
                      size: 18.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF898888),
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    DateFormat('dd MMM yyyy hh:mm a').format(order.createdAt),
                    style: const TextStyle(
                      color: Color(0xFF898888),
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
