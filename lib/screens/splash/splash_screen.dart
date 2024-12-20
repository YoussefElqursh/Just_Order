import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/screens/QR/select_your_place_screen.dart';
import 'package:just_order/screens/login/login_screen.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _dialogShown = false;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    Future.delayed(
        const Duration(seconds: 5), () => _checkInternetConnection());
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'Version ${packageInfo.version}';
    });
  }

  Future<void> _checkInternetConnection() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      _navigateBasedOnUser();
    } else {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (!_dialogShown) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
        ),
      );
    }
    _dialogShown = true;
    Future.delayed(const Duration(seconds: 2), () {
      _checkInternetConnection();
    });
  }

  Future<void> _navigateBasedOnUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    final tableCode = prefs.getString('code');
    final timestamp = prefs.getInt('timestamp');
    final validTime = DateTime.now().day;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (userString != null) {
      final user = User.fromJson(jsonDecode(userString));
      final QuerySnapshot result = await firestore
          .collection('users')
          .where('email', isEqualTo: user?.email)
          .where('password', isEqualTo: user?.password)
          .where('emailVerified', isEqualTo: true)
          .where('phoneNumberVerified', isEqualTo: true)
          .where('userType', isEqualTo: 'customer')
          .get();

      if (result.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
        if (tableCode!.isNotEmpty && timestamp != null && timestamp == validTime) {
          Navigator.of(context).pushReplacement(MainLayout.route());
        } else {
          Navigator.of(context).pushReplacement(SelectYourPlace.route());
        }
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(LoginScreen.route());
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(LoginScreen.route());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.35),
            setPhoto(
              kind: 1,
              path: 'assets/images/logo.svg',
              width: 45,
              height: 80,
            ),
            const SizedBox(height: 10),
            const Text(
              'JUST ORDER',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
                letterSpacing: 3.20,
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.35),
            const CircularProgressIndicator(
              color: Color(0xFFe02c45),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
            Text(_appVersion, style: TextStyle(fontSize: 12.0.sp),)
          ],
        ),
      ),
    );
  }
}
