import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:just_order/screens/home/main_home_screen/place_details_sheet.dart';
import 'package:just_order/screens/home/main_home_screen/widgets/categories_widget.dart';
import 'package:just_order/screens/home/main_home_screen/widgets/popular_today_widget.dart';
import 'package:just_order/screens/home/main_home_screen/widgets/restaurants_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = 'HomeScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String tableCode = '';
  int _currentPage = 0;
  List<Restaurant> restaurants = [];

  final List<String> adsImageList = [
    "assets/images/blackAdv.jpg",
    "assets/images/basicAdv.jpg",
    "assets/images/blackAdv.jpg",
    "assets/images/basicAdv.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _loadTableCode();
  }

  Future<void> _loadTableCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tableCode = prefs.getString('code') ?? 'Unknown';
    });
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    final UserRepository userRepository = UserRepository();
    final List<Restaurant> restaurants =
        await userRepository.getRestaurants(tableCode);
    setState(() {
      this.restaurants = restaurants;
    });
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return const PlaceDetailsSheet();
        },
        useSafeArea: true,
        backgroundColor: Colors.white,
        constraints: BoxConstraints(
          maxHeight: 200,
          maxWidth: MediaQuery.sizeOf(context).width,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0x0CE02C45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFFE02C45),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 36,
                child: MaterialButton(
                  onPressed: () {
                    openBottomSheet(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivering to',
                        style: TextStyle(
                          color: Color(0xFF878787),
                          fontSize: 8,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Table $tableCode',
                        style: const TextStyle(
                          color: Colors.black,
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
              ),
            ],
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 6.0, top: 10.0),
        //     child: Container(
        //       width: 36,
        //       height: 36,
        //       clipBehavior: Clip.antiAlias,
        //       decoration: ShapeDecoration(
        //         color: const Color(0xFFF4F4F4),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //       ),
        //       child: IconButton(
        //         onPressed: () {},
        //         icon: const Icon(
        //           Icons.search_outlined,
        //           color: Colors.black,
        //           size: 18,
        //         ),
        //         style: ButtonStyle(
        //           shape: WidgetStatePropertyAll(
        //             RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20.0, top: 10.0),
        //     child: Container(
        //       width: 36,
        //       height: 36,
        //       clipBehavior: Clip.antiAlias,
        //       decoration: ShapeDecoration(
        //         color: const Color(0xFFF4F4F4),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //       ),
        //       child: IconButton(
        //         onPressed: () {},
        //         icon: const Icon(
        //           Icons.notifications,
        //           color: Colors.black,
        //           size: 18,
        //         ),
        //         style: ButtonStyle(
        //           shape: WidgetStatePropertyAll(
        //             RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ads Part
              CarouselSlider(
                items: adsImageList
                    .map(
                      (e) => Center(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: AssetImage(e),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                    initialPage: 0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    onPageChanged: (value, _) {
                      setState(() {
                        _currentPage = value;
                      });
                    }),
              ),
              const SizedBox(height: 5.0),
              Container(
                width: MediaQuery.sizeOf(context).width,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < adsImageList.length; i++)
                      Container(
                        margin: const EdgeInsets.all(5),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? const Color(0xFFE02C45)
                              : const Color(0x0CE02C45),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 25.0),
              // All Restaurants
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'All Restaurants',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 12.0),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 100.0,
                child: ListView.separated(
                  itemBuilder: (context, index) =>
                      buildCategoriesWidget(restaurants[index]),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10.0),
                  itemCount: restaurants.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
              // const SizedBox(height: 12.0),
              // SizedBox(
              //   width: MediaQuery.sizeOf(context).width,
              //   height: 31.0,
              //   child: ListView.separated(
              //     itemBuilder: (context, index) => buildHomeFilterWidget(
              //         filters[index], index,
              //         onPressed: () {}),
              //     separatorBuilder: (context, index) =>
              //         const SizedBox(width: 10.0),
              //     itemCount: 4,
              //     scrollDirection: Axis.horizontal,
              //     physics: const BouncingScrollPhysics(),
              //     shrinkWrap: true,
              //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //   ),
              // ),
              const SizedBox(height: 25.0),
              // Popular Today
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Popular Today',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    // const Spacer(),
                    // TextButton(
                    //   onPressed: () {},
                    //   style: ButtonStyle(
                    //     overlayColor:
                    //         WidgetStateProperty.all(Colors.transparent),
                    //   ),
                    //   child: const Text(
                    //     'View All',
                    //     style: TextStyle(
                    //       color: Color(0xFFE02C45),
                    //       fontSize: 10,
                    //       fontFamily: 'Inter',
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //     overflow: TextOverflow.ellipsis,
                    //     maxLines: 1,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 201.0,
                child: ListView.separated(
                  itemBuilder: (context, index) => buildPopularTodayWidget(
                      context: context, restaurant: restaurants[index]),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10.0),
                  itemCount: min(restaurants.length, 5),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
              const SizedBox(height: 25.0),
              // Restaurants
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: ListView.separated(
                  itemBuilder: (context, index) => buildRestaurantsWidget(
                      context: context, restaurant: restaurants[index]),
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  itemCount: restaurants.length,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
