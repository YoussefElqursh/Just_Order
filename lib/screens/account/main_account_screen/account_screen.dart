import 'package:flutter/material.dart';
import 'package:just_order/screens/account/main_account_screen/widgets/account_functions_widget.dart';
import 'package:just_order/shared/function/functions.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
                SizedBox(height: MediaQuery.sizeOf(context).width * 0.15,),
                Container(
                  width: 80,
                  height: 80,
                  decoration: ShapeDecoration(
                    image: const DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/80x80"),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'James David',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'james.david2314@gmail.com',
                  style: TextStyle(
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
                const SizedBox(height: 12.0,),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.person,
                  label: 'My Profile',
                  onPressed: () {
                    navigateTo(context, 'ProfileScreenRoute');
                  },
                ),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.notifications_none_outlined,
                  label: 'Notifications',
                  onPressed: () {},
                ),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.favorite_border_outlined,
                  label: 'Favorites',
                  onPressed: () {},
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
                const SizedBox(height: 12.0,),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.history_outlined,
                  label: 'Order History',
                  onPressed: () {},
                ),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.credit_card,
                  label: 'Cards',
                  onPressed: () {},
                ),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.settings_sharp,
                  label: 'Settings',
                  onPressed: () {},
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
                const SizedBox(height: 12.0,),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.info_outline_rounded,
                  label: 'About App',
                  onPressed: () {},
                ),
                accountFunctionWidget(
                  context: context,
                  icon: Icons.logout,
                  label: 'Logout',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
