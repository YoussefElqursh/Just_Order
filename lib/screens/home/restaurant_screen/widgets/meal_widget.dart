import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/core/theme/colors.dart';

Widget buildMealWidget({
  required BuildContext context,
  required Item item,
  required ThemeState state,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, 'MealDetailsScreenRoute', arguments: item);
    },
    child: Row(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFFEBEBEB),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image_rounded),
                memCacheWidth: (MediaQuery.of(context).size.width *
                        MediaQuery.of(context).devicePixelRatio)
                    .round(),
              ),
            ),
            Visibility(
              visible: false,
              maintainSize: false,
              maintainState: false,
              maintainAnimation: false,
              child: Container(
                width: 35,
                height: 15,
                clipBehavior: Clip.antiAlias,
                decoration: const ShapeDecoration(
                  color: Color(0xFFE02C45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '0% Off',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 6,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10.0),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - 170,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: state.themeMode == ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: Color(0xFFAFAFAF),
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'EGP ${item.price}',
                      style: TextStyle(
                        color: state.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const Spacer(),
                    const Text(
                      'EGP 0.00',
                      style: TextStyle(
                        color: Color(0xFFE02C45),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Color(0xFFE02C45),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
