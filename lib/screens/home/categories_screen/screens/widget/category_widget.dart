import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/category_model.dart';
import 'package:just_order/screens/home/categories_screen/screens/items_of_category_screen.dart';
import 'package:just_order/core/theme/colors.dart';

Widget buildCategoryWidget(Categories categories, ThemeState state, BuildContext context) {
  final isLight = state.themeMode == ThemeMode.light;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemsOfCategoryScreen(category: categories),
        ),
      );
    },
    child: Container(
      width: 140, // Standardize clean size profile
      decoration: BoxDecoration(
        // Smooth background tint mixing with current theme mode
        color: isLight ?  Colors.grey[200] : const Color(0x26E02C45),
        borderRadius: BorderRadius.circular(16), // Softer modern corners
        border: Border.all(
          color: isLight ? Colors.black.withAlpha(10) : Colors.white.withAlpha(15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Category Image Wrapper
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Creates a modern floating frame effect
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: categories.categoryImage,
                  fit: BoxFit.cover,
                  memCacheHeight: 300,
                  memCacheWidth: 300,
                  maxHeightDiskCache: 300,
                  maxWidthDiskCache: 300,
                  placeholder: (context, url) => Container(
                    color: Colors.black.withAlpha(10),
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
                    color: Colors.black12,
                    child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),

          // 2. Category Name Text Section
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0, top: 2.0),
            child: Text(
              categories.categoryName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isLight ? Colors.black87 : Colors.white,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600, // Slightly bolder for better readability
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}