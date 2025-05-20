import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_order/blocs/localization/language_cubit.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/screens/account/app_settings/widget/settings_app_items/settings_app_items.dart';
import 'package:just_order/screens/account/app_settings/widget/switch_btn_widget/switch_btn_widget.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  String _appVersion = '';
  String locale = '';
  bool _showChangePassword = true;

  void reRenderPage(String locale) {
    setState(() {
      locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    unawaited(showChangePassword());
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'Version ${packageInfo.version}';
    });
  }

  Future<void> showChangePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      final loadedUser = User.fromJson(jsonDecode(userString));
      setState(() {
        _showChangePassword = !(loadedUser?.loginWithGoogle)!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.settings,
              style: TextStyle(
                color: state.themeMode == ThemeMode.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            leading: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainLayout(
                          pageNumber: 2,
                        ),
                      ),
                    );
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
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                children: [
                  if (_showChangePassword)
                    SettingsAppItems(
                      onTap: () {
                        navigateTo(context, 'ChangePasswordScreenRoute');
                      },
                      icon: Icons.lock_outline_sharp,
                      title: AppLocalizations.of(context)!.change_password,
                      training: const SizedBox(),
                      state: state,
                    ),
                  SettingsAppItems(
                    onTap: () {
                      navigateTo(context, 'SelectYourPlaceRoute');
                    },
                    icon: Icons.location_on_outlined,
                    title: AppLocalizations.of(context)!.change_location,
                    training: const SizedBox(),
                    state: state,
                  ),
                  SettingsAppItems(
                    icon: Icons.dark_mode_outlined,
                    title: AppLocalizations.of(context)!.dark_mode,
                    training: SwitchBtnWidget(),
                    state: state,
                  ),
                  SettingsAppItems(
                    icon: Icons.language_outlined,
                    title: AppLocalizations.of(context)!.language_,
                    training: Text(AppLocalizations.of(context)!.language),
                    onTap: () {
                      final cubit = context.read<LanguageCubit>();
                      Locale currentLocale = cubit.state;
                      if (currentLocale.languageCode == 'en') {
                        cubit.switchToArabic();
                      } else {
                        cubit.switchToEnglish();
                      }
                    },
                    state: state,
                  ),
                  const Spacer(),
                  Text(
                    _appVersion,
                    style: TextStyle(
                      color: state.themeMode == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
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
      },
    );
  }
}
