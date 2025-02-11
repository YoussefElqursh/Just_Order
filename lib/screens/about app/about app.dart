import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.only(left: 20.0 , top: 8 , bottom: 8 ),
          child: Container(
            // width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFFF4F4F4) 
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
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
              Text("About App",
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
              "Terms & Conditions",
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
              "Privacy Policy",
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
              "Help & Support",
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
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Powered by Just Order © 2025.",
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
            const Text(
              "App Version",
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



