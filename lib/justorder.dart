import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/fingerprint/fingerprint_cubit.dart';
import 'package:just_order/blocs/localization/language_cubit.dart';
import 'package:just_order/blocs/login_cubit/login_cubit.dart';
import 'package:just_order/blocs/sign_up_cubit/sign_up_cubit.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/l10n/l10n.dart';
import 'package:just_order/repository/auth_repository/login_repository.dart';
import 'package:just_order/screens/splash/splash_screen.dart';
import 'package:just_order/shared/routing/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FingerprintCubit()),
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => LoginCubit(LoginRepository())),
        BlocProvider(create: (context) => SignUpCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, child) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return MaterialApp(
                    supportedLocales: L10n.all,
                    locale: locale,
                    // Locale from LanguageCubit
                    localeResolutionCallback: (locale, supportedLocales) {
                      if (locale != null && supportedLocales.contains(locale)) {
                        return locale;
                      }
                      return const Locale('en'); // Default fallback
                    },
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    debugShowCheckedModeBanner: false,
                    title: 'Just Order',
                    themeMode: state.themeMode,
                    darkTheme: ThemeData(
                      useMaterial3: true,
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor: Colors.black,
                      primaryColor: const Color(0xFFE02C45),
                      indicatorColor: const Color(0xFFE02C45),
                      appBarTheme: const AppBarTheme(
                        color: Colors.black,
                        foregroundColor: Colors.black,
                        surfaceTintColor: Colors.black,
                        elevation: 0.5,
                      ),
                      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                        selectedItemColor: Color(0xFFE02C45),
                        unselectedItemColor: Color(0xFF898888),
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.black,
                        selectedLabelStyle: TextStyle(
                          color: Color(0xFFE02C45),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: TextStyle(
                          color: Color(0xFF898888),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    theme: ThemeData(
                      useMaterial3: true,
                      brightness: Brightness.light,
                      scaffoldBackgroundColor: Colors.white,
                      primaryColor: const Color(0xFFE02C45),
                      indicatorColor: const Color(0xFFE02C45),
                      appBarTheme: const AppBarTheme(
                        color: Colors.white,
                        foregroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        elevation: 0.5,
                      ),
                      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                        selectedItemColor: Color(0xFFE02C45),
                        unselectedItemColor: Color(0xFF898888),
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.white,
                        selectedLabelStyle: TextStyle(
                          color: Color(0xFFE02C45),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: TextStyle(
                          color: Color(0xFF898888),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onGenerateRoute: AppRouter.onGenerateRoute,
                    initialRoute: SplashScreen.routeName,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
Future<Locale> getUserPreferredLocal() async {
  final prefs = await SharedPreferences.getInstance();
  final localeCode = prefs.getString('locale') ?? 'en';
  return Locale(localeCode);
}
