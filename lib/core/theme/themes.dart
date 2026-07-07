import 'package:flutter/material.dart';
import 'package:just_order/core/theme/colors.dart';


const _primaryColor = AppColor.primaryColor;
const _unselectedColor = AppColor.grayDarkColor;
const _textStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 12,
  fontWeight: FontWeight.w600,
);
final _bottomNavBarTheme = BottomNavigationBarThemeData(
  selectedItemColor: _primaryColor,
  unselectedItemColor: _unselectedColor,
  type: BottomNavigationBarType.fixed,
  selectedLabelStyle: _textStyle.copyWith(color: _primaryColor),
  unselectedLabelStyle: _textStyle.copyWith(color: _unselectedColor),
);
class AppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: _primaryColor,
    indicatorColor: _primaryColor,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.white,
      elevation: 0.5,
    ),
    bottomNavigationBarTheme: _bottomNavBarTheme.copyWith(
      backgroundColor: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: _primaryColor,
    indicatorColor: _primaryColor,
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.black,
      elevation: 0.5,
    ),
    bottomNavigationBarTheme: _bottomNavBarTheme.copyWith(
      backgroundColor: Colors.black,
    ),
  );
}
