import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:just_order/blocs/sign_up_cubit/sign_up_cubit.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/screens/login/login_screen.dart';
import 'package:just_order/shared/style/colors.dart';

import '../../shared/function/functions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName = 'SignUpScreenRoute';

  static Route route() => MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SignUpScreen(),
      );

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isTermsAccepted = false;
  bool _showTermsError = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: BlocProvider(
        create: (_) => SignUpCubit(),
        child: BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            } else if (state is SignUpISuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.sign_up_process_succeeded,
                  ),
                ),
              );
              navigateToWithoutBack(
                context,
                const LoginScreen(),
              );
            }
          },
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final isDark = themeState.themeMode == ThemeMode.dark;
              return Stack(
                children: [
                  _buildBackground(
                    context,
                    screenWidth,
                    isDark,
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenWidth * 0.45,
                        bottom: 20.0,
                      ),
                      child: _buildSignUpForm(
                        context,
                        isDark,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(
    BuildContext context,
    double width,
    bool isDark,
  ) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: const BoxDecoration(
              color: Color(0xFFE02C45),
              image: DecorationImage(
                image: svg.Svg(
                  'assets/images/background_login.svg',
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: width * 0.135,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    setPhoto(
                      kind: 1,
                      path: 'assets/images/login_logo_black.svg',
                      height: 50,
                      width: 25,
                    ),
                    const Text(
                      'JUST ORDER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  AppLocalizations.of(context)!.sign_up,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: isDark ? Colors.black : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm(
    BuildContext context,
    bool isDark,
  ) {
    final width = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 30,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildLabeledTextField(
                label: AppLocalizations.of(context)!.first_name,
                hint: 'John',
                controller: _firstNameController,
                themeDark: isDark,
                validator: (value) => value == null || value.length < 3
                    ? AppLocalizations.of(context)!
                        .please_enter_valid_first_name
                    : null,
              ),
              _buildLabeledTextField(
                label: AppLocalizations.of(context)!.last_name,
                hint: 'Doe',
                controller: _lastNameController,
                themeDark: isDark,
                validator: (value) => value == null || value.length < 3
                    ? AppLocalizations.of(context)!.please_enter_valid_name
                    : null,
              ),
              _buildLabeledTextField(
                label: AppLocalizations.of(context)!.email,
                hint: 'example@email.com',
                controller: _emailController,
                themeDark: isDark,
                validator: (value) => value == null || !value.contains('@')
                    ? AppLocalizations.of(context)!.please_enter_valid_email
                    : null,
              ),
              _buildLabeledTextField(
                label: AppLocalizations.of(context)!.phone_number,
                hint: '+20 123-456-7890',
                controller: _phoneNumberController,
                themeDark: isDark,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !value.startsWith('01')) {
                    return AppLocalizations.of(context)!
                        .please_enter_a_valid_phone_number;
                  }
                  if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                    return 'Please enter a valid 11-digit phone number';
                  }
                  return null;
                },
              ),
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (prev, curr) => curr is SignUpShowPassword,
                builder: (context, state) {
                  final cubit = context.read<SignUpCubit>();
                  return _buildLabeledTextField(
                    label: AppLocalizations.of(context)!.password,
                    hint: '*************',
                    controller: _passwordController,
                    themeDark: isDark,
                    obscureText: cubit.isPassword,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      onPressed: cubit.changePasswordState,
                      icon: Icon(
                        cubit.suffixIcon,
                        size: 18,
                        color: const Color(0xFFAFAFAF),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .please_enter_your_password;
                      } else if (value.length < 6) {
                        return AppLocalizations.of(context)!
                            .password_must_be_at_least_6_characters;
                      }
                      return null;
                    },
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isTermsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _isTermsAccepted = value!;
                        _showTermsError = false; // reset error when checked
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: const BorderSide(
                      width: 1,
                      color: Color(0x4CAFAFAF),
                    ),
                    activeColor: AppColor.primaryColor,
                    checkColor:
                        isDark ? AppColor.blackColor : AppColor.whiteColor,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'I have read and agree to the ',
                            style: TextStyle(
                              color: Color(0xFF090909),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: Color(0xFFE02C45),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColor.primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: TextStyle(
                              color: Color(0xFF090909),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFFE02C45),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColor.primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: '.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_showTermsError)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 4),
                  child: Text(
                    "You must accept the Terms & Conditions.",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  return MaterialButton(
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();

                      if (!_isTermsAccepted) {
                        setState(() {
                          _showTermsError = true;
                        });
                      }

                      if (isValid && _isTermsAccepted) {
                        context.read<SignUpCubit>().signUp(
                              email: _emailController.text.trim().toLowerCase(),
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              phoneNumber: _phoneNumberController.text.trim(),
                              password: _passwordController.text,
                            );
                      }
                    },
                    height: 42,
                    minWidth: width,
                    color: const Color(0xFFE02C45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: state is SignUpLoadingState
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            AppLocalizations.of(context)!.sign_up,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 25),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool themeDark,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            label,
            style: TextStyle(
              color: themeDark ? Colors.white : Colors.black,
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFCCCCCC) /* Gray-Smoke */,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0x4CAFAFAF),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xFFE02C45),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0x4CAFAFAF),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.already_have_an_account,
          style: const TextStyle(
            color: Color(0xFF898888),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.40,
            letterSpacing: -0.12,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => navigateTo(context, 'LoginScreenRoute'),
          child: Text(
            AppLocalizations.of(context)!.login,
            style: const TextStyle(
              color: Color(0xFFE02C45),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.40,
              letterSpacing: -0.12,
            ),
          ),
        ),
      ],
    );
  }
}
