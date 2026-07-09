import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/screens/home/restaurant_screen/restaurant_screen.dart';
import 'package:just_order/core/theme/colors.dart';

/// Helper method to encapsulate navigation logic cleanly
void _navigateToRestaurant(BuildContext context, Restaurant restaurant, User user) {
  Navigator.pushNamed(
    context,
    'RestaurantScreenRoute',
    arguments: RestaurantScreenArguments(
      restaurant: restaurant,
      user: user,
    ),
  );
}

/// 1. Compact View Component (Perfect for horizontal scrolling lists)
Widget buildPopularTodayWidget({
  required BuildContext context,
  required Restaurant restaurant,
  required User user,
  required ThemeState state,
}) {
  return SizedBox(
    width: 160,
    child: _BaseRestaurantCard(
      restaurant: restaurant,
      user: user,
      state: state,
      imageHeight: 110,
    ),
  );
}

/// 2. Full Width View Component (Perfect for vertical list views/category searches)
Widget buildPopularTodayScreen({
  required BuildContext context,
  required Restaurant restaurant,
  required User user,
  required ThemeState state,
}) {
  return _BaseRestaurantCard(
    restaurant: restaurant,
    user: user,
    state: state,
    imageHeight: 150, // Slightly taller landscape dimension for hero cards
  );
}

/// Shared Base Widget to eliminate code duplication and maintain UI consistency
class _BaseRestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final User user;
  final ThemeState state;
  final double imageHeight;

  const _BaseRestaurantCard({
    required this.restaurant,
    required this.user,
    required this.state,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = state.themeMode == ThemeMode.light;

    // Dynamic styling profiles based on Theme Mode
    final cardBgColor = isLight ? AppColor.whiteColor : AppColor.blackColor;
    final borderColor = isLight ? Colors.black.withAlpha(12) : Colors.white.withAlpha(16);
    final subtitleColor = isLight ? Colors.grey[600] : Colors.grey[400];

    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      color: cardBgColor,
      clipBehavior: Clip.antiAlias, // Critical Fix: Forces everything inside rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: InkWell(
        onTap: () => _navigateToRestaurant(context, restaurant, user),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Section
            SizedBox(
              height: imageHeight,
              child: CachedNetworkImage(
                imageUrl: restaurant.imageUrl ?? '',
                fit: BoxFit.cover,
                memCacheWidth: 350, // Safe resolution for both thumbnail and standard feeds
                placeholder: (context, url) => Container(
                  color: isLight ? Colors.grey[100] : Colors.grey[900],
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryColor),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: isLight ? Colors.grey[200] : Colors.grey[900],
                  child: const Icon(Icons.storefront_rounded, color: Colors.grey),
                ),
              ),
            ),

            // Meta Content Details Section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Cuisine Tagline
                  Text(
                    'Sandwiches, Fast Food',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Ratings Details Bar
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '4.3',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(86 ratings)',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
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
}