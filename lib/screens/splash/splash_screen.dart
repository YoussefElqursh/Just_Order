import 'package:flutter/material.dart';
import 'package:just_order/screens/login/login_screen.dart';
import 'package:just_order/shared/function/functions.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String routeName = 'SplashScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      navigateToWithoutBack(context, const LoginScreen());
    });

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
          ],
        ),
      ),
    );
  }
}
