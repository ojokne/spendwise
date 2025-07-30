import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendwise/blocs/authentication/authentication_bloc.dart';
import 'package:spendwise/blocs/transactions/transactions_bloc.dart';

final allBlocProviders = [
  BlocProvider<AuthenticationBloc>(create: (context) => AuthenticationBloc()..add(Initialize())),
  BlocProvider<TransactionsBloc>(create: (context) => TransactionsBloc()),
];
