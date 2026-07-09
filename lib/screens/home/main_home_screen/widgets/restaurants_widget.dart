import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/screens/home/restaurant_screen/restaurant_screen.dart';
import 'package:just_order/core/theme/colors.dart';

class RestaurantWidget extends StatefulWidget {
  final Restaurant restaurant;
  final User user;
  final ThemeState state;

  const RestaurantWidget({
    super.key,
    required this.restaurant,
    required this.state,
    required this.user,
  });

  @override
  State<RestaurantWidget> createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.userId)
          .collection('favouriteRestaurant')
          .doc(widget.restaurant.restaurantId)
          .get();

      if (mounted) {
        setState(() {
          isFavorite = documentSnapshot.exists;
        });
      }
    } catch (e) {
      debugPrint('Failed to check favorite status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = widget.state.themeMode == ThemeMode.light;
    final titleColor = isLight ? Colors.black : Colors.white;
    final secondaryTextColor = isLight ? Colors.grey[600] : Colors.grey[400];

    Map<String, dynamic> favouriteRestaurant = {
      'favouriteRestaurant': widget.restaurant.restaurantId,
    };

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          'RestaurantScreenRoute',
          arguments: RestaurantScreenArguments(
            restaurant: widget.restaurant,
            user: widget.user,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Section with clean corner clipping clipping
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isLight ? Colors.black.withAlpha(10) : Colors.white.withAlpha(15),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: CachedNetworkImage(
                  imageUrl: widget.restaurant.imageUrl ?? '',
                  fit: BoxFit.cover,
                  memCacheWidth: 250, // Downsample image to save memory footprint
                  placeholder: (context, url) => Container(
                    color: isLight ? Colors.grey[100] : Colors.grey[900],
                    child: const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryColor),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.storefront_rounded, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Flexible Content Block (No math equations needed)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Title & Favorite Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.restaurant.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 14, // Bumped slightly for typography balance
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Handcrafted Favorite tap zone removing native iconButton padding bloat
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          !isFavorite
                              ? removeFavouriteRestaurant(widget.user.userId, widget.restaurant.restaurantId)
                              : addFavouriteRestaurant(widget.user.userId, favouriteRestaurant);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFavorite ? const Color(0xFFE02C45) : secondaryTextColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Cuisine details
                  Text(
                    'Fast Food • Snacks • Beverages',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Metadata Info Footer
                  Row(
                    children: [
                      // Rating
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 15),
                      const SizedBox(width: 3),
                      Text(
                        '4.8',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        ' (79)',
                        style: TextStyle(fontSize: 11, color: secondaryTextColor),
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: secondaryTextColor, fontSize: 11)),
                      const SizedBox(width: 8),

                      // Order Time
                      Icon(Icons.access_time_rounded, color: secondaryTextColor, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.restaurant.orderTimeOut} mins',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: titleColor),
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: secondaryTextColor, fontSize: 11)),
                      const SizedBox(width: 8),

                      // Delivery Tax
                      Icon(Icons.delivery_dining_rounded, color: secondaryTextColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        widget.restaurant.deliveryFee != null ? 'EGP ${widget.restaurant.deliveryFee}' : 'Free',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: titleColor),
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

  // --- Keeps your existing repository Firestore logic intact below ---
  void addFavouriteRestaurant(String userId, Map<String, dynamic> restaurantData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favouriteRestaurant')
          .doc(restaurantData['favouriteRestaurant'])
          .set(restaurantData);
    } catch (e) {
      debugPrint('Failed to add restaurant: $e');
    }
  }

  Future<void> removeFavouriteRestaurant(String userId, String restaurantId) async {
    try {
      DocumentReference ref = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favouriteRestaurant')
          .doc(restaurantId);

      if ((await ref.get()).exists) {
        await ref.delete();
      }
    } catch (e) {
      debugPrint('Failed to remove restaurant: $e');
    }
  }
}