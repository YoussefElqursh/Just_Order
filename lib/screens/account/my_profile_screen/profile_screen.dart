import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/fingerprint/fingerprint_cubit.dart';
import 'package:just_order/blocs/fingerprint/fingerprint_state.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/screens/account/app_settings/app_settings_screen.dart';
import 'package:just_order/shared/function/connectivity_plus.dart';
import 'package:just_order/shared/function/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = 'ProfileScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const ProfileScreen(),
    );
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  bool isEditing = false;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  late GlobalKey<FormState> formKey;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
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
        usernameController.text =
            "${loadedUser.firstName} ${loadedUser.lastName}";
        emailController.text = loadedUser.email;
        phoneController.text = loadedUser.phoneNumber;
      });
    }
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.my_profile,
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
                        builder: (context) => MainLayout(
                          pageNumber: 2,
                        ),
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
            actions: [
              Padding(
                padding:
                const EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
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
                    icon: Image.asset('assets/icons/unselected_settings.png', height: 18.0, width: 18.0,),
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
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Text(
                      user != null
                          ? user?.lastName != ''
                              ? '${user!.firstName[0].toUpperCase()}${user!.lastName[0].toUpperCase()}'
                              : '${user!.firstName[0].toUpperCase()}'
                          : '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '${user?.firstName} ${user?.lastName}'.toUpperCase(),
                    style: TextStyle(
                      color: state.themeMode == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: Color(0xFFAFAFAF),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  BlocConsumer<FingerprintCubit, FingerprintState>(
                    listener: (context, state) {
                      if (state is FingerprintSuccess) {
                        if (!hasProfileChanged()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                                content: Text(AppLocalizations.of(context)!.no_changes_to_save)),
                          );
                          toggleEditing();
                        } else {
                          if (formKey.currentState!.validate()) {
                            updateUserData(
                              email: emailController.text,
                              firstName: usernameController.text.split(' ')[0],
                              lastName: usernameController.text.split(' ')[1],
                              phoneNumber: phoneController.text,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                  content:
                                      Text(AppLocalizations.of(context)!.profile_updated_successfully)),
                            );
                            toggleEditing();
                          }
                        }
                      } else if (state is FingerprintFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                              content: Text(AppLocalizations.of(context)!.authentication_failed)),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (isEditing) {
                            context.read<FingerprintCubit>().checkFingerprint();
                          } else {
                            toggleEditing();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            fixedSize: Size.fromHeight(30),
                            backgroundColor: const Color(0xFFE02C45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Text(
                          isEditing ? AppLocalizations.of(context)!.save_profile : AppLocalizations.of(context)!.edit_profile,
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
                  const SizedBox(height: 20.0),
                  buildInputField(
                    label: AppLocalizations.of(context)!.user_name,
                    controller: usernameController,
                    isEnabled: isEditing,
                    hintText: '${user?.firstName} ${user?.lastName}',
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return AppLocalizations.of(context)!.please_enter_valid_name;
                      }
                      return null;
                    },
                    state: state,
                  ),
                  const SizedBox(height: 20.0),
                  buildInputField(
                    label: AppLocalizations.of(context)!.email,
                    controller: emailController,
                    isEnabled: false,
                    hintText: user?.email,
                    keyboardType: TextInputType.emailAddress,
                    state: state,
                  ),
                  const SizedBox(height: 20.0),
                  buildInputField(
                    label: AppLocalizations.of(context)!.phone_number,
                    controller: phoneController,
                    isEnabled: isEditing,
                    hintText: user?.phoneNumber,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.startsWith('01') == false) {
                        return AppLocalizations.of(context)!.please_enter_a_valid_phone_number;
                      }
                      if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                        return AppLocalizations.of(context)!.please_enter_a_valid_11_digit_phone_number;
                      }
                      return null;
                    },
                    state: state,
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
          enabled: isEnabled,
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

  bool hasProfileChanged() {
    final names = usernameController.text.split(' ');
    return names[0] != user?.firstName ||
        names[1] != user?.lastName ||
        phoneController.text != user?.phoneNumber;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> updateUserData({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    // Input Validation
    if (!InputValidator.isValidName(firstName)) {
      debugPrint(AppLocalizations.of(context)!.invalid_first_name);
      return;
    }
    if (!InputValidator.isValidName(lastName)) {
      debugPrint(AppLocalizations.of(context)!.invalid_last_name);
      return;
    }

    if (!InputValidator.isValidPhoneNumber(phoneNumber)) {
      debugPrint(AppLocalizations.of(context)!.invalid_phone_number);
      return;
    }

    // Network Connectivity Check
    if (!await isConnected()) {
      debugPrint(AppLocalizations.of(context)!.no_internet_connection);
      return;
    }

    try {
      // Check if the user already exists
      final existingUser = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existingUser.docs.isEmpty) {
        debugPrint(AppLocalizations.of(context)!.user_with_this_email_not_exists);
        return;
      }

      // Proceed with user select the user to update
      final userId = existingUser.docs.first.id;

      await _firestore.collection('users').doc(userId).update({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'updatedAt': Timestamp.now().toDate(),
      });

      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (result.docs.isEmpty) {
        return null;
      }

      final doc = result.docs.first;
      final user = User.fromJson(doc.data() as Map<String, dynamic>);

      await user?.saveUserToPreferences(user);

      loadUserFromPreferences();

      debugPrint(AppLocalizations.of(context)!.user_updated_successfully);
    } catch (e) {
      debugPrint(AppLocalizations.of(context)!.user_update_failed);
    }
  }
}
