import 'package:flutter/material.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Color(0xFFE02C45)),
              hintText: AppLocalizations.of(context)!.search,
              filled: true,
              fillColor: const Color(0xFFF4F4F4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ContactTile(
                  icon: Icons.headset_mic,
                  title: AppLocalizations.of(context)!.customer_service,
                  url: "https://www.talabat.com/egypt",
                ),
                const SizedBox(
                  height: 8,
                ),
                ContactTile(
                  icon: Icons.language,
                  title: AppLocalizations.of(context)!.website,
                  url: "https://www.talabat.com/egypt",
                ),
                const SizedBox(
                  height: 8,
                ),
                ContactTile(
                  icon: Icons.facebook,
                  title: AppLocalizations.of(context)!.facebook,
                  url: "https://www.talabat.com/egypt",
                ),
                const SizedBox(
                  height: 8,
                ),
                ContactTile(
                  icon: Icons.camera_alt,
                  title: AppLocalizations.of(context)!.instagram,
                  url: "https://www.talabat.com/egypt",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String url;

  const ContactTile({
    super.key,
    required this.icon,
    required this.title,
    required this.url,
  });

  void _launchURL() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFE02C45),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF090909) /* Black */,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: _launchURL, // Open the link when tapped
      ),
    );
  }
}
