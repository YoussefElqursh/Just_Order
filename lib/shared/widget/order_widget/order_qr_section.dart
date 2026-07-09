import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// QR code + order code shown when an "on the way" order card is expanded.
class OrderQrSection extends StatelessWidget {
  const OrderQrSection({
    super.key,
    required this.orderCode,
    required this.state,
  });

  final String orderCode;
  final ThemeState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(
                color: const Color(0x66AFAFAF),
                style: BorderStyle.solid,
              ),
            ),
            child: QrImageView(
              data: orderCode,
              size: 80,
              version: QrVersions.auto,
              backgroundColor:
                  state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              foregroundColor:
                  state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 30,
              width: 2,
              decoration: const ShapeDecoration(
                color: Color(0x66AFAFAF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0x66AFAFAF),
                  ),
                ),
              ),
            ),
          ),
          Text(
            orderCode,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
