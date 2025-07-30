import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendwise/blocs/blocProviders.dart';
import 'package:spendwise/constants/routes.dart';
import 'package:spendwise/dependencyInjection.dart';
import 'package:spendwise/firebase_options.dart';
import 'package:spendwise/screens/authentication/createAccount.dart';
import 'package:spendwise/screens/authentication/login.dart';
import 'package:spendwise/screens/main/homepage.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupLocator();
  await locator.allReady();

  runApp(
    ScreenUtilInit(
      designSize: const Size(448.0, 973.34),
      builder: (context, child) => const SpendWiseApp(),
    ),
  );
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: allBlocProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SpendWise',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: Routes.splash,
        routes: {
          Routes.splash: (context) => const SplashScreen(),
          Routes.login: (context) => const LoginScreen(),
          Routes.createAccount: (context) => const CreateAccountScreen(),
          Routes.homepage: (context) => const HomeScreen(),
        },
      ),
    );
  }
}
