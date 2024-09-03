import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_order/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = 'ProfileScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const ProfileScreen(),
    );
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    _UserFromPreferences();
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
          child: Container(
            width: 34,
            height: 34,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFF4F4F4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 18,
              ),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 55.0,
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
            child: Container(
              width: 34,
              height: 34,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFF4F4F4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings_sharp,
                  color: Colors.black,
                  size: 18,
                ),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    user != null ? user!.firstName[0] : '',
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
                MaterialButton(
                  onPressed: () {},
                  minWidth: 73,
                  height: 20,
                  color: const Color(0xFFE02C45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width,
                      maxHeight: 42,
                    ),
                    hintText: '${user?.firstName}${user?.lastName}',
                    hintStyle: const TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFFAFAFAF),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width,
                      maxHeight: 42,
                    ),
                    hintText: user?.email ?? '',
                    hintStyle: const TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFFAFAFAF),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phone Number',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width,
                      maxHeight: 42,
                    ),
                    hintText: user?.phoneNumber ?? '',
                    hintStyle: const TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFFAFAFAF),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
