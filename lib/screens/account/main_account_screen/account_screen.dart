import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/auth_repository/login_repository.dart';
import 'package:just_order/screens/account/app_settings/app_settings_screen.dart';
import 'package:just_order/screens/account/history_screen/history_screen.dart';
import 'package:just_order/screens/account/main_account_screen/widgets/account_functions_widget.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? user;
  LoginRepository loginRepository = LoginRepository();
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _UserFromPreferences();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'Version ${packageInfo.version}';
    });
  }

  // ignore: non_constant_identifier_names
  Future<void> _UserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      final user = User.fromJson(jsonDecode(userString));
      setState(() {
        this.user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).width * 0.15,
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    user != null ? user!.firstName[0].toUpperCase() : '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  '${user?.firstName} ${user?.lastName}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 5.0),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(
                    color: Color(0xFFAFAFAF),
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                //Personal Information Section
                const SizedBox(height: 35.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Personal Information',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.person,
                  label: 'My Profile',
                  onPressed: () {
                    navigateTo(context, 'ProfileScreenRoute');
                  },
                ),
                //Account Management Section
                const SizedBox(height: 25.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Account Management',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.history_outlined,
                  label: 'Order History',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(),
                      ),
                    );
                  },
                ),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.settings_sharp,
                  label: 'Settings',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppSettingsScreen(),
                      ),
                    );
                  },
                ),
                //General Section
                const SizedBox(height: 25.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'General',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.info_outline_rounded,
                  label: 'About App',
                  isText: true,
                  text: _appVersion,
                  onPressed: () {},
                ),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.logout,
                  label: 'Logout',
                  onPressed: () {
                    loginRepository.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'LoginScreenRoute', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
