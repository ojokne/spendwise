import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendwise/blocs/authentication/authentication_bloc.dart';
import 'package:spendwise/constants/routes.dart';
import 'package:spendwise/widgets/logo.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;

  bool loading = false;

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0.h),
        child: Center(
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationError) {
                setState(() {
                  errorMessage = state.errorMessage;
                  loading = false;
                });
              } else if (state is Authenticated) {
                setState(() {
                  loading = false;
                });
                Navigator.of(context).pushReplacementNamed(Routes.homepage);
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LogoWidget(),
                    SizedBox(height: 25.h),
                    Text(
                      "Create Account",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    if (errorMessage != null) ...[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.red[100]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 10.h),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value?.contains('@') == false) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.h),
                    TextFormField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        fixedSize: Size(200.w, 50.h),
                        shape: RoundedRectangleBorder(),
                      ),
                      onPressed: loading
                          ? null
                          : () {
                              if (formKey.currentState?.validate() == true) {
                                setState(() {
                                  errorMessage = null;
                                  loading = true;
                                });
                                context.read<AuthenticationBloc>().add(
                                  CreateAccount(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                      child: loading
                          ? SizedBox(
                              height: 15.h,
                              width: 15.h,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text("Create Account"),
                    ),

                    TextButton(
                      onPressed: () =>
                          Navigator.of(context)..pushReplacementNamed(Routes.login),
                      child: Text("Login?"),
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
