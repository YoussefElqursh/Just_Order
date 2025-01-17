import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_order/main.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en'));

  void switchToEnglish()async {
  await prefs.setString('locale','en');

  }
  void switchToArabic() async {

   await prefs.setString('locale','ar');
  }
}
