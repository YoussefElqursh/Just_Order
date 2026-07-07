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
  bool isFavorite = true;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite(); // Check favorite status when the widget is initialized
  }

  void _checkIfFavorite() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.userId)
          .collection('favouriteRestaurant')
          .doc(widget.restaurant.restaurantId)
          .get();

      // Update the isFavorite status
      if (documentSnapshot.exists) {
        setState(() {
          isFavorite = true;
        });
      } else {
        setState(() {
          isFavorite = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to check favorite status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> favouriteRestaurant = {
      'favouriteRestaurant': widget.restaurant.restaurantId,
    };
    return GestureDetector(
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
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1.50,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFEBEBEB),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.restaurant.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 90,
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - 155,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 160,
                    height: 27.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.restaurant.name,
                          style: TextStyle(
                            color: widget.state.themeMode == ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                            !isFavorite
                                ? removeFavouriteRestaurant(
                                    widget.user.userId,
                                    widget.restaurant.restaurantId,
                                  )
                                : addFavouriteRestaurant(
                                    widget.user.userId,
                                    favouriteRestaurant,
                                  );
                          },
                          icon: Icon(
                            !isFavorite
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: !isFavorite
                                ? widget.state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white
                                : const Color(0xFFE02C45),
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Fast Food, Snacks, Beverages',
                    style: TextStyle(
                      color: Color(0xFFAFAFAF),
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow.shade700, size: 15),
                      const SizedBox(width: 6),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '4.8',
                              style: TextStyle(
                                color: widget.state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const TextSpan(
                              text: ' (79)',
                              style: TextStyle(
                                color: Color(0xFFAFAFAF),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/timer.png',
                            height: 15,
                            width: 15,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.restaurant.orderTimeOut.toString()} mins',
                            style: TextStyle(
                              color: widget.state.themeMode == ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '•',
                        style: TextStyle(
                          color: Color(0xFFAFAFAF),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(width: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/delivery_taxes.png',
                            height: 15,
                            width: 15,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            (widget.restaurant.deliveryFee != null)
                                ? 'EGP ${widget.restaurant.deliveryFee}'
                                : 'Free',
                            style: TextStyle(
                              color: widget.state.themeMode == ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 10,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addFavouriteRestaurant(
      String userId, Map<String, dynamic> restaurantData) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userDocRef
          .collection('favouriteRestaurant')
          .doc(restaurantData['favouriteRestaurant'])
          .set(restaurantData);

      debugPrint('Restaurant added successfully!');
    } catch (e) {
      debugPrint('Failed to add restaurant: $e');
    }
  }

  Future<void> removeFavouriteRestaurant(
      String userId, String restaurantId) async {
    try {
      DocumentReference restaurantDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favouriteRestaurant')
          .doc(restaurantId);

      DocumentSnapshot docSnapshot = await restaurantDocRef.get();

      if (docSnapshot.exists) {
        await restaurantDocRef.delete();
        debugPrint('Restaurant removed successfully!');
      } else {
        debugPrint('Error: Restaurant document does not exist.');
      }
    } catch (e) {
      debugPrint('Failed to remove restaurant: $e');
    }
  }
}
