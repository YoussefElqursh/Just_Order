import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en')) {
    _loadInitialLocale();
  }

  // Load the locale asynchronously and emit it
  Future<void> _loadInitialLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'en';
    emit(Locale(localeCode));
  }

  Future<void> switchToEnglish() async {
    emit(const Locale('en'));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', 'en');
  }

  Future<void> switchToArabic() async {
    emit(const Locale('ar'));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', 'ar');
  }
}
