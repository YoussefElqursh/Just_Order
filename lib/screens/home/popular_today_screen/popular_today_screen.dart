import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:just_order/screens/home/main_home_screen/widgets/popular_today_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopularTodayScreen extends StatefulWidget {
  const PopularTodayScreen({super.key});

  static const String routeName = 'PopularTodayScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const PopularTodayScreen(),
    );
  }

  @override
  State<PopularTodayScreen> createState() => _PopularTodayScreenState();
}

class _PopularTodayScreenState extends State<PopularTodayScreen> {
  List<Restaurant> restaurants = [];
  late User user;
  String tableCode = '';

  @override
  void initState() {
    super.initState();
    _loadTableCode();
    _userFromPreferences();
  }

  Future<void> _loadTableCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tableCode = prefs.getString('code') ?? 'Unknown';
    });
    _loadRestaurants();
  }

  Future<void> _userFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      final user = User.fromJson(jsonDecode(userString));
      setState(() {
        this.user = user!;
      });
    }
  }

  Future<void> _loadRestaurants() async {
    try {
      final UserRepository userRepository = UserRepository();
      final List<Restaurant> restaurants =
          await userRepository.getRestaurants(tableCode);

      setState(() {
        this.restaurants = restaurants;
      });
    } catch (e) {
      // Handle error (e.g., show a snackbar or log the error)\
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Popular Today",
              style: TextStyle(
                color: state.themeMode == ThemeMode.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            leading: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
              child: Container(
                width: 34,
                height: 34,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF4F4F4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
                ),
              ),
            ),
          ),
          body: ListView.separated(
            itemBuilder: (context, index) => buildPopularTodayScreen(
              context: context,
              restaurant: restaurants[index],
              state: state,
              user: user,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 25.0),
            itemCount: min(restaurants.length, 5),
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(top: 10.0),
          ),
        );
      },
    );
  }
}
