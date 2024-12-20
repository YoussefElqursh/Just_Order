import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/repository/cart_provider.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/filter_widget.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    'Pizza',
    'Crepes',
    'Pies',
    'Beverages',
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
    await prefs.setString('restaurant', jsonEncode(widget.restaurant.toJson()));
  }

  Future<void> _removeRestaurantFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('restaurant');
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
    return PopScope(
      onPopInvokedWithResult: _onWillPop as void Function(bool, dynamic)?,
      child: DefaultTabController(
        length: 7,
        child: Scaffold(
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
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
                                    image: NetworkImage(restaurant.imageUrl ??
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
                                      image: NetworkImage(restaurant.imageUrl ??
                                          'https://via.placeholder.com/150'),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF4F4F4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.black,
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                restaurant.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                '4.7',
                                style: TextStyle(
                                  color: Colors.black,
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
                              const Text(
                                '(30,265 Ratings)',
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Pizza, Pies, Crepes ',
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.timer_outlined,
                                      color: Color(0xFFE02C45), size: 15),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    restaurant.orderTimeOut.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
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
                                        ? 'EGP ${restaurant.deliveryFee}'
                                        : 'Free',
                                    style: const TextStyle(
                                      color: Colors.black,
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
                          unselectedLabelColor: const Color(0xFF898888),
                          unselectedLabelStyle: const TextStyle(
                            color: Color(0xFF898888),
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
                            Tab(text: filter[0]),
                            Tab(text: filter[1]),
                            Tab(text: filter[2]),
                            Tab(text: filter[3]),
                            Tab(text: filter[4]),
                            Tab(text: filter[5]),
                            Tab(text: filter[6]),
                          ],
                        ),
                        SafeArea(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(
                              children: [
                                FilterWidget(items: items, filters: filter[0],),
                                FilterWidget(items: items, filters: filter[1],),
                                FilterWidget(items: items, filters: filter[2],),
                                FilterWidget(items: items, filters: filter[3],),
                                FilterWidget(items: items, filters: filter[4],),
                                FilterWidget(items: items, filters: filter[5],),
                                FilterWidget(items: items, filters: filter[6],),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
  }
}
