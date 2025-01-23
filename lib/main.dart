import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/fingerprint/fingerprint_cubit.dart';
import 'package:just_order/blocs/localization/language_cubit.dart';
import 'package:just_order/blocs/login_cubit/login_cubit.dart';
import 'package:just_order/blocs/sign_up_cubit/sign_up_cubit.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/l10n/l10n.dart';
import 'package:just_order/repository/auth_repository/login_repository.dart';
import 'package:just_order/repository/cart_provider.dart';
import 'package:just_order/repository/order_provider.dart';
import 'package:just_order/screens/splash/splash_screen.dart';
import 'package:just_order/shared/bloc_observer/bloc_observer.dart';
import 'package:just_order/shared/routing/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late final prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  await dotenv.load(fileName: "assets/.env");
  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme(); // Load saved theme before running the app
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: BlocProvider(
        create: (context) => ThemeCubit(),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
          ],
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                    localizationsDelegates: [
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
                        selectedItemColor: const Color(0xFFE02C45),
                        unselectedItemColor: const Color(0xFF898888),
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.black,
                        selectedLabelStyle: const TextStyle(
                          color: Color(0xFFE02C45),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: const TextStyle(
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
                        selectedItemColor: const Color(0xFFE02C45),
                        unselectedItemColor: const Color(0xFF898888),
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.white,
                        selectedLabelStyle: const TextStyle(
                          color: Color(0xFFE02C45),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: const TextStyle(
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
