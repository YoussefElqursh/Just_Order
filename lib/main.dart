import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/justorder.dart';
import 'package:just_order/repository/cart_provider.dart';
import 'package:just_order/repository/order_provider.dart';
import 'package:just_order/core/helpers/bloc_observer.dart';
import 'package:just_order/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:just_order/core/storage/storage_service.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    StorageService.init(),
    _initFirebase(),
    dotenv.load(fileName: 'assets/.env'),
  ]);
  await setupServiceLocator();

  final themeCubit = ThemeCubit();
  await Future.wait([
    themeCubit.loadTheme(),
    GoogleSignIn.instance.initialize(
      serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
    ),
  ]);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();

  runApp(_buildApp(themeCubit));
}

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
    // Already initialized natively — safe to continue.
    debugPrint('Firebase already initialized natively, skipping.');
  }
}

/// Builds the root widget wrapped with localization, providers, and theming
Widget _buildApp(ThemeCubit themeCubit) {
  return BlocProvider.value(
    value: themeCubit,
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}