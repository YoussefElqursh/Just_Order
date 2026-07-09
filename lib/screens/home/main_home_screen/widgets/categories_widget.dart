import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/category_model.dart';
import 'package:just_order/core/theme/colors.dart';
import 'package:just_order/screens/home/categories_screen/screens/items_of_category_screen.dart';

Widget buildCategoriesWidget(
    Categories categories,
    ThemeState state,
    BuildContext context,
    ) {
  final isLight = state.themeMode == ThemeMode.light;

  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemsOfCategoryScreen(category: categories),
        ),
      );
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Beautiful circular/rounded container for the image background
        Container(
          width: 76,  // Increased slightly to improve UX touch target sizes
          height: 76,
          decoration: BoxDecoration(
            // Generates a soft branded background behind the circle image
            color: isLight ? Colors.grey[200] : const Color(0x26E02C45),
            shape: BoxShape.circle,
            border: Border.all(
              color: isLight ? Colors.black.withAlpha(8) : Colors.white.withAlpha(12),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(6), // Mimics a high-quality frame border inset
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50), // Makes the network image perfectly round
            child: CachedNetworkImage(
              imageUrl: categories.categoryImage,
              fit: BoxFit.cover,
              memCacheHeight: 200, // Optimized cache sizing for small layout dimensions
              memCacheWidth: 200,
              maxHeightDiskCache: 200,
              maxWidthDiskCache: 200,
              placeholder: (context, url) => Container(
                color: Colors.black12,
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.black12,
                child: const Icon(Icons.fastfood_rounded, size: 20, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8), // Perfect spacing gap to text label

        // 2. Clear Label underneath the image
        SizedBox(
          width: 80, // Gives text room to breathe sideways before clipping
          child: Text(
            categories.categoryName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isLight ? Colors.black87 : Colors.white.withAlpha(230),
              fontSize: 12, // Bumped from 10 to standard 12 for accessibility compliance
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600, // Semi-bold reads clearer at micro sizes
            ),
          ),
        ),
      ],
    ),
  );
}