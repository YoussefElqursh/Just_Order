import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/theming/theming_state.dart';

/// Scrollable pill-style TabBar listing menu categories/filters
/// (e.g. "Trending", "Discounts", plus each fetched category name).
class RestaurantTabBar extends StatelessWidget {
  final List<String> filters;
  final ThemeState state;

  const RestaurantTabBar({super.key, required this.filters, required this.state});

  bool get _isLight => state.themeMode == ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      physics: const BouncingScrollPhysics(),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      isScrollable: true,
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.start,
      unselectedLabelColor: _isLight ? const Color(0xFF898888) : Colors.white,
      unselectedLabelStyle: TextStyle(
        color: _isLight ? const Color(0xFF898888) : Colors.white,
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
      tabs: [for (final category in filters) Tab(text: category)],
    );
  }
}
