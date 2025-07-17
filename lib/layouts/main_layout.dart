import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/screens/account/main_account_screen/account_screen.dart';
import 'package:just_order/screens/home/main_home_screen/home_screen.dart';
import 'package:just_order/screens/order/orders/order_screen.dart';

// ignore: must_be_immutable
class MainLayout extends StatefulWidget {
  int? pageNumber;
  final String? tableCode;

  MainLayout({super.key, this.pageNumber, this.tableCode});

  static const String routeName = 'MainLayoutRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => MainLayout(),
    );
  }

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        tableCode: widget.tableCode,
      ),
      const OrderScreen(),
      const AccountScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog or directly close the app
        final shouldExit = await showExitConfirmationDialog(context);
        if (shouldExit) {
          // Exit the app
          exit(0);
        }
        return false; // Prevent default pop behavior
      },
      child: Scaffold(
        body: IndexedStack(
          index: widget.pageNumber ?? currentPage,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.pageNumber ?? currentPage,
          elevation: 0.0,
          onTap: (value) {
            setState(() {
              currentPage = value;
              widget.pageNumber = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/unselected_home.png',
                height: 20,
                width: 20,
              ),
              activeIcon: Image.asset(
                'assets/icons/home.png',
                height: 20,
                width: 20,
              ),
              label: AppLocalizations.of(context)!.home_,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/unselected_order.png',
                height: 20,
                width: 20,
              ),
              activeIcon: Image.asset(
                'assets/icons/order.png',
                height: 20,
                width: 20,
              ),
              label: AppLocalizations.of(context)!.orders_,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person_outline),
              label: AppLocalizations.of(context)!.account_,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFFE02C45),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: const Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
