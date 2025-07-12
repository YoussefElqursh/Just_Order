import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'package:just_order/services/deep_link_listener.dart';
import 'package:just_order/shared/routing/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FingerprintCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => LoginCubit(LoginRepository())),
        BlocProvider(create: (_) => SignUpCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => const _AppView(),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return DeepLinkListener(
              child: MaterialApp(
                title: 'Just Order',
                debugShowCheckedModeBanner: false,
                locale: locale,
                supportedLocales: L10n.all,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  return supportedLocales.contains(deviceLocale)
                      ? deviceLocale
                      : const Locale('en');
                },
                themeMode: themeState.themeMode,
                theme: _lightTheme,
                darkTheme: _darkTheme,
                onGenerateRoute: AppRouter.onGenerateRoute,
                initialRoute: SplashScreen.routeName,
              ),
            );
          },
        );
      },
    );
  }
}

// Theme Constants
const _primaryColor = Color(0xFFE02C45);
const _unselectedColor = Color(0xFF898888);

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

final _lightTheme = ThemeData(
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

final _darkTheme = ThemeData(
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

Future<Locale> getUserPreferredLocal() async {
  final prefs = await SharedPreferences.getInstance();
  final localeCode = prefs.getString('locale') ?? 'en';
  return Locale(localeCode);
}
