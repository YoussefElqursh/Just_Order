import 'package:flutter/material.dart';

class SettingsAppItems extends StatelessWidget {
  const SettingsAppItems({super.key, required this.icon, required this.title, required this.training, this.onTap});
  final IconData icon;
  final String title;
  final Widget training;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 20, color: Colors.black,),
      title: Text(title),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
      ),
      shape: const Border(bottom: BorderSide(color: Color(0xFFE9ECEF), width: 1),),
      trailing: training,
    );
  }
}
