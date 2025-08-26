import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _SelectYourPlaceState extends State<SelectYourPlace>
    with WidgetsBindingObserver {
  bool _hasPermission = false;
  bool isCheckingPermission = true;
  bool isScanCompleted = false;
  MobileScannerController cameraController = MobileScannerController();
  late SharedPreferences prefs;
  bool isRoot = true;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    WidgetsBinding.instance.addObserver(this);
    unawaited(cameraController.start());
    _checkCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _checkCameraPermission();
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        unawaited(
          cameraController.start(),
        );
      case AppLifecycleState.inactive:
        unawaited(
          cameraController.stop(),
        );
    }
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
        isCheckingPermission = false;
      });
    } else {
      setState(() {
        _hasPermission = false;
        isCheckingPermission = false;
      });
    }
  }

  void _openAppSettings() {
    openAppSettings();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    isRoot = ModalRoute.of(context)?.isFirst ?? false;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              leading: isRoot
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      child: Container(
                        width: 34,
                        height: 34,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF4F4F4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.scan_order,
                style: TextStyle(
                  color: state.themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
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
                  //height: MediaQuery.sizeOf(context).height * 0.57,
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height * 0.85,
                        padding: const EdgeInsets.all(20),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: state.themeMode == ThemeMode.dark
                              ? Colors.black
                              : Colors.white,
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
                            Text(
                              AppLocalizations.of(context)!
                                  .scan_qr_code_of_the_table,
                              style: TextStyle(
                                color: state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: _hasPermission
                                  ? null
                                  : MediaQuery.sizeOf(context).height * 0.0325,
                            ),
                            _hasPermission
                                ? Expanded(
                                    child: Stack(
                                      children: [
                                        MobileScanner(
                                          controller: cameraController,
                                          onDetect: (barcode) async {
                                            if (!isScanCompleted) {
                                              isScanCompleted = true;
                                              String rawValue = barcode.barcodes.firstOrNull?.rawValue ?? "---";
                                              String extractedCode = rawValue.split('/').last;
                                              if (!RegExp(r'^\d+$').hasMatch(extractedCode)) {
                                                extractedCode = '';
                                              }
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    final currentDate = DateTime.now().day;
                                                    prefs.setString('code', extractedCode);
                                                    prefs.setInt('timestamp', currentDate);
                                                    return MainLayout();
                                                  },
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        QRScannerOverlay(
                                          overlayColor:
                                              state.themeMode == ThemeMode.dark
                                                  ? Colors.black
                                                  : Colors.white,
                                          borderColor:
                                              state.themeMode == ThemeMode.light
                                                  ? Colors.black
                                                  : const Color(0xFFE02C45),
                                          borderRadius: 10,
                                          borderStrokeWidth: 3,
                                          scanAreaWidth: 190,
                                          scanAreaHeight: 190,
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.3,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .camera_permission_is_required_to_scan_qr_codes,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 25),
                                        MaterialButton(
                                          onPressed: _openAppSettings,
                                          height: 42,
                                          minWidth:
                                              MediaQuery.sizeOf(context).width,
                                          clipBehavior: Clip.antiAlias,
                                          color: const Color(0xFFE02C45),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .open_settings,
                                              style: TextStyle(
                                                color: state.themeMode ==
                                                        ThemeMode.light
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Container(
                      //     color: Colors.white,
                      //     width: MediaQuery.sizeOf(context).width,
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         const SizedBox(height: 20),
                      //         const Text(
                      //           'OR',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             color: Color(0xFFAFAFAF),
                      //             fontSize: 12,
                      //             fontFamily: 'Inter',
                      //             fontWeight: FontWeight.w500,
                      //             height: 0.12,
                      //             letterSpacing: -0.12,
                      //           ),
                      //           overflow: TextOverflow.ellipsis,
                      //           maxLines: 1,
                      //         ),
                      //         const SizedBox(height: 20),
                      //         Container(
                      //           width: MediaQuery.sizeOf(context).width,
                      //           height: 141,
                      //           padding: const EdgeInsets.all(20),
                      //           clipBehavior: Clip.antiAlias,
                      //           decoration: ShapeDecoration(
                      //             color: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               side: const BorderSide(
                      //                 width: 1,
                      //                 strokeAlign: BorderSide.strokeAlignCenter,
                      //                 color: Color(0x4CAFAFAF),
                      //               ),
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //           ),
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               const Text(
                      //                 'Enter Code of the table',
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 14,
                      //                   fontFamily: 'Inter',
                      //                   fontWeight: FontWeight.w600,
                      //                 ),
                      //                 overflow: TextOverflow.ellipsis,
                      //                 maxLines: 1,
                      //               ),
                      //               const SizedBox(height: 20),
                      //               SizedBox(
                      //                 width: MediaQuery.sizeOf(context).width,
                      //                 child: PinCodeTextField(
                      //                   appContext: context,
                      //                   length: 5,
                      //                   autoFocus: false,
                      //                   cursorColor: Colors.black,
                      //                   keyboardType: TextInputType.number,
                      //                   obscureText: false,
                      //                   animationType: AnimationType.scale,
                      //                   pinTheme: PinTheme(
                      //                     shape: PinCodeFieldShape.box,
                      //                     borderRadius: BorderRadius.circular(6),
                      //                     fieldHeight: 42,
                      //                     fieldWidth: 42,
                      //                     borderWidth: 0.2,
                      //                     activeColor: const Color(0xFFE02C45),
                      //                     inactiveColor: const Color(0x7FAFAFAF),
                      //                     inactiveFillColor: Colors.white,
                      //                     activeFillColor: Colors.white,
                      //                     selectedColor: const Color(0xFFE02C45),
                      //                     selectedFillColor: Colors.white,
                      //                   ),
                      //                   animationDuration:
                      //                       const Duration(milliseconds: 300),
                      //                   onCompleted: (value) {
                      //                     Navigator.pushReplacement(
                      //                       context,
                      //                       MaterialPageRoute(
                      //                         builder: (context) {
                      //                           prefs.setString('code', value);
                      //                           final currentTime = DateTime.now().millisecondsSinceEpoch;
                      //                           prefs.setInt('timestamp', currentTime);
                      //                           return const MainLayout();
                      //                         },
                      //                       ),
                      //                     );
                      //                   },
                      //                   onSubmitted: (value) {
                      //                     Navigator.pushReplacement(
                      //                       context,
                      //                       MaterialPageRoute(
                      //                         builder: (context) {
                      //                           prefs.setString('code', value);
                      //                           final currentTime = DateTime.now().millisecondsSinceEpoch;
                      //                           prefs.setInt('timestamp', currentTime);
                      //                           return const MainLayout();
                      //                         },
                      //                       ),
                      //                     );
                      //                   },
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
