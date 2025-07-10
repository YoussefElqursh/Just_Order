import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_order/blocs/fingerprint/fingerprint_cubit.dart';
import 'package:just_order/blocs/fingerprint/fingerprint_state.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/screens/account/app_settings/app_settings_screen.dart';
import 'package:just_order/shared/function/connectivity_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/function/validations.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static const String routeName = 'ChangePasswordScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const ChangePasswordScreen(),
    );
  }

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  User? user;

  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  late GlobalKey<FormState> formKey;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey = GlobalKey();
    loadUserFromPreferences();
  }

  Future<void> loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      final loadedUser = User.fromJson(jsonDecode(userString));
      setState(() {
        user = loadedUser!;
      });
    }
  }

  void showNotification({required String message, bool errorMessage = false}) {
    Size size = MediaQuery.of(context).size;
    double fontSize = 14;
    int maxLines = 5;
    double lineHeightSpacing = 1.5;
    Color backgroundColor = const Color.fromRGBO(220, 38, 38, 1);
    if (errorMessage) {
      ElegantNotification.error(
        width: size.width * 0.95,
        height: fontSize * maxLines * lineHeightSpacing,
        position: Alignment.topCenter,
        animation: AnimationType.fromTop,
        title: Text(
          'Error',
          style: TextStyle(color: Colors.white, fontSize: 1.5 * fontSize),
        ),
        description: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
        background: backgroundColor,
      ).show(context);
    } else {
      ElegantNotification.success(
        height: fontSize * maxLines * lineHeightSpacing,
        width: size.width * 0.95,
        title: Text(
          'Successful',
          style: TextStyle(color: Colors.white, fontSize: 1.5 * fontSize),
        ),
        description: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
        background: Colors.green,
        animation: AnimationType.fromTop,
        position: Alignment.topCenter,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.change_password,
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
            leading: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
              child: Container(
                width: 34,
                height: 34,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF4F4F4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppSettingsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 18,
                  ),
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            leadingWidth: 55.0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  buildInputField(
                      label: AppLocalizations.of(context)!.current_password,
                      controller: currentPasswordController,
                      hintText: AppLocalizations.of(context)!.current_password,
                      isEnabled: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_password;
                        }
                        return null;
                      },
                      state: state),
                  const SizedBox(height: 20.0),
                  buildInputField(
                    label: AppLocalizations.of(context)!.new_password,
                    controller: newPasswordController,
                    isEnabled: true,
                    hintText: AppLocalizations.of(context)!.new_password,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .please_enter_a_valid_password;
                      }
                      if (value == currentPasswordController.text) {
                        return AppLocalizations.of(context)!
                            .new_password_cannot_be_the_same_as_current_password;
                      }
                      return null;
                    },
                    state: state,
                  ),
                  const SizedBox(height: 20.0),
                  buildInputField(
                    label: AppLocalizations.of(context)!.confirm_password,
                    controller: confirmPasswordController,
                    isEnabled: true,
                    hintText: AppLocalizations.of(context)!.confirm_password,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != newPasswordController.text) {
                        return AppLocalizations.of(context)!
                            .please_enter_a_confirm_password_as_new_password;
                      }
                      return null;
                    },
                    state: state,
                  ),
                  const SizedBox(height: 20.0),
                  BlocConsumer<FingerprintCubit, FingerprintState>(
                    listener: (context, state) {
                      if (state is FingerprintSuccess) {
                        if (formKey.currentState!.validate()) {
                          updateUserPassword(
                              user: user!,
                              currentPassword: currentPasswordController.text,
                              newPassword: newPasswordController.text,
                              confirmedPassword:
                                  confirmPasswordController.text);
                        }
                      } else if (state is FingerprintFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .authentication_failed)),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          final LocalAuthentication auth =
                              LocalAuthentication();
                          final List<BiometricType> availableBiometrics =
                              await auth.getAvailableBiometrics();
                          if (availableBiometrics.isEmpty) {
                            debugPrint(
                                "There is no biometric authentication enrolled");
                          }
                          if (Platform.isAndroid) {
                            if (availableBiometrics
                                .contains(BiometricType.face)) {
                              // TODO: implement face detection
                              updateUserPassword(
                                  user: user!,
                                  currentPassword:
                                      currentPasswordController.text,
                                  newPassword: newPasswordController.text,
                                  confirmedPassword:
                                      confirmPasswordController.text);
                            } else if (availableBiometrics
                                .contains(BiometricType.fingerprint)) {
                              // ignore: use_build_context_synchronously
                              context
                                  .read<FingerprintCubit>()
                                  .checkFingerprint();
                            }
                          } else if (Platform.isIOS) {
                            if (availableBiometrics
                                .contains(BiometricType.face)) {
                              try {
                                bool authenticated = await auth.authenticate(
                                  localizedReason:
                                      'Please authenticate to access the app',
                                  options: const AuthenticationOptions(
                                    biometricOnly: true,
                                    // Use only biometrics (Face ID or Touch ID)
                                    stickyAuth: true,
                                  ),
                                );
                                if (authenticated) {
                                  updateUserPassword(
                                      user: user!,
                                      currentPassword:
                                          currentPasswordController.text,
                                      newPassword: newPasswordController.text,
                                      confirmedPassword:
                                          confirmPasswordController.text);
                                } else {
                                  showNotification(
                                      message:
                                          "Biometric authentication failed",
                                      errorMessage: true);
                                }
                              } catch (e) {
                                showNotification(
                                    message: "Biometric authentication failed",
                                    errorMessage: true);
                              }
                            } else if (availableBiometrics
                                .contains(BiometricType.fingerprint)) {
                              // ignore: use_build_context_synchronously
                              context
                                  .read<FingerprintCubit>()
                                  .checkFingerprint();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            fixedSize:
                                Size(MediaQuery.sizeOf(context).width, 30),
                            backgroundColor: const Color(0xFFE02C45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Text(
                          AppLocalizations.of(context)!.change_password,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildInputField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool isEnabled = false,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    required ThemeState state,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: state.themeMode == ThemeMode.light
                ? Colors.black
                : Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor:
              state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
          style: TextStyle(
            color: isEnabled
                ? state.themeMode == ThemeMode.light
                    ? Colors.black
                    : Colors.white
                : const Color(0xFFCCCCCC),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFFCCCCCC),
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFAFAFAF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE02C45)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> updateUserPassword({
    required User user,
    required String currentPassword,
    required String newPassword,
    required String confirmedPassword,
  }) async {
    final currentUser = user;
    // Input Validation
    if (!InputValidator.isValidPassword(currentPassword)) {
      debugPrint('Invalid Password');
      showNotification(
          message: "Current password doesn't meet minimum needed length",
          errorMessage: true);
      return;
    }
    if (!InputValidator.isValidName(newPassword)) {
      debugPrint('Invalid Password');
      showNotification(
          message: "New password doesn't meet minimum needed length",
          errorMessage: true);
      return;
    }

    if (newPassword != confirmedPassword) {
      debugPrint('Invalid Password');
      showNotification(
          message: "The password doesn't miss match", errorMessage: true);
      return;
    }

    // Network Connectivity Check
    if (!await isConnected()) {
      // ignore: use_build_context_synchronously
      debugPrint(AppLocalizations.of(context)!.no_internet_connection);
      showNotification(
          message: "Some thing wrong with the connection", errorMessage: true);
      return;
    }

    try {
      // Check if the user already exists
      final currentBytes = utf8.encode(currentPassword);
      final currentDigest = sha256.convert(currentBytes);
      final currentHashedPassword = currentDigest.toString();

      final existingUser = await _firestore
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .where('password', isEqualTo: currentHashedPassword)
          .get();

      if (existingUser.docs.isEmpty) {
        // ignore: use_build_context_synchronously
        debugPrint(
            AppLocalizations.of(context)!.user_with_this_email_not_exists);
        showNotification(
            message: "Some went wrong , please try again", errorMessage: true);
        return;
      }

      // Proceed with user select the user to update
      final userId = existingUser.docs.first.id;
      final bytes = utf8.encode(newPassword);
      final digest = sha256.convert(bytes);
      final hashedPassword = digest.toString();

      await _firestore.collection('users').doc(userId).update({
        'password': hashedPassword,
        'updatedAt': Timestamp.now().toDate(),
      });

      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .get();

      if (result.docs.isEmpty) {
        return;
      }

      final doc = result.docs.first;
      final user = User.fromJson(doc.data() as Map<String, dynamic>);

      await user?.saveUserToPreferences(user);

      loadUserFromPreferences();

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      // ignore: use_build_context_synchronously
      debugPrint(AppLocalizations.of(context)!.user_updated_successfully);
      showNotification(message: "Password updated successfully");
    } catch (e) {
      // ignore: use_build_context_synchronously
      debugPrint(AppLocalizations.of(context)!.user_update_failed);
    }
  }
}
