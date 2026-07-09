import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/screens/entry/app_entry_screen.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:just_order/shared/function/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:just_order/core/storage/storage_service.dart';
import 'package:just_order/core/services/notification_service.dart';
import 'package:just_order/core/di/service_locator.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = 'SplashScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SplashScreen(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _retryTimer;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _initializeApp);
  }

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return 'Version ${packageInfo.version}';
  }

  Future<(User?, String?, int?)> _loadUserAndTableInfo() async {
    final prefs = StorageService.instance;
    final userString = prefs.getString('user');
    final tableCode = prefs.getString('code');
    final timestamp = prefs.getInt('timestamp');

    final user = userString != null ? User.fromJson(jsonDecode(userString)) : null;
    return (user, tableCode, timestamp);
  }

  Future<void> _initializeApp() async {
    try {
      final results = await Future.wait([
        isConnected(),
        _loadUserAndTableInfo(),
      ]);

      final isConnectedResult = results[0] as bool;
      final (User? user, String? tableCode, int? timestamp) = results[1] as (User?, String?, int?);

      if (!mounted) return;

      if (isConnectedResult) {
        await _navigate(user, tableCode, timestamp);
      } else {
        _showNoInternetDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Initialization failed: $e')),
        );
        debugPrint('Initialization failed: $e');
      }
    }
  }

  void _showNoInternetDialog() {
    if (!_dialogShown && mounted) {
      _dialogShown = true;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.no_internet_connection),
          content: Text(
            AppLocalizations.of(context)!
                .please_check_your_internet_connection_and_try_again,
          ),
        ),
      );
    }

    _retryTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final isConnect = await isConnected();
      if (!mounted) return;

      if (isConnect) {
        timer.cancel();
        _initializeApp();
      }
    });
  }

  Future<void> _navigate(User? user, String? tableCode, int? timestamp) async {
    if (user == null) {
      if (mounted) Navigator.of(context).pushReplacement(AppEntryScreen.route());
      return;
    }

    final firestore = FirebaseFirestore.instance;

    final result = await firestore
        .collection('users')
        .where('email', isEqualTo: user.email)
        .where('password', isEqualTo: user.password)
        .where('emailVerified', isEqualTo: true)
        .where('phoneNumberVerified', isEqualTo: true)
        .where('userType', isEqualTo: 'customer')
        .get();

    if (!mounted) return;

    if (result.docs.isNotEmpty) {
      await getIt<NotificationService>().initialize(user.email);

      final isValidTable = tableCode != null &&
          tableCode.isNotEmpty &&
          timestamp != null &&
          timestamp == DateTime.now().day;

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        isValidTable ? MainLayout.route() : AppEntryScreen.route(),
      );
    } else {
      Navigator.of(context).pushReplacement(AppEntryScreen.route());
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.35),
                setPhoto(
                  kind: 1,
                  path: 'assets/images/logo.svg',
                  width: 45,
                  height: 80,
                ),
                const SizedBox(height: 10),
                Text(
                  'JUST ORDER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: state.themeMode == ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 16,
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3.2,
                  ),
                ),
                SizedBox(height: screenHeight * 0.35),
                const CircularProgressIndicator(
                  color: Color(0xFFe02c45),
                ),
                SizedBox(height: screenHeight * 0.04),
                FutureBuilder<String>(
                  future: _getAppVersion(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? '',
                      style: TextStyle(fontSize: 12.0.sp),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


