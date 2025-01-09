import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());

  final String _themeKey = 'theme_mode';

  // Load theme from SharedPreferences
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.light.index;
    emit(state.copyWith(themeMode: ThemeMode.values[themeIndex]));
  }

  // Toggle theme and persist the change
  Future<void> toggleTheme() async {
    final newTheme =
    state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: newTheme));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, newTheme.index);
  }
}
