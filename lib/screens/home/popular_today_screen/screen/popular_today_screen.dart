import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:just_order/screens/home/main_home_screen/widgets/popular_today_widget.dart';
import 'package:just_order/screens/home/popular_today_screen/logic/popular_today_cubit.dart';
import 'package:just_order/core/theme/colors.dart';

class PopularTodayScreen extends StatelessWidget {
  const PopularTodayScreen({super.key});

  static const String routeName = 'PopularTodayScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const PopularTodayScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PopularTodayCubit(UserRepository())..loadData(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Popular Today",
                style: TextStyle(
                  color: themeState.themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF4F4F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            body: BlocBuilder<PopularTodayCubit, PopularTodayState>(
              builder: (context, state) {
                if (state.status == PopularTodayStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    ),
                  );
                }

                if (state.status == PopularTodayStatus.failure) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                }

                final cubit = context.read<PopularTodayCubit>();
                final user = state.user;

                return Column(
                  children: [
                    // 🔍 Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: cubit.searchRestaurants,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search restaurant...',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0x4CAFAFAF),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xFFE02C45),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0x4CAFAFAF),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          filled: true,
                          fillColor: themeState.themeMode == ThemeMode.light
                              ? Colors.white
                              : Colors.grey[850],
                        ),
                      ),
                    ),

                    // 🏪 List of Restaurants
                    Expanded(
                      child: ListView.separated(
                        itemCount: min(state.filteredRestaurants.length, 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ).copyWith(top: 10),
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (_, _) => const SizedBox(height: 25),
                        itemBuilder: (context, index) {
                          final restaurant = state.filteredRestaurants[index];
                          return buildPopularTodayScreen(
                            context: context,
                            restaurant: restaurant,
                            state: themeState,
                            user: user!,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
