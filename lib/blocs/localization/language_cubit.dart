import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/core/storage/storage_service.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en')) {
    _loadInitialLocale();
  }

  // Load the locale asynchronously and emit it
  Future<void> _loadInitialLocale() async {
    final prefs = StorageService.instance;
    final localeCode = prefs.getString('locale') ?? 'en';
    emit(Locale(localeCode));
  }

  Future<void> switchToEnglish() async {
    emit(const Locale('en'));
    final prefs = StorageService.instance;
    await prefs.setString('locale', 'en');
  }

  Future<void> switchToArabic() async {
    emit(const Locale('ar'));
    final prefs = StorageService.instance;
    await prefs.setString('locale', 'ar');
  }
}
