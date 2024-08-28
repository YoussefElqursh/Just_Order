import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

class SelectYourPlace extends StatefulWidget {
  const SelectYourPlace({super.key});

  static const String routeName = 'SelectYourPlaceRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SelectYourPlace(),
    );
  }

  @override
  State<SelectYourPlace> createState() => _SelectYourPlaceState();
}

class _SelectYourPlaceState extends State<SelectYourPlace> {
  bool isScanCompleted = false;

  MobileScannerController cameraController = MobileScannerController();

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            setPhoto(
              kind: 1,
              path: 'assets/images/logo.svg',
              width: 25,
              height: 46,
            ),
            const SizedBox(width: 5),
            const Text(
              'JUST ORDER',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                letterSpacing: 1.20,
              ),
            )
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            const Text(
              'Scan QR Code of the table',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Jost',
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.0325),
            Expanded(
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    allowDuplicates: true,
                    onDetect: (barcode, args) {
                      if (!isScanCompleted) {
                        isScanCompleted = true;
                        String code = barcode.rawValue ?? "---";
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MainLayout(
                                code: code,
                                closeScreen: closeScreen,
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  QRScannerOverlay(
                    overlayColor: Colors.white,
                    borderColor: Colors.black,
                    borderRadius: 10,
                    borderStrokeWidth: 3,
                    scanAreaWidth: 300,
                    scanAreaHeight: 300,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      'OR',
                      style: TextStyle(
                        color: Color(0xFFAFAFAF),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Enter Code of the table',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        autoFocus: false,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        animationType: AnimationType.scale,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 42,
                          fieldWidth: 42,
                          borderWidth: 0.2,
                          activeColor: HexColor('e02c45'),
                          inactiveColor: Colors.black,
                          inactiveFillColor: Colors.white,
                          activeFillColor: Colors.white,
                          selectedColor: HexColor('e02c45'),
                          selectedFillColor: Colors.white,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        onCompleted: (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MainLayout(
                                  code: value,
                                  closeScreen: closeScreen,
                                );
                              },
                            ),
                          );
                        },
                        onSubmitted: (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MainLayout(
                                  code: value,
                                  closeScreen: closeScreen,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
