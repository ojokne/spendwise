part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

final class Initialize extends AuthenticationEvent {}

final class Login extends AuthenticationEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});
}

final class Logout extends AuthenticationEvent {}

final class CreateAccount extends AuthenticationEvent {
  final String email;
  final String password;

  CreateAccount({required this.email, required this.password});
}
