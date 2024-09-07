import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/login_cubit/login_cubit.dart';
import 'package:just_order/blocs/login_cubit/login_state.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/auth_repository/login_repository.dart';
import 'package:just_order/screens/QR/select_your_place_screen.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;

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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(LoginRepository()),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Welcome, ${state.user.firstName} ! '),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                    height: MediaQuery.sizeOf(context).width *
                                        0.135),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    setPhoto(
                                        kind: 1,
                                        path:
                                            'assets/images/login_logo_black.svg',
                                        height: 50.0,
                                        width: 25),
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
                                const SizedBox(height: 20.0),
                                const SizedBox(
                                  width: 230,
                                  child: Text('Sign in to your Account',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.64,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2),
                                ),
                                const SizedBox(height: 12.0),
                                const Text(
                                  'Enter your email and password to Login ',
                                  style: TextStyle(
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
                        const Expanded(
                          child: Column(),
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
                            height: MediaQuery.sizeOf(context).width * 0.55,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              height: 463,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 30,
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        context
                                            .read<LoginCubit>()
                                            .loginWithGoogle();
                                      },
                                      height: 42,
                                      minWidth:
                                          MediaQuery.sizeOf(context).width,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          width: 1,
                                          strokeAlign:
                                              BorderSide.strokeAlignCenter,
                                          color: Color(0x4CAFAFAF),
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          setPhoto(
                                            kind: 1,
                                            path: 'assets/images/google.svg',
                                            width: 18.0,
                                            height: 18.0,
                                          ),
                                          const SizedBox(width: 10.0),
                                          const Text(
                                            'Continue with Google',
                                            style: TextStyle(
                                              color: Colors.black,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: const ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 0.50,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                  color: Color(0x4CAFAFAF),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        const Text(
                                          'Or login with',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF898888),
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
                                            decoration: const ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 0.50,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                  color: Color(0x4CAFAFAF),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    TextFormField(
                                      controller: _emailController,
                                      maxLines: 1,
                                      cursorColor: Colors.black,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.sizeOf(context).width,
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
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        } else if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                        ).hasMatch(value)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 25.0),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Password',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    TextFormField(
                                        controller: _passwordController,
                                        obscureText: context
                                            .read<LoginCubit>()
                                            .isPassword,
                                        maxLines: 1,
                                        cursorColor: Colors.black,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        style: const TextStyle(
                                          color: Color(0xFF000000),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.sizeOf(context)
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
                                                  .read<LoginCubit>()
                                                  .changePasswordState();
                                            },
                                            icon: Icon(
                                                context
                                                    .read<LoginCubit>()
                                                    .suffixIcon,
                                                color: const Color(0xFFAFAFAF),
                                                size: 18.0),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          } else if (value.length < 6) {
                                            return 'Password must be at least 6 characters';
                                          }
                                          return null;
                                        }),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: const Text(
                                          'Forgot password?',
                                          style: TextStyle(
                                            color: Color(0xFFE02C45),
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18.0),
                                    MaterialButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          try {
                                            User? user =
                                                await _loginRepository.login(
                                              _emailController.text,
                                              _passwordController.text,
                                            );
                                            if (user != null) {
                                              _showSnackBar('Login successful',
                                                  Colors.green);
                                              navigateToWithoutBack(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                const SelectYourPlace(),
                                              );
                                            } else {
                                              _showSnackBar(
                                                  'Invalid email or password',
                                                  Colors.red);
                                            }
                                          } catch (e) {
                                            _showSnackBar(
                                                e.toString(), Colors.red);
                                          }
                                        }
                                      },
                                      height: 42,
                                      minWidth:
                                          MediaQuery.sizeOf(context).width,
                                      clipBehavior: Clip.antiAlias,
                                      color: const Color(0xFFE02C45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: state is LoginLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Center(
                                              child: Text(
                                                'Login',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
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
                                        const Text(
                                          'Don’t have an account?',
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
                                            navigateTo(
                                                context, 'SignUpScreenRoute');
                                          },
                                          child: const Text(
                                            'Sign Up',
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
          ),
        ),
      ),
    );
  }
}
