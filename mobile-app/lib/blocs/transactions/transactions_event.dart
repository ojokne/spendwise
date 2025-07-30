part of 'transactions_bloc.dart';

@immutable
sealed class TransactionsEvent {}

final class LoadTransactions extends TransactionsEvent {}

final class CreateTransaction extends TransactionsEvent {
  final BuildContext context;
  final Transaction transaction;

  CreateTransaction({required this.context, required this.transaction});
}

final class EditTransaction extends TransactionsEvent {
  final BuildContext context;
  final String txnId;
  final String name;
  final int amount;

  EditTransaction({
    required this.context,
    required this.txnId,
    required this.name,
    required this.amount,
  });
}

final class DeleteTransaction extends TransactionsEvent {
  final BuildContext context;
  final String txnId;

  DeleteTransaction({required this.context, required this.txnId});
}
