import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en'));

  void switchToEnglish() => emit(const Locale('en'));
  void switchToArabic() => emit(const Locale('ar'));
}
