import 'package:flutter/material.dart';
import 'package:just_order/screens/account/app_settings/widget/settings_app_items/settings_app_items.dart';
import 'package:just_order/screens/account/app_settings/widget/switch_btn_widget/switch_btn_widget.dart';
import 'package:just_order/shared/function/functions.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Settings',
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
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child:  Column(
            children: [
              SettingsAppItems(
                onTap: (){navigateTo(context, 'SelectYourPlaceRoute');},
                icon: Icons.location_on_outlined,
                title: 'Change Location',
                training: const SizedBox(),
              ),
              const SettingsAppItems(
                icon: Icons.lock_open,
                title: 'Change Password',
                training: SizedBox(),
              ),
              const SettingsAppItems(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                training: SwitchBtnWidget(),
              ),
              const SettingsAppItems(
                icon: Icons.language_outlined,
                title: 'Language',
                training: Text('English'),
              ),
              const Spacer(),
              const Text(
                'Version 1.0',
                style: TextStyle(
                  color: Color(0xFF3A4750),
                  fontSize: 10,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
