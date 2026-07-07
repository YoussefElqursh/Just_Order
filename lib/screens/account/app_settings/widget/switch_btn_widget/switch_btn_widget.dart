import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/core/storage/storage_service.dart';

class SwitchBtnWidget extends StatefulWidget {
  const SwitchBtnWidget({super.key});

  @override
  State<SwitchBtnWidget> createState() => _SwitchBtnWidgetState();
}

class _SwitchBtnWidgetState extends State<SwitchBtnWidget> {
  bool _lights = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  // Load the saved state from StorageService
  Future<void> _loadSwitchState() async {
    final prefs = StorageService.instance;
    setState(() {
      _lights = prefs.getBool('switch_state') ?? false; // Default to false
    });
  }

  // Save the state to StorageService
  Future<void> _saveSwitchState(bool value) async {
    final prefs = StorageService.instance;
    await prefs.setBool('switch_state', value);
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: _lights,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFF9D9D9D),
      thumbColor: const MaterialStatePropertyAll(Colors.white),
      activeColor: const Color(0xFFE02C45),
      trackOutlineColor: const MaterialStatePropertyAll(Color(0xFF9D9D9D)),
      activeTrackColor: const Color(0xFFE02C45),
      trackOutlineWidth: const MaterialStatePropertyAll(0),
      onChanged: (bool value) {
        setState(() {
          _lights = value;
          _saveSwitchState(value); // Save the state when toggled
          context.read<ThemeCubit>().toggleTheme();
        });
      },
    );
  }
}
