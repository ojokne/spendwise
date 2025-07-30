import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:spendwise/dependencyInjection.dart';
import 'package:spendwise/services/firebaseService.dart';
import 'package:spendwise/services/sharedPreferencesService.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseService _firebaseService;
  final SharedPreferencesService _sharedPreferencesService;

  AuthenticationBloc({
    FirebaseService? firebaseService,
    SharedPreferencesService? sharedPreferencesService,
  }) : _firebaseService = firebaseService ?? locator.get<FirebaseService>(),
       _sharedPreferencesService =
           sharedPreferencesService ?? locator.get<SharedPreferencesService>(),
       super(AuthenticationInitial()) {
    on<Initialize>(_onInitialize);
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
    on<CreateAccount>(_onCreateAccount);
  }

  Future<void> _onInitialize(Initialize event, Emitter emit) async {
    emit(Unauthenticated());
  }

  Future<void> _onLogin(Login event, Emitter emit) async {
    try {
      User? user = await _firebaseService.login(event.email, event.password);

      if (user != null) {
        await _sharedPreferencesService.saveStringValue('userId', user.uid);
        emit(Authenticated());
      }
    } catch (e) {
      emit(AuthenticationError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLogout(Logout event, Emitter emit) async {
    await _firebaseService.logout();
    await _sharedPreferencesService.clearPreferences();
    emit(Unauthenticated());
  }

  Future<void> _onCreateAccount(CreateAccount event, Emitter emit) async {
    try {
      User? user = await _firebaseService.createAccount(
        event.email,
        event.password,
      );

      if (user != null) {
        await _sharedPreferencesService.saveStringValue('userId', user.uid);
        emit(Authenticated());
      }
    } catch (e) {
      emit(AuthenticationError(errorMessage: e.toString()));
    }
  }
}
