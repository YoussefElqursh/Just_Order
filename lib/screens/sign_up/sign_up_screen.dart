import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:just_order/blocs/sign_up_cubit/sign_up_cubit.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/screens/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/function/functions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName = 'SignUpScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SignUpScreen(),
    );
  }

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SignUpCubit>(
        create: (context) => SignUpCubit(),
        child: BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is SignUpISuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text(AppLocalizations.of(context)!.sign_up_process_succeeded),
                ),
              );
              navigateToWithoutBack(context, const LoginScreen());
            }
          },
          child: BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              if (state is SignUpLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE02C45),
                  ),
                );
              }
              return BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: MediaQuery.sizeOf(context).width,
                                clipBehavior: Clip.none,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE02C45),
                                  image: DecorationImage(
                                    image: svg.Svg(
                                        'assets/images/background_login.svg'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).width *
                                                0.135),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        setPhoto(
                                          kind: 1,
                                          path:
                                              'assets/images/login_logo_black.svg',
                                          height: 50.0,
                                          width: 25,
                                        ),
                                        const SizedBox(width: 5),
                                        const Text(
                                          'JUST ORDER',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.60,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 40.0),
                                     SizedBox(
                                      width: 220,
                                      child: Text(
                                        AppLocalizations.of(context)!.sign_up,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 0.04,
                                          letterSpacing: -0.64,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                child: Column(),
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.sizeOf(context).width * 0.45,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 750,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 30,
                                  ),
                                  decoration: ShapeDecoration(
                                    color: state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!.first_name,
                                            style: TextStyle(
                                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        SizedBox(
                                          height: 70.0,
                                          child: TextFormField(
                                            controller: _firstNameController,
                                            maxLines: 1,
                                            cursorColor: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                            keyboardType: TextInputType.name,
                                            style: TextStyle(
                                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                maxHeight: 42,
                                              ),
                                              hintText: 'John',
                                              hintStyle: const TextStyle(
                                                color: Color(0xFFCCCCCC),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFE02C45),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0x4CAFAFAF),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.length < 3) {
                                                return AppLocalizations.of(context)!.please_enter_valid_first_name;
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 25.0),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!.last_name,
                                            style: TextStyle(
                                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        SizedBox(
                                          height: 70.0,
                                          child: TextFormField(
                                            controller: _lastNameController,
                                            maxLines: 1,
                                            cursorColor: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                            keyboardType: TextInputType.name,
                                            style: TextStyle(
                                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                maxHeight: 42,
                                              ),
                                              hintText: 'Doe',
                                              hintStyle: const TextStyle(
                                                color: Color(0xFFCCCCCC),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFE02C45),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0x4CAFAFAF),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.length < 3) {
                                                return AppLocalizations.of(context)!.please_enter_valid_name;
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 25.0),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!.email,
                                            style: TextStyle(
                                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        SizedBox(
                                          height: 70.0,
                                          child: TextFormField(
                                            controller: _emailController,
                                            maxLines: 1,
                                            cursorColor: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: TextStyle(
                                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                maxHeight: 42,
                                              ),
                                              hintText: 'yourname@example.com',
                                              hintStyle: const TextStyle(
                                                color: Color(0xFFCCCCCC),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFE02C45),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0x4CAFAFAF),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return AppLocalizations.of(context)!.please_enter_your_email;
                                              } else if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                              ).hasMatch(value)) {
                                                return AppLocalizations.of(context)!.please_enter_valid_email;
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 25.0),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!.phone_number,
                                            style: TextStyle(
                                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        SizedBox(
                                          height: 70.0,
                                          child: TextFormField(
                                            controller: _phoneNumberController,
                                            maxLines: 1,
                                            cursorColor: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                            keyboardType: TextInputType.phone,
                                            style: TextStyle(
                                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                maxHeight: 42,
                                              ),
                                              hintText: '+20 123-456-7890',
                                              hintStyle: const TextStyle(
                                                color: Color(0xFFCCCCCC),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFE02C45),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0x4CAFAFAF),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.startsWith('01') ==
                                                      false) {
                                                return AppLocalizations.of(context)!.please_enter_a_valid_phone_number;
                                              }
                                              if (!RegExp(r'^\d{11}$')
                                                  .hasMatch(value)) {
                                                return 'Please enter a valid 11-digit phone number';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 25.0),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!.password,
                                            style: TextStyle(
                                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        SizedBox(
                                          height: 70.0,
                                          child: TextFormField(
                                            controller: _passwordController,
                                            obscureText: context
                                                .read<SignUpCubit>()
                                                .isPassword,
                                            maxLines: 1,
                                            cursorColor: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            style: TextStyle(
                                              color: state.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                maxHeight: 42,
                                              ),
                                              hintText: '*************',
                                              hintStyle: const TextStyle(
                                                color: Color(0xFFCCCCCC),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFE02C45),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0x4CAFAFAF),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<SignUpCubit>()
                                                      .changePasswordState();
                                                },
                                                icon: Icon(
                                                    context
                                                        .read<SignUpCubit>()
                                                        .suffixIcon,
                                                    color:
                                                        const Color(0xFFAFAFAF),
                                                    size: 18.0),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return AppLocalizations.of(context)!.please_enter_your_password;
                                              } else if (value.length < 6) {
                                                return AppLocalizations.of(context)!.password_must_be_at_least_6_characters;
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        const SizedBox(height: 18.0),
                                        MaterialButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<SignUpCubit>()
                                                  .signUp(
                                                    email: _emailController.text
                                                        .toLowerCase(),
                                                    firstName:
                                                        _firstNameController
                                                            .text,
                                                    lastName:
                                                        _lastNameController
                                                            .text,
                                                    phoneNumber:
                                                        _phoneNumberController
                                                            .text,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                  );
                                            }
                                          },
                                          height: 42,
                                          minWidth:
                                              MediaQuery.sizeOf(context).width,
                                          clipBehavior: Clip.antiAlias,
                                          color: const Color(0xFFE02C45),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: state is SignUpLoadingState
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              :  Center(
                                                  child: Text(
                                                    AppLocalizations.of(context)!.sign_up,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(height: 25.0),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                             Text(
                                               AppLocalizations.of(context)!.already_have_an_account,
                                              style: TextStyle(
                                                color: Color(0xFF898888),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: -0.12,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            GestureDetector(
                                              onTap: () {
                                                navigateTo(context,
                                                    'LoginScreenRoute');
                                              },
                                              child:  Text(
                                                AppLocalizations.of(context)!.login,
                                                style: TextStyle(
                                                  color: Color(0xFFE02C45),
                                                  fontSize: 12,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
