import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:just_order/screens/3-home_screen/widgets/categories_widget.dart';
import 'package:just_order/screens/3-home_screen/widgets/filter_widget.dart';
import 'package:just_order/screens/3-home_screen/widgets/popular_today_widget.dart';
import 'package:just_order/screens/3-home_screen/widgets/restaurants_widget.dart';
import 'package:just_order/shared/constant/lists/lists.dart';

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

int _currentPage = 0;

class _HomeScreenState extends State<HomeScreen> {
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
                width: 30,
                height: 30,
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
              const SizedBox(width: 10),
              const SizedBox(
                width: 140,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                    SizedBox(height: 3),
                    Text(
                      'Table: 15489',
                      style: TextStyle(
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
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 10.0),
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
                onPressed: () {
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
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
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ads Part
              CarouselSlider(
                items: adsImageList
                    .map(
                      (e) => Center(
                        child: Image.network(e, fit: BoxFit.cover, height: 200,),
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
                width: double.infinity,
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
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: Color(0xFFE02C45),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13.0),
              SizedBox(
                width: double.infinity,
                height: 201.0,
                child: ListView.separated(
                  itemBuilder: (context, index) => buildPopularTodayWidget(context: context),
                  separatorBuilder: (context, index) => const SizedBox(width: 10.0),
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                width: double.infinity,
                height: 100.0,
                child: ListView.separated(
                  itemBuilder: (context, index) => buildCategoriesWidget(),
                  separatorBuilder: (context, index) => const SizedBox(width: 10.0),
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
              const SizedBox(height: 12.0),
              SizedBox(
                width: double.infinity,
                height: 31.0,
                child: ListView.separated(
                  itemBuilder: (context, index) => buildHomeFilterWidget(),
                  separatorBuilder: (context, index) => const SizedBox(width: 10.0),
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
              const SizedBox(height: 12.0),
              SizedBox(
                width: double.infinity,
                child: ListView.separated(
                  itemBuilder: (context, index) => buildRestaurantsWidget(context: context),
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(height: 1, color: Colors.grey,),
                  ),
                  itemCount: 5,
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
