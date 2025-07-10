import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';

class SettingsAppItems extends StatelessWidget {
  const SettingsAppItems(
      {super.key,
      required this.icon,
      required this.title,
      required this.training,
      this.onTap,
      required this.state});

  final IconData icon;
  final String title;
  final Widget training;
  final void Function()? onTap;
  final ThemeState state;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: 20,
        color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
      ),
      title: Text(title),
      titleTextStyle: TextStyle(
        color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
        fontSize: 14,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
      ),
      shape: const Border(
        bottom: BorderSide(color: Color(0xFFE9ECEF), width: 1),
      ),
      trailing: training,
    );
  }
}
