import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendwise/blocs/authentication/authentication_bloc.dart';
import 'package:spendwise/constants/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Future.delayed(
              const Duration(seconds: 3),
              () => Navigator.of(context).pushReplacementNamed(Routes.login),
            );
          } else if (state is Authenticated) {
            Future.delayed(
              const Duration(seconds: 3),
              () => Navigator.of(context).pushReplacementNamed(Routes.homepage),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15.h,
                width: 15.h,
                child: CircularProgressIndicator(),
              ),
              SizedBox(height: 20.h),
              Text(
                "SpendWise",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
