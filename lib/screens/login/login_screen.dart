import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:just_order/blocs/login_cubit/login_cubit.dart';
import 'package:just_order/blocs/login_cubit/login_state.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/auth_repository/login_repository.dart';
import 'package:just_order/screens/QR/select_your_place_screen.dart';
import 'package:just_order/shared/function/functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = 'LoginScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _loginRepository = LoginRepository();

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(LoginRepository()),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            } else if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${AppLocalizations.of(context)!.welcome}, ${state.user.firstName} ! ',
                  ),
                ),
              );
              navigateToWithoutBack(context, const SelectYourPlace());
            }
          },
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE02C45),
                  ),
                );
              }
              return BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  final isDark = state.themeMode == ThemeMode.dark;
                  return Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
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
                          child: _buildLoginForm(
                            context,
                            isDark,
                            state,
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
                SizedBox(
                  width: 230,
                  child: Text(
                    AppLocalizations.of(context)!.sign_in_to_your_account,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  AppLocalizations.of(context)!
                      .enter_your_email_and_password_to_login,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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

  Widget _buildLoginForm(
    BuildContext context,
    bool isDark,
    ThemeState state,
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
              MaterialButton(
                onPressed: () {
                  context.read<LoginCubit>().loginWithGoogle();
                },
                height: 42,
                minWidth: width,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: state.themeMode == ThemeMode.dark
                        ? Colors.white
                        : const Color(0x4CAFAFAF),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    setPhoto(
                      kind: 1,
                      path: 'assets/images/google.svg',
                      width: 18.0,
                      height: 18.0,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      AppLocalizations.of(context)!.continue_with_google,
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
                  ],
                ),
              ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.50,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: state.themeMode == ThemeMode.dark
                                ? Colors.white
                                : const Color(0x4CAFAFAF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    AppLocalizations.of(context)!.or_login_with,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: state.themeMode == ThemeMode.dark
                          ? Colors.white
                          : const Color(0xFF898888),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.50,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: state.themeMode == ThemeMode.dark
                                ? Colors.white
                                : const Color(0x4CAFAFAF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              _buildLabeledTextField(
                label: AppLocalizations.of(context)!.email,
                hint: 'example@email.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                themeDark: isDark,
                validator: (value) => value == null || !value.contains('@')
                    ? AppLocalizations.of(context)!.please_enter_valid_email
                    : null,
                themeMode: state.themeMode,
              ),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (prev, curr) => curr is LoginShowPassword,
                builder: (context, lState) {
                  final cubit = context.read<LoginCubit>();
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
                    themeMode: state.themeMode,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      navigateTo(
                        context,
                        'ForgotPasswordRoute',
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.forget_password,
                      style: const TextStyle(
                        color: Color(0xFFE02C45),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          User? user = await _loginRepository.login(
                            _emailController.text.toLowerCase(),
                            _passwordController.text,
                          );
                          if (user != null) {
                            _showSnackBar(
                              // ignore: use_build_context_synchronously
                              AppLocalizations.of(context)!.login_sucessful,
                              Colors.green,
                            );
                            Navigator.pushAndRemoveUntil(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectYourPlace()),
                              (route) => false, // Remove all previous routes
                            );
                          } else {
                            _showSnackBar(
                              // ignore: use_build_context_synchronously
                              AppLocalizations.of(context)!
                                  .invalid_email_or_password,
                              Colors.red,
                            );
                          }
                        } catch (e) {
                          _showSnackBar(
                            e.toString(),
                            Colors.red,
                          );
                        }
                      }
                    },
                    height: 42,
                    minWidth: width,
                    color: const Color(0xFFE02C45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: state is LoginLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            AppLocalizations.of(context)!.login,
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
    required ThemeMode themeMode,
    required bool themeDark,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    final textColor =
        themeMode == ThemeMode.light ? Colors.black : Colors.white;
    final labelStyle = TextStyle(
      color: textColor,
      fontSize: 10,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
    );

    final inputStyle = TextStyle(
      color: textColor,
      fontSize: 12,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          label,
          style: labelStyle,
        ),
        SizedBox(
          height: 70,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            style: inputStyle,
            decoration: InputDecoration(
              constraints: const BoxConstraints(
                maxHeight: 42,
              ),
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
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: [
        Text(
          AppLocalizations.of(context)!.dont_have_an_account,
          style: const TextStyle(
            color: Color(0xFF898888),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.40,
            letterSpacing: -0.12,
          ),
        ),
        GestureDetector(
          onTap: () => navigateTo(
            context,
            'SignUpScreenRoute',
          ),
          child: Text(
            AppLocalizations.of(context)!.sign_up,
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
