import 'package:flutter/material.dart';
import 'package:just_order/layouts/main_layout.dart';
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
        title: const Text(
          'Scan Order',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.57,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 300,
                  padding: const EdgeInsets.all(20),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0x4CAFAFAF),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Scan QR Code of the table',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
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
                              scanAreaWidth: 190,
                              scanAreaHeight: 190,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'OR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFAFAFAF),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0.12,
                            letterSpacing: -0.12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 141,
                          padding: const EdgeInsets.all(20),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0x4CAFAFAF),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Enter Code of the table',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: PinCodeTextField(
                                  appContext: context,
                                  length: 5,
                                  autoFocus: false,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  animationType: AnimationType.scale,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(6),
                                    fieldHeight: 42,
                                    fieldWidth: 42,
                                    borderWidth: 0.2,
                                    activeColor: const Color(0xFFE02C45),
                                    inactiveColor: const Color(0x7FAFAFAF),
                                    inactiveFillColor: Colors.white,
                                    activeFillColor: Colors.white,
                                    selectedColor: const Color(0xFFE02C45),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
