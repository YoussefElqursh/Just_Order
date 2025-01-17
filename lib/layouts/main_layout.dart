import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_order/screens/account/main_account_screen/account_screen.dart';
import 'package:just_order/screens/home/main_home_screen/home_screen.dart';
import 'package:just_order/screens/order/orders/order_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainLayout extends StatefulWidget {
  int? pageNumber;
  MainLayout({super.key, this.pageNumber});

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

  final screens = [
    const HomeScreen(),
    const OrderScreen(),
    const AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
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
          items:  [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: AppLocalizations.of(context)!.home_,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: AppLocalizations.of(context)!.orders_,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
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
        title: Text('Exit App'),
        content: Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Exit'),
          ),
        ],
      ),
    ) ??
        false;
  }
}
