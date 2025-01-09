import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';

class SwitchBtnWidget extends StatefulWidget {
  const SwitchBtnWidget({super.key});

  @override
  State<SwitchBtnWidget> createState() => _SwitchBtnWidgetState();
}

class _SwitchBtnWidgetState extends State<SwitchBtnWidget> {
  bool _lights = false;

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: _lights,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFF9D9D9D),
      thumbColor: const WidgetStatePropertyAll(Colors.white,),
      activeColor:Color(0xFFE02C45),
      trackOutlineColor: const WidgetStatePropertyAll(Color(0xFF9D9D9D),),
      activeTrackColor: Color(0xFFE02C45),
      trackOutlineWidth: const WidgetStatePropertyAll(0),
      onChanged: (bool value) {
        setState(() {
        _lights = value;
        context.read<ThemeCubit>().toggleTheme();
      });
      },
    );
  }
}
