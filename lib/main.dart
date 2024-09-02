import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/login_cubit/login_cubit.dart';
import 'package:just_order/repository/auth_repository/login_repository.dart';
import 'package:just_order/screens/splash/splash_screen.dart';
import 'package:just_order/shared/bloc_observer/bloc_observer.dart';
import 'package:just_order/shared/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(LoginRepository()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                color: Colors.white,
                foregroundColor: Colors.white,
                surfaceTintColor: Colors.white,
              ),
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFE02C45),
              ),
              useMaterial3: true,
            ),
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: SplashScreen.routeName,
          );
        },
      ),
    );
  }
}
