import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_order/screens/about_app/help_support.dart';
import 'package:just_order/screens/about_app/privacy_and_policy_screen.dart';
import 'package:just_order/screens/about_app/terms_and_conditions_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  String _appVersion = '';

  @override
  void initState() {
    _loadAppVersion();
    super.initState();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'Version ${packageInfo.version}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
          child: Container(
            width: 34,
            height: 34,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFF4F4F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.about_app,
          style: const TextStyle(
            color: Color(0xFF090909) /* Black */,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            _buildRoundedButton(
              "assets/icons/terms_conditions.png",
              AppLocalizations.of(context)!.terms_conditions,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsAndConditionsScreen(),
                  ),
                );
              },
            ),
            _buildRoundedButton(
              "assets/icons/privacy_policy.png",
              AppLocalizations.of(context)!.privacy_policy,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            _buildRoundedButton(
              "assets/icons/help_support.png",
              AppLocalizations.of(context)!.help_support,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpSupportScreen(),
                  ),
                );
              },
            ),
            _buildAppVersionTile(), // Non-clickable App Version
            const Spacer(), // Space before footer
            Align(
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.powered_by_just_order,
                style: const TextStyle(color: Color(0xFFE02C45), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedButton(
    String imagePath,
    String title,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white, // Button background color
      borderRadius: BorderRadius.circular(6), // Rounded corners
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Color(0x4CAFAFAF) /* Gray-30% */,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
              ), // Icon
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF090909) /* Black */,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppVersionTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x4CAFAFAF) /* Gray-30% */,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/icons/app_version.png",
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12),
          Text(
            AppLocalizations.of(context)!.app_version,
            style: const TextStyle(
              color: Color(0xFF090909) /* Black */,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            _appVersion,
            style: const TextStyle(
              color: Color(0xFFAFAFAF) /* Gray */,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
