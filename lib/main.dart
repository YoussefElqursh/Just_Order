import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/justorder.dart';
import 'package:just_order/repository/cart_provider.dart';
import 'package:just_order/repository/order_provider.dart';
import 'package:just_order/services/deep_link_listener.dart';
import 'package:just_order/shared/bloc_observer/bloc_observer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

late final SharedPreferences prefs;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background message: ${message.messageId}');
}

Future<void> main() async {
  await _initializeApp();
  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme();

  runApp(
    _buildApp(themeCubit),
  );
}

/// Initializes all required services and plugins
Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: 'assets/.env');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
}

/// Builds the root widget wrapped with localization, providers, and theming
Widget _buildApp(ThemeCubit themeCubit) {
  return EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: BlocProvider.value(
      value: themeCubit,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
        ],
        child: const DeepLinkListener(
          child: MyApp(),
        ),
      ),
    ),
  );
}
