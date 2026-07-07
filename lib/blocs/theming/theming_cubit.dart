import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/core/storage/storage_service.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());

  final String _themeKey = 'theme_mode';

  // Load theme from StorageService
  Future<void> loadTheme() async {
    final prefs = StorageService.instance;
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.light.index;
    emit(state.copyWith(themeMode: ThemeMode.values[themeIndex]));
  }

  // Toggle theme and persist the change
  Future<void> toggleTheme() async {
    final newTheme =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: newTheme));
    final prefs = StorageService.instance;
    await prefs.setInt(_themeKey, newTheme.index);
  }
}
