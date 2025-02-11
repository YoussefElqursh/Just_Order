import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Color(0xFFE02C45)),
              hintText: "Search",
              filled: true,
              fillColor: Color(0xFFF4F4F4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ContactTile(
                    icon: Icons.headset_mic,
                    title: "Customer Service",
                    url: "https://www.talabat.com/egypt"),
                ContactTile(
                    icon: Icons.language,
                    title: "Website",
                    url: "https://www.talabat.com/egypt"),
                ContactTile(
                    icon: Icons.facebook,
                    title: "Facebook",
                    url: "https://www.talabat.com/egypt"),
                ContactTile(
                    icon: Icons.camera_alt,
                    title: "Instagram",
                    url: "https://www.talabat.com/egypt"),
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

  ContactTile({required this.icon, required this.title, required this.url});

  void _launchURL() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Color(0xFFE02C45)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: _launchURL, // Open the link when tapped
      ),
    );
  }
}