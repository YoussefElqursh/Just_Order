import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/category_cubit/category_cubit.dart';
import 'package:just_order/blocs/category_cubit/category_state.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/cart_provider.dart';
import 'package:just_order/repository/category_repository.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/filter_widget.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/keep_alive_widget.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/restaurant_shimmer_widget.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:just_order/core/theme/colors.dart';
import 'package:just_order/core/storage/storage_service.dart';

class RestaurantScreenArguments {
  final Restaurant restaurant;
  final User user;

  RestaurantScreenArguments({required this.restaurant, required this.user});
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
      builder: (context) =>
          RestaurantScreen(restaurant: restaurant, user: user),
    );
  }

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen>
    with AutomaticKeepAliveClientMixin {
  late List<Item> items;

  double _currentRating = 4.7;
  int ratingCount = 30265;
  bool isCollapsed = false;
  final UserRepository userRepository = UserRepository();
  bool isLoading = true;
  bool isFavorite = false;
  List<String> filter = [];
  late final Future<void> _initializationFuture;
  final Map<String, List<Item>> _filteredItemsMap = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeScreen();
    _loadSavedRating();
  }

  Future<void> _loadSavedRating() async {
    final prefs = StorageService.instance;
    setState(() {
      _currentRating = prefs.getDouble('restaurant_rating') ?? 4.7;
    });
  }

  Future<void> _initializeScreen() async {
    final stopwatch = Stopwatch()..start();
    await Future.wait([_loadItems(), _checkIfFavorite()]);
    _addRestaurantToPrefs(); // Don't await this
    debugPrint("Initialization took: ${stopwatch.elapsedMilliseconds}ms");
    stopwatch.stop();
  }

  Future<void> _checkIfFavorite() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.userId)
          .collection('favouriteRestaurant')
          .doc(widget.restaurant.restaurantId)
          .get(const GetOptions(source: Source.cache));

      if (mounted) {
        setState(() => isFavorite = doc.exists);
      }
    } catch (e) {
      debugPrint('Favorite check error: $e');
    }
  }

  Future<void> _loadItems() async {
    try {
      final fetchedItems = await userRepository.getItems(
        widget.restaurant.itemIds,
      );
      if (mounted) {
        setState(() {
          items = fetchedItems;
          isLoading = false;
          // Pre-compute filtered items
          for (final item in fetchedItems) {
            _filteredItemsMap.putIfAbsent(item.category, () => []).add(item);
          }
        });
      }
    } catch (e) {
      debugPrint('Failed to load items: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _addRestaurantToPrefs() async {
    final prefs = StorageService.instance;
    await prefs.setString(
      // ignore: use_build_context_synchronously
      AppLocalizations.of(context)!.restaurant_name,
      jsonEncode(widget.restaurant.toJson()),
    );
  }

  Future<void> _removeRestaurantFromPrefs() async {
    final prefs = StorageService.instance;
    await prefs.remove('last_restaurant_${widget.user.userId}');
  }

  Future<void> addFavouriteRestaurant(
    String userId,
    Map<String, dynamic> restaurantData,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favouriteRestaurant')
          .doc(restaurantData['favouriteRestaurant'])
          .set(restaurantData);
      debugPrint('Restaurant added successfully!');
    } catch (e) {
      debugPrint('Failed to add restaurant: $e');
    }
  }

  Future<void> removeFavouriteRestaurant(
    String userId,
    String restaurantId,
  ) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favouriteRestaurant')
          .doc(restaurantId);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) await docRef.delete();
      debugPrint('Restaurant removed successfully!');
    } catch (e) {
      debugPrint('Failed to remove restaurant: $e');
    }
  }

  void _toggleFavorite(ThemeState state) {
    setState(() => isFavorite = !isFavorite);
    final favouriteRestaurant = {
      'favouriteRestaurant': widget.restaurant.restaurantId,
    };
    !isFavorite
        ? removeFavouriteRestaurant(
            widget.user.userId,
            widget.restaurant.restaurantId,
          )
        : addFavouriteRestaurant(widget.user.userId, favouriteRestaurant);
  }

  void _showRatingDialog(BuildContext context, ThemeState state) {
    double tempRating = _currentRating;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: state.themeMode == ThemeMode.light
              ? Colors.white
              : Colors.black,
          title: Text('Rate ${widget.restaurant.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How would you rate your experience?'),
              const SizedBox(height: 20),
              // Simple star rating widget without Positioned
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        tempRating = index + 1.0;
                      });
                    },
                    child: Icon(
                      index < tempRating.floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              Text(
                '${tempRating.toStringAsFixed(1)}/5.0',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final prefs = StorageService.instance;
                await prefs.setDouble('restaurant_rating', tempRating);
                if (mounted) {
                  setState(() {
                    _currentRating = tempRating;
                    ratingCount++;
                  });
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.submit),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Restaurant restaurant = widget.restaurant;
    final cartProvider = context.watch<CartProvider>();
    // ignore: unnecessary_null_comparison
    final filteredCartItems = restaurant != null
        ? cartProvider.items
              .where(
                (item) =>
                    item.cartItemId.endsWith('_${restaurant.restaurantId}'),
              )
              .toList()
        : cartProvider.items;

    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || isLoading) {
          return const RestaurantShimmer();
        }

        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return BlocProvider(
              create: (_) =>
                  CategoryCubit(CategoryRepository())
                    ..fetchCategoriesByIds(restaurant.categoriesId),
              child: BlocConsumer<CategoryCubit, CategoryState>(
                listener: (context, cState) {
                  cState.when(
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
                    error: (error) => const Center(child: Text('err')),
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
                            .where(
                              (category) => category?.categoryName != null,
                            ) // Remove null categories and null names
                            .map((category) => category!.categoryName),
                      ];
                    },
                  );
                },
                builder: (context, cState) {
                  return buildBody1(
                    restaurant,
                    state,
                    context,
                    filteredCartItems,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  PopScope<dynamic> buildBody1(
    Restaurant restaurant,
    ThemeState state,
    BuildContext context,
    List<CartItem> filteredCartItems,
  ) {

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          await _removeRestaurantFromPrefs();
        }
      },
      child: DefaultTabController(
        length: filter.length,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 360,
                  pinned: true,
                  backgroundColor: state.themeMode == ThemeMode.light
                      ? Colors.white
                      : Colors.black,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Container(
                      width: 34,
                      height: 34,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: state.themeMode == ThemeMode.light
                            ? Colors.transparent
                            : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: state.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          size: 18,
                        ),
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        width: 34,
                        height: 34,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF4F4F4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () => _toggleFavorite(state),
                          icon: Icon(
                            !isFavorite
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: !isFavorite
                                ? state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white
                                : const Color(0xFFE02C45),
                            size: 18,
                          ),
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      // 🔥 Check collapse threshold
                      final collapsed =
                          constraints.biggest.height <= kToolbarHeight + 40;

                      if (collapsed != isCollapsed) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() => isCollapsed = collapsed);
                        });
                      }
                      return FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.symmetric(horizontal: 70 , vertical: 8),
                        title: isCollapsed
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: CachedNetworkImage(
                                imageUrl: widget.restaurant.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 250,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                const Icon(
                                  Icons.error,
                                  color: AppColor.primaryColor,
                                ),
                                memCacheWidth:
                                (MediaQuery.of(context).size.width *
                                    MediaQuery.of(
                                      context,
                                    ).devicePixelRatio)
                                    .round(),
                              ),
                            ),
                            Text(
                              restaurant.name,
                              style: TextStyle(
                                color: state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                            : null,
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(restaurant, state),
                            const SizedBox(height: 20),
                            _buildRestaurantInfo(restaurant, state, context),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                /// TabBar must be inside SliverToBoxAdapter
                SliverToBoxAdapter(
                  child: Column(
                    children: [const SizedBox(height: 20), _buildTabBar(state)],
                  ),
                ),
              ];
            },

            /// TabBarView body
            body: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: [
                for (final category in filter)
                  KeepAliveWidget(
                    child: FilterWidget(
                      key: ValueKey(category),
                      items: _filteredItemsMap[category] ?? [],
                      filters: category,
                      state: state,
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: _buildCartButton(filteredCartItems, context),
        ),
      ),
    );
  }

  PopScope<dynamic> buildBody(
    Restaurant restaurant,
    ThemeState state,
    BuildContext context,
    List<CartItem> filteredCartItems,
  ) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          await _removeRestaurantFromPrefs();
        }
      },
      child: DefaultTabController(
        length: filter.length,
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(restaurant, state),
                const SizedBox(height: 20.0),
                _buildRestaurantInfo(restaurant, state, context),
                const SizedBox(height: 15.0),
                _buildTabBar(state),
                _buildTabViews(state, context),
              ],
            ),
          ),
          floatingActionButton: _buildCartButton(filteredCartItems, context),
        ),
      ),
    );
  }

  Widget _buildHeader(Restaurant restaurant, ThemeState state) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              margin: const EdgeInsets.only(top: 30.0),
              decoration: ShapeDecoration(
                color: state.themeMode == ThemeMode.light
                    ? Colors.white
                    : Colors.black,
                shape: Border(
                  bottom: BorderSide(
                    color: state.themeMode == ThemeMode.light
                        ? const Color(0xFFE5E5E5)
                        : Colors.black,
                    width: 1,
                  ),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.restaurant.imageUrl!,
                fit: BoxFit.contain,
                width: double.infinity,
                height: 250,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: AppColor.primaryColor),
                memCacheWidth:
                    (MediaQuery.of(context).size.width *
                            MediaQuery.of(context).devicePixelRatio)
                        .round(),
              ),
            ),
          ],
        ),
        // SizedBox(
        //   width: MediaQuery.sizeOf(context).width,
        //   child: Padding(
        //     padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Container(
        //           width: 34,
        //           height: 34,
        //           clipBehavior: Clip.antiAlias,
        //           decoration: ShapeDecoration(
        //             color: state.themeMode == ThemeMode.light
        //                 ? const Color(0xFFF4F4F4)
        //                 : Colors.black,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //           ),
        //           child: IconButton(
        //             onPressed: () => Navigator.pop(context),
        //             icon: Icon(
        //               Icons.arrow_back,
        //               color: state.themeMode == ThemeMode.light
        //                   ? Colors.black
        //                   : Colors.white,
        //               size: 18,
        //             ),
        //             style: ButtonStyle(
        //               shape: WidgetStatePropertyAll(
        //                 RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(8),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //         const Spacer(),
        //         Container(
        //           width: 34,
        //           height: 34,
        //           clipBehavior: Clip.antiAlias,
        //           decoration: ShapeDecoration(
        //             color: const Color(0xFFF4F4F4),
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //           ),
        //           child: IconButton(
        //             onPressed: () => _toggleFavorite(state),
        //             icon: Icon(
        //               !isFavorite ? Icons.favorite_border : Icons.favorite,
        //               color: !isFavorite
        //                   ? state.themeMode == ThemeMode.light
        //                         ? Colors.black
        //                         : Colors.white
        //                   : const Color(0xFFE02C45),
        //               size: 18,
        //             ),
        //             style: ButtonStyle(
        //               shape: WidgetStatePropertyAll(
        //                 RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(8),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildRestaurantInfo(
    Restaurant restaurant,
    ThemeState state,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                restaurant.name,
                style: TextStyle(
                  color: state.themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 18.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showRatingDialog(context, state),
                child: Row(
                  children: [
                    Text(
                      '4.7',
                      style: TextStyle(
                        color: state.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
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
                      AppLocalizations.of(context)!.ratings_30265,
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
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: Border.all(color: const Color(0xFFF4F4F4), width: 2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
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
                      '${restaurant.orderTimeOut.toString()} mins',
                      style: TextStyle(
                        color: state.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
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
                    Image.asset(
                      'assets/icons/delivery_taxes.png',
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      (restaurant.deliveryFee != null)
                          ? '${AppLocalizations.of(context)!.egp} ${restaurant.deliveryFee}'
                          : AppLocalizations.of(context)!.free,
                      style: TextStyle(
                        color: state.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
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
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(ThemeState state) {
    return TabBar(
      physics: const BouncingScrollPhysics(),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      isScrollable: true,
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.start,
      unselectedLabelColor: state.themeMode == ThemeMode.light
          ? const Color(0xFF898888)
          : Colors.white,
      unselectedLabelStyle: TextStyle(
        color: state.themeMode == ThemeMode.light
            ? const Color(0xFF898888)
            : Colors.white,
        fontSize: 12.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      labelColor: const Color(0xFFE02C45),
      labelStyle: TextStyle(
        color: const Color(0xFFE02C45),
        fontSize: 12.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
      indicatorColor: const Color(0xFFE02C45),
      tabs: [for (final category in filter) Tab(text: category)],
    );
  }

  Widget _buildTabViews(ThemeState state, BuildContext context) {
    return Expanded(
      flex: 1,
      child: TabBarView(
        physics: const BouncingScrollPhysics(),
        children: [
          for (final category in filter)
            KeepAliveWidget(
              child: FilterWidget(
                key: ValueKey(category),
                items: _filteredItemsMap[category] ?? [],
                filters: category,
                state: state,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartButton(List<CartItem> filteredItems, BuildContext context) {
    return Badge(
      label: Text('${filteredItems.length}'),
      alignment: AlignmentDirectional.topStart,
      backgroundColor: Colors.white,
      textColor: const Color(0xFFE02C45),
      isLabelVisible: true,
      smallSize: 12,
      child: FloatingActionButton(
        onPressed: () => navigateTo(context, 'MyCartScreenRoute'),
        backgroundColor: const Color(0xFFE02C45),
        shape: const CircleBorder(side: BorderSide(color: Color(0xFFE02C45))),
        child: Image.asset('assets/icons/cart.png', height: 20, width: 20),
      ),
    );
  }
}
