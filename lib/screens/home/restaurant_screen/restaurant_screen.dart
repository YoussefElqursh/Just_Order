import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_order/blocs/category_cubit/category_cubit.dart';
import 'package:just_order/blocs/category_cubit/category_state.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/cart_provider.dart';
import 'package:just_order/repository/category_repository.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/filter_widget.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:just_order/shared/style/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantScreenArguments {
  final Restaurant restaurant;
  final User user;

  RestaurantScreenArguments({
    required this.restaurant,
    required this.user,
  });
}

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;
  final User user;

  const RestaurantScreen({
    super.key,
    required this.restaurant,
    required this.user,
  });

  static const String routeName = 'RestaurantScreenRoute';

  static Route route(Restaurant restaurant, User user) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => RestaurantScreen(
        restaurant: restaurant,
        user: user,
      ),
    );
  }

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  late List<Item> items;
  final UserRepository userRepository = UserRepository();
  bool isLoading = true;
  bool isFavorite = true;

  List<String> filter = [];

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    DateTime startLoad = DateTime.now();
    await Future.wait(
      [
        _loadItems(),
        _addRestaurantToPrefs(),
        _checkIfFavorite(),
      ],
    );
    debugPrint(
      "Time take to load restaurant is " +
          DateTime.now().difference(startLoad).inMilliseconds.toString(),
    );
  }

  // Check favorite using isolate
  Future<void> _checkIfFavorite() async {
    DateTime checkFavourite = DateTime.now();
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
      if (kDebugMode) {
        print("Time take to check favourite is : " +
            DateTime.now()
                .difference(checkFavourite)
                .inMilliseconds
                .toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to check favorite status: $e');
        print("Time take to check favourite is : " +
            DateTime.now()
                .difference(checkFavourite)
                .inMilliseconds
                .toString());
      }
    }
  }

  Future<void> _loadItems() async {
    DateTime startLoadItems = DateTime.now();
    final fetchItems = await userRepository.getItems(widget.restaurant.itemIds);
    setState(() {
      items = fetchItems;
      isLoading = false;
    });
    if (kDebugMode) {
      print("Time take to load items is : " +
          DateTime.now().difference(startLoadItems).inMilliseconds.toString());
    }
  }

  Future<void> _addRestaurantToPrefs() async {
    DateTime startAddRestaurant = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppLocalizations.of(context)!.restaurant_name,
      jsonEncode(
        widget.restaurant.toJson(),
      ),
    );

    print(
      "Time take to add restaurant is : " +
          DateTime.now()
              .difference(startAddRestaurant)
              .inMilliseconds
              .toString(),
    );
  }

  Future<void> _removeRestaurantFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppLocalizations.of(context)!.restaurant_name);
  }

  void _onWillPop(bool result, dynamic data) async {
    await _removeRestaurantFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    CategoryRepository categoryRepository = CategoryRepository();
    Restaurant restaurant = widget.restaurant;
    final cartProvider = Provider.of<CartProvider>(context);
    final filteredItems = restaurant != null
        ? cartProvider.items
            .where(
              (item) => item.cartItemId.endsWith('_${restaurant.restaurantId}'),
            )
            .toList()
        : cartProvider.items;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        Map<String, dynamic> favouriteRestaurant = {
          'favouriteRestaurant': widget.restaurant.restaurantId,
        };
        return BlocProvider(
          create: (_) {
            final cubit = CategoryCubit(categoryRepository);
            cubit.fetchCategoriesByIds(widget.restaurant.categoriesId);
            return cubit;
          },
          child: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, c_state) {
              return c_state.when(
                initial: () => const Center(
                  child: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
                loading: () => const Center(
                  child: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
                error: (error) => const Center(
                  child: Text('err'),
                ),
                addedSuccessfully: () => const Center(
                  child: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
                success: (categories) {
                  filter = [
                    'Trending',
                    'Discounts',
                    'Up to 40% off',
                    ...categories
                        .where((category) =>
                            category?.categoryName !=
                            null) // Remove null categories and null names
                        .map((category) => category!.categoryName),
                  ];
                  return PopScope(
                    onPopInvokedWithResult:
                        _onWillPop as void Function(bool, dynamic)?,
                    child: DefaultTabController(
                      length: filter.length,
                      child: Scaffold(
                        body: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFE02C45),
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomLeft,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 250,
                                              margin:
                                                  EdgeInsets.only(top: 30.0),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    restaurant.imageUrl ??
                                                        'https://via.placeholder.com/150',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 200,
                                              left: 20,
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                padding: EdgeInsets.all(100.0),
                                                decoration: ShapeDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      restaurant.imageUrl ??
                                                          'https://via.placeholder.com/150',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 50.0,
                                              left: 20.0,
                                              right: 20.0,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 34,
                                                  height: 34,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: ShapeDecoration(
                                                    color: state.themeMode ==
                                                            ThemeMode.light
                                                        ? const Color(
                                                            0xFFF4F4F4)
                                                        : Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(
                                                      Icons.arrow_back,
                                                      color: state.themeMode ==
                                                              ThemeMode.light
                                                          ? Colors.black
                                                          : Colors.white,
                                                      size: 18,
                                                    ),
                                                    style: ButtonStyle(
                                                      shape:
                                                          WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Container(
                                                  width: 34,
                                                  height: 34,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        const Color(0xFFF4F4F4),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          isFavorite =
                                                              !isFavorite;
                                                        },
                                                      );
                                                      !isFavorite
                                                          ? removeFavouriteRestaurant(
                                                              widget
                                                                  .user.userId,
                                                              widget.restaurant
                                                                  .restaurantId,
                                                            )
                                                          : addFavouriteRestaurant(
                                                              widget
                                                                  .user.userId,
                                                              favouriteRestaurant,
                                                            );
                                                    },
                                                    icon: Icon(
                                                      !isFavorite
                                                          ? Icons
                                                              .favorite_border
                                                          : Icons.favorite,
                                                      color: !isFavorite
                                                          ? state.themeMode ==
                                                                  ThemeMode
                                                                      .light
                                                              ? Colors.black
                                                              : Colors.white
                                                          : Color(0xFFE02C45),
                                                      size: 18,
                                                    ),
                                                    style: ButtonStyle(
                                                      shape:
                                                          WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 55),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            restaurant.name,
                                            style: TextStyle(
                                              color: state.themeMode ==
                                                      ThemeMode.light
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(width: 16),
                                          Text(
                                            '4.7',
                                            style: TextStyle(
                                              color: state.themeMode ==
                                                      ThemeMode.light
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(width: 3),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow.shade700,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .ratings_30265,
                                            style: TextStyle(
                                              color: Color(0xFFAFAFAF),
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .pizza_pies_crepes,
                                        style: TextStyle(
                                          color: Color(0xFFAFAFAF),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icons/timer.png',
                                                height: 15,
                                                width: 15,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '${restaurant.orderTimeOut.toString()} mins',
                                                style: TextStyle(
                                                  color: state.themeMode ==
                                                          ThemeMode.light
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 30.0),
                                          Transform(
                                            transform: Matrix4.identity()
                                              ..translate(0.0, 0.0)
                                              ..rotateZ(1.57),
                                            child: Container(
                                              width: 15,
                                              decoration: const ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    width: 1,
                                                    strokeAlign: BorderSide
                                                        .strokeAlignCenter,
                                                    color: Color(0x66AFAFAF),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20.0),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/delivery_taxes.png',
                                                height: 15,
                                                width: 15,
                                              ),
                                              const SizedBox(width: 6.0),
                                              Text(
                                                (restaurant.deliveryFee != null)
                                                    ? '${AppLocalizations.of(context)!.egp} ${restaurant.deliveryFee}'
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .free,
                                                style: TextStyle(
                                                  color: state.themeMode ==
                                                          ThemeMode.light
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: 12,
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
                                    ),
                                    const SizedBox(height: 25.0),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: 20),
                                    //   child: SizedBox(
                                    //     height: 34.0,
                                    //     width: MediaQuery.sizeOf(context).width,
                                    //     child: SingleChildScrollView(
                                    //       scrollDirection: Axis.horizontal,
                                    //       clipBehavior: Clip.none,
                                    //       physics: const BouncingScrollPhysics(),
                                    //       child: Row(
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         mainAxisAlignment: MainAxisAlignment.start,
                                    //         children: [
                                    //           Container(
                                    //             width: 34,
                                    //             height: 34,
                                    //             clipBehavior: Clip.antiAlias,
                                    //             decoration: ShapeDecoration(
                                    //               color: const Color(0xFFF4F4F4),
                                    //               shape: RoundedRectangleBorder(
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(6)),
                                    //             ),
                                    //             child: const Icon(
                                    //               Icons.list,
                                    //               color: Color(0xFF898888),
                                    //               size: 15,
                                    //             ),
                                    //           ),
                                    //           const SizedBox(width: 16),
                                    //           Transform(
                                    //             transform: Matrix4.identity()
                                    //               ..translate(0.0, 0.0)
                                    //               ..rotateZ(1.57),
                                    //             child: Container(
                                    //               width: 34,
                                    //               height: 1,
                                    //               decoration: const ShapeDecoration(
                                    //                 shape: RoundedRectangleBorder(
                                    //                   side: BorderSide(
                                    //                     width: 1,
                                    //                     strokeAlign:
                                    //                         BorderSide.strokeAlignCenter,
                                    //                     color: Color(0x7FAFAFAF),
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    TabBar(
                                      physics: const BouncingScrollPhysics(),
                                      overlayColor:
                                          const WidgetStatePropertyAll(
                                        Colors.transparent,
                                      ),
                                      isScrollable: true,
                                      dividerColor: Colors.transparent,
                                      tabAlignment: TabAlignment.start,
                                      unselectedLabelColor:
                                          state.themeMode == ThemeMode.light
                                              ? const Color(0xFF898888)
                                              : Colors.white,
                                      unselectedLabelStyle: TextStyle(
                                        color:
                                            state.themeMode == ThemeMode.light
                                                ? const Color(0xFF898888)
                                                : Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      labelColor: const Color(0xFFE02C45),
                                      labelStyle: const TextStyle(
                                        color: Color(0xFFE02C45),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      indicatorColor: const Color(0xFFE02C45),
                                      tabs: [
                                        for (int i = 0; i < filter.length; i++)
                                          Tab(text: filter[i])
                                      ],
                                    ),
                                    SingleChildScrollView(
                                      child: SizedBox(
                                        width: MediaQuery.sizeOf(context).width,
                                        height:
                                            MediaQuery.sizeOf(context).height -
                                                500,
                                        child: TabBarView(
                                          children: [
                                            for (int i = 0; i < filter.length; i++)
                                              FilterWidget(
                                                items: items
                                                    .where((element) =>
                                                        element.category ==
                                                        filter[i])
                                                    .toList(),
                                                filters: filter[i],
                                                state: state,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        floatingActionButton: Badge(
                          label: Text('${filteredItems.length}'),
                          alignment: AlignmentDirectional.topStart,
                          backgroundColor: Colors.white,
                          textColor: const Color(0xFFE02C45),
                          isLabelVisible: true,
                          smallSize: 12,
                          child: FloatingActionButton(
                            onPressed: () {
                              navigateTo(context, 'MyCartScreenRoute');
                            },
                            backgroundColor: const Color(0xFFE02C45),
                            shape: const CircleBorder(
                              side: BorderSide(
                                color: Color(0xFFE02C45),
                              ),
                            ),
                            child: Image.asset(
                              'assets/icons/cart.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
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
      if (kDebugMode) {
        print('Restaurant added successfully!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to add restaurant: $e');
      }
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
        if (kDebugMode) {
          print('Restaurant removed successfully!');
        }
      } else {
        if (kDebugMode) {
          print('Error: Restaurant document does not exist.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to remove restaurant: $e');
      }
    }
  }
}
