import 'package:flutter/material.dart';
import 'package:just_order/screens/10-account_screen/account_screen.dart';
import 'package:just_order/screens/3-home_screen/home_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.code, required this.closeScreen});

  final String code;
  final Function() closeScreen;

  static const String routeName = 'MainLayoutRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => MainLayout(
        code: '',
        closeScreen: (){},
      ),
    );
  }

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  int currentPage = 0 ;

  final screens = [
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        elevation: 0.0,
        onTap: (value){
          setState(() {
            currentPage = value ;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
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
    );
  }
}
