import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/category_model.dart';
import 'package:just_order/screens/home/categories_screen/screens/items_of_category_screen.dart';
import 'package:just_order/core/theme/colors.dart';

Widget buildCategoryWidget(Categories categories, ThemeState state, BuildContext context) {
  return GestureDetector(
    onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemsOfCategoryScreen(category: categories),
        ),
      );
    },
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: state.themeMode == ThemeMode.light
                  ? const Color(0x0CE02C45)
                  : const Color(0x5FE02C45),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 140,
                  width: 150,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(left: 5, bottom: 10, right: 5),
                  child: Text(
                    categories.categoryName,
                    style: TextStyle(
                      color: state.themeMode == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 150,
          height: 150,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: categories.categoryImage,
            fit: BoxFit.cover,
            width: 70,
            height: 70,
            memCacheHeight: 400,
            memCacheWidth: 400,
            maxHeightDiskCache: 400,
            maxWidthDiskCache: 400,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            ),
            errorWidget: (context, url, error) =>
            const Icon(Icons.broken_image_rounded),
          ),
        ),
      ],
    ),
  );
}
