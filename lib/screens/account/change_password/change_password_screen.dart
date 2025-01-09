import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/fingerprint/fingerprint_cubit.dart';
import 'package:just_order/blocs/fingerprint/fingerprint_state.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/screens/account/app_settings/app_settings_screen.dart';
import 'package:just_order/shared/function/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Change Password',
              style: TextStyle(
                color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
                        builder: (context) => AppSettingsScreen(),
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
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  buildInputField(
                    label: 'Current Password',
                    controller: currentPasswordController,
                    hintText: 'Current Password',
                    isEnabled: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid Password';
                      }
                      return null;
                    },
                    state: state
                  ),
                  const SizedBox(height: 20.0),
                  buildInputField(
                    label: 'New Password',
                    controller: newPasswordController,
                    isEnabled: true,
                    hintText: 'New Password',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid Password';
                      }
                      if (value == currentPasswordController.text) {
                        return 'New Password cannot be the same as Current Password';
                      }
                      return null;
                    }, state: state,
                  ),
                  const SizedBox(height: 20.0),
                  buildInputField(
                    label: 'Confirm Password',
                    controller: confirmPasswordController,
                    isEnabled: true,
                    hintText: 'Confirm Password',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != newPasswordController.text) {
                        return 'Please enter a Confirm Password as New Password';
                      }
                      return null;
                    }, state: state,
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Password updated successfully.')),
                          );
                        }
                      } else if (state is FingerprintFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Authentication failed.')),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          context.read<FingerprintCubit>().checkFingerprint();
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
                          'Change Password',
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
            color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
          style: TextStyle(
            color: isEnabled ? state.themeMode == ThemeMode.light ? Colors.black : Colors.white : const Color(0xFFCCCCCC),
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
    // if (!InputValidator.isValidPassword(currentPassword)) {
    //   debugPrint('Invalid Password');
    //   return;
    // }
    // if (!InputValidator.isValidName(newPassword)) {
    //   debugPrint('Invalid Password');
    //   return;
    // }
    //
    // if (!InputValidator.isValidPhoneNumber(confirmedPassword)) {
    //   debugPrint('Invalid Password');
    //   return;
    // }

    // Network Connectivity Check
    if (!await isConnected()) {
      debugPrint('No Internet Connection');
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
        debugPrint('User with this email not exists.');
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
        return null;
      }

      final doc = result.docs.first;
      final user = User.fromJson(doc.data() as Map<String, dynamic>);

      await user?.saveUserToPreferences(user);

      loadUserFromPreferences();

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      debugPrint('User updated successfully.');
    } catch (e) {
      debugPrint('User update failed.');
    }
  }
}
