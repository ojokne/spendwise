part of 'transactions_bloc.dart';

@immutable
sealed class TransactionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class TransactionsInitial extends TransactionsState {}

final class TransactionsLoading extends TransactionsState {}

final class TransactionsLoaded extends TransactionsState {
  final List<Transaction> transactions;
  final int totalAmount;

  TransactionsLoaded({required this.transactions, required this.totalAmount});

  @override
  List<Object?> get props => [transactions, totalAmount];
}

final class TransactionsError extends TransactionsState {
  final String errorMessage;

  TransactionsError({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
