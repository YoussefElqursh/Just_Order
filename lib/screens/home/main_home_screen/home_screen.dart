import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/category_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/category_repository.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:just_order/screens/home/main_home_screen/place_details_sheet.dart';
import 'package:just_order/screens/home/main_home_screen/widgets/categories_widget.dart';
import 'package:just_order/screens/home/main_home_screen/widgets/filter_widget.dart';
import 'package:just_order/screens/home/main_home_screen/widgets/home_shimmer_widget.dart';
import 'package:just_order/screens/home/main_home_screen/widgets/popular_today_widget.dart';
import 'package:just_order/screens/home/main_home_screen/widgets/restaurants_widget.dart';
import 'package:just_order/core/theme/colors.dart';
import 'package:just_order/core/storage/storage_service.dart';

class HomeScreen extends StatefulWidget {
  final String? tableCode;
  const HomeScreen({super.key, this.tableCode});

  static const String routeName = 'HomeScreenRoute';
  static Route route() => MaterialPageRoute(
    settings: const RouteSettings(name: routeName),
    builder: (_) => const HomeScreen(),
  );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  late Future<void> _initFuture;
  late User user;
  String tableCode = '';

  List<Restaurant> restaurants = [];
  List<Categories?> categories = [];

  final adsImageList = const [
    "assets/images/blackAdv.jpg",
    "assets/images/basicAdv.jpg",
    "assets/images/blackAdv.jpg",
    "assets/images/basicAdv.jpg",
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeData();

    // Auto dismiss after 1 minute (if needed)
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  Future<void> _initializeData() async {
    final prefs = StorageService.instance;
    final storedUser = prefs.getString('user');
    final storedTableCode = prefs.getString('code') ?? widget.tableCode ?? 'Unknown';

    user = (storedUser != null ? User.fromJson(jsonDecode(storedUser)) : User.empty())!;
    tableCode = storedTableCode;

    final userRepository = UserRepository();
    final categoryRepository = CategoryRepository();

    final results = await Future.wait([
      userRepository.getRestaurants(storedTableCode),
      categoryRepository.getCategories(),
    ]);

    restaurants = results[0] as List<Restaurant>;
    categories = results[1] as List<Categories?>;
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      constraints: BoxConstraints(
        maxHeight: 400,
        maxWidth: MediaQuery.sizeOf(context).width,
      ),
      builder: (_) => PlaceDetailsSheet(tableCode: tableCode),
    );
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: FutureBuilder(
            future: _initFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return buildShimmerPlaceholder();
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return RefreshIndicator(
                color: AppColor.primaryColor,
                onRefresh: _initializeData,
                child: _buildHomeContent(context, state),
              );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeState state) {
    final isLight = state.themeMode == ThemeMode.light;
    return AppBar(
      leadingWidth: 200,
      shadowColor: Colors.grey,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isLight
                    ? const Color(0x0CE02C45)
                    : const Color(0x5FE02C45),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.location_on_outlined,
                  color: Color(0xFFE02C45)),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _openBottomSheet(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.delivering_to,
                    style: TextStyle(
                      color: isLight ? const Color(0xFF878787) : Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${AppLocalizations.of(context)!.table} $tableCode',
                    style: TextStyle(
                      color: isLight ? Colors.black : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, ThemeState state) {
    final width = MediaQuery.sizeOf(context).width;
    final isLight = state.themeMode == ThemeMode.light;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _buildCarousel(width),
        const SizedBox(height: 25),
        _buildSectionHeader(
          context,
          title: AppLocalizations.of(context)!.all_restaurants,
          onViewAll: () => Navigator.pushNamed(context, 'CategoryScreenRoute'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) =>
                buildCategoriesWidget(categories[index]!, state),
          ),
        ),
        const SizedBox(height: 25),
        _buildSectionHeader(
          context,
          title: AppLocalizations.of(context)!.popular_today,
          onViewAll: () =>
              Navigator.pushNamed(context, 'PopularTodayScreenRoute'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 201,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: min(restaurants.length, 5),
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) => buildPopularTodayWidget(
              context: context,
              restaurant: restaurants[index],
              state: state,
              user: user,
            ),
          ),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppLocalizations.of(context)!.all_restaurants,
            style: TextStyle(
              color: isLight ? Colors.black : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 31,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: filters.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) => buildHomeFilterWidget(
              filters[index],
              index,
              onPressed: () {},
            ),
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          itemCount: restaurants.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) => RestaurantWidget(
            restaurant: restaurants[index],
            state: state,
            user: user,
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel(double width) {
    return Column(
      children: [
        CarouselSlider(
          items: adsImageList
              .map(
                (e) => Container(
              width: width,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(e),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
              .toList(),
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (i, _) => _currentPageNotifier.value = i,
          ),
        ),
        const SizedBox(height: 5),
        ValueListenableBuilder<int>(
          valueListenable: _currentPageNotifier,
          builder: (_, currentPage, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                adsImageList.length,
                    (i) => Container(
                  margin: const EdgeInsets.all(5),
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: i == currentPage
                        ? const Color(0xFFE02C45)
                        : const Color(0x2FE02C45),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context,
      {required String title, required VoidCallback onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onViewAll,
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
            child: const Text(
              'View All',
              style: TextStyle(
                color: Color(0xFFE02C45),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
