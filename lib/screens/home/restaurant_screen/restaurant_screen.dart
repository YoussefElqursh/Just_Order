import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/repository/cart_provider.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/filter_widget.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantScreen({super.key, required this.restaurant});

  static const String routeName = 'RestaurantScreenRoute';

  static Route route(Restaurant restaurant) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => RestaurantScreen(restaurant: restaurant),
    );
  }

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  late List<Item> items;
  final UserRepository userRepository = UserRepository();
  bool isLoading = true;

  List<String> filter = [
    'Trending',
    'Discounts',
    'Up to 40% off',
    'Meals',
    'Sandwich',
    'Salad',
    'Pizza',
    'Crepe',
    'Beverages',
    'Soft Drinks',
    'Desserts',
  ];

  @override
  void initState() {
    super.initState();
    _loadItems();
    _addRestaurantToPrefs();
  }

  Future<void> _loadItems() async {
    final fetchItems = await userRepository.getItems(widget.restaurant.itemIds);
    setState(() {
      items = fetchItems;
      isLoading = false;
    });
  }

  Future<void> _addRestaurantToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppLocalizations.of(context)!.restaurant_name, jsonEncode(widget.restaurant.toJson()));
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
    Restaurant restaurant = widget.restaurant;
    final cartProvider = Provider.of<CartProvider>(context);
    final filteredItems = restaurant != null
        ? cartProvider.items
            .where((item) =>
                item.cartItemId.endsWith('_${restaurant.restaurantId}'))
            .toList()
        : cartProvider.items;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return PopScope(
          onPopInvokedWithResult: _onWillPop as void Function(bool, dynamic)?,
          child: DefaultTabController(
            length: 11,
            child: Scaffold(
              body: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFE02C45),))
                  : SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(alignment: Alignment.topCenter, children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 250,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(restaurant
                                            .imageUrl ??
                                        'https://via.placeholder.com/150'),
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
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(restaurant
                                              .imageUrl ??
                                          'https://via.placeholder.com/150'),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: state.themeMode == ThemeMode.light ? const Color(0xFFF4F4F4) : Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                        size: 18,
                                      ),
                                      style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // const Spacer(),
                                  // Container(
                                  //   width: 34,
                                  //   height: 34,
                                  //   clipBehavior: Clip.antiAlias,
                                  //   decoration: ShapeDecoration(
                                  //     color: const Color(0xFFF4F4F4),
                                  //     shape: RoundedRectangleBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(8)),
                                  //   ),
                                  //   child: IconButton(
                                  //     onPressed: () {},
                                  //     icon: const Icon(
                                  //       Icons.favorite_border,
                                  //       color: Colors.black,
                                  //       size: 18,
                                  //     ),
                                  //     style: ButtonStyle(
                                  //       shape: WidgetStatePropertyAll(
                                  //         RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(8),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 55),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                restaurant.name,
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
                                  color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(width: 3),
                              Icon(Icons.star,
                                  color: Colors.yellow.shade700, size: 15),
                              const SizedBox(width: 3),
                               Text(
                                AppLocalizations.of(context)!.ratings_30265,
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
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            AppLocalizations.of(context)!.pizza_pies_crepes,
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.timer_outlined,
                                      color: Color(0xFFE02C45), size: 15),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    restaurant.orderTimeOut.toString(),
                                    style: TextStyle(
                                      color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        color: Color(0x66AFAFAF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.delivery_dining,
                                    color: Color(0xFFE02C45),
                                    size: 15,
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    (restaurant.deliveryFee != null)
                                        ? '${AppLocalizations.of(context)!.egp} ${restaurant.deliveryFee}'
                                        : AppLocalizations.of(context)!.free,
                                    style: TextStyle(
                                      color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
                          overlayColor: const WidgetStatePropertyAll(
                              Colors.transparent),
                          isScrollable: true,
                          dividerColor: Colors.transparent,
                          tabAlignment: TabAlignment.start,
                          unselectedLabelColor: state.themeMode == ThemeMode.light ? const Color(0xFF898888) : Colors.white,
                          unselectedLabelStyle: TextStyle(
                            color: state.themeMode == ThemeMode.light ? const Color(0xFF898888) : Colors.white,
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
                            Tab(text: filter[0]),//Trending
                            Tab(text: filter[1]),//Discounts
                            Tab(text: filter[2]),//Up to 40% off
                            Tab(text: filter[3]),//meal
                            Tab(text: filter[4]),//sandwich
                            Tab(text: filter[5]),//salad
                            Tab(text: filter[6]),//pizza
                            Tab(text: filter[7]),//crepe
                            Tab(text: filter[8]),//beverages
                            Tab(text: filter[9]),//softDrink
                            Tab(text: filter[10],//dessert
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: MediaQuery.sizeOf(context).height - 480,
                            child: TabBarView(
                              children: [
                                FilterWidget(
                                  items: items
                                      .where((element) => element.category == filter[0])
                                      .toList(),
                                  filters: filter[0],
                                  state: state,
                                ),
                                FilterWidget(
                                  items: items
                                      .where((element) => element.category == filter[1])
                                      .toList(),
                                  filters: filter[1],
                                  state: state,
                                ),
                                FilterWidget(
                                  items: items
                                      .where((element) => element.category == filter[2])
                                      .toList(),
                                  filters: filter[2],
                                  state: state,
                                ),
                                FilterWidget(
                                  items: items
                                      .where((element) => element.category == filter[3])
                                      .toList(),
                                  filters: filter[3],
                                  state: state,
                                ),
                                FilterWidget(
                                  items: items
                                      .where((element) => element.category == filter[4])
                                      .toList(),
                                  filters: filter[4],
                                  state: state,
                                ),
                                FilterWidget(
                                  items: items
                                      .where((element) => element.category == filter[5])
                                      .toList(),
                                  filters: filter[5],
                                  state: state,
                                ),
                                FilterWidget(
                                  items: items
                                      .where((element) => element.category == filter[6])
                                      .toList(),
                                  filters: filter[6],
                                  state: state,
                                ),
                                FilterWidget(
                                  items: items
                                      .where((element) => element.category == filter[7])
                                      .toList(),
                                  filters: filter[7],
                                  state: state,
                                ),
                                FilterWidget(
                                  items: items
                                      .where((element) => (element.category == filter[8]))
                                      .toList(),
                                  filters: filter[8],
                                  state: state,
                                ),
                                FilterWidget(
                                  items: items
                                      .where((element) =>  element.category == filter[9])
                                      .toList(),
                                  filters: filter[9],
                                  state: state,
                                ),
                                FilterWidget(
                                  items: items
                                      .where((element) => element.category == filter[10])
                                      .toList(),
                                  filters: filter[10],
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
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
