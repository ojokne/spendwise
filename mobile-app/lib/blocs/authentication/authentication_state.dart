part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class Unauthenticated extends AuthenticationState {}

final class AuthenticationError extends AuthenticationState {
  final String errorMessage;

  AuthenticationError({required this.errorMessage});
}

final class Authenticated extends AuthenticationState {}