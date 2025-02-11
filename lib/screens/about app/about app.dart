import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'help_support.dart';
import 'privacy & policy.dart';
import 'terms & conditions.dart';

class AboutApp extends StatefulWidget {

  @override
  State<AboutApp> createState() => _AboutAppState();
}



class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF4F4F4), // Background color for the container
              borderRadius: BorderRadius.circular(7), // Rounded corners for the container
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black), // Arrow icon color
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Container(
          width: 248,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.about_app,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildRoundedButton(
              "assets/icons/terms_conditions.png",
              AppLocalizations.of(context)!.terms_conditions,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsAndConditionsScreen(),
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
                        builder: (context) => PrivacyPolicyScreen(),
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
                        builder: (context) => HelpSupportScreen(),
                      ),
                    );
              },
            ),
            _buildAppVersionTile(), // Non-clickable App Version
            const SizedBox(height: 345), // Space before footer
             Align(
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.powered_by_just_order,
                style: TextStyle(color: Color(0xFFE02C45), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildRoundedButton(String imagePath, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // Space between buttons
      child: Material(
        color: Colors.white, // Button background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
        child: InkWell(
          onTap: onTap, // Click action only inside the button
          borderRadius: BorderRadius.circular(12), // Ripple effect inside bounds
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Image.asset(imagePath, width: 24, height: 24), // Icon
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppVersionTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Image.asset("assets/icons/app_version.png", width: 24, height: 24),
            const SizedBox(width: 12),
             Text(
              AppLocalizations.of(context)!.app_version,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Text(
              "Version 1.2.0",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}



