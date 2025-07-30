import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:spendwise/dependencyInjection.dart';
import 'package:spendwise/models/transaction.dart';
import 'package:spendwise/services/firebaseService.dart';
import 'package:spendwise/services/sharedPreferencesService.dart';
import 'package:spendwise/utilities.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final FirebaseService _firebaseService;
  final SharedPreferencesService _sharedPreferencesService;
  TransactionsBloc({
    FirebaseService? firebaseService,
    SharedPreferencesService? sharedPreferencesService,
  }) : _firebaseService = firebaseService ?? locator.get<FirebaseService>(),
       _sharedPreferencesService =
           sharedPreferencesService ?? locator.get<SharedPreferencesService>(),

       super(TransactionsInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<CreateTransaction>(_onCreateTransaction);
    on<EditTransaction>(_onEditTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(TransactionsLoading());

    List<Transaction> transactions = [];

    try {
      String? userId = await _sharedPreferencesService.getStringValue("userId");

      if (userId != null) {
        transactions = await _firebaseService.getTransactions(userId);
        emit(
          TransactionsLoaded(
            transactions: transactions,
            totalAmount: transactions.fold(0, (prev, txn) => prev + txn.amount),
          ),
        );
      } else {
        emit(
          TransactionsError(
            errorMessage:
                "This user is not authenticated\nPlease login to see transactions!",
          ),
        );
      }
    } catch (e) {
      Logger().e('Failed to load transactions: $e');
      emit(
        TransactionsError(
          errorMessage:
              "Failed to load transactions\nPress the refresh button at the bottom to try again!",
        ),
      );
    }
  }

  Future<void> _onCreateTransaction(
    CreateTransaction event,
    Emitter emit,
  ) async {
    final state = this.state;
    if (state is TransactionsLoaded) {
      try {
        String? userId = await _sharedPreferencesService.getStringValue(
          "userId",
        );

        if (userId != null) {
          Transaction newTransaction = event.transaction.copyWith(
            userId: userId,
            date: DateTime.now(),
          );
          await _firebaseService.createTransaction(userId, newTransaction);
          List<Transaction> transactions = [
            event.transaction,
            ...state.transactions,
          ];
          emit(
            TransactionsLoaded(
              transactions: transactions,
              totalAmount: transactions.fold(
                0,
                (prev, txn) => prev + txn.amount,
              ),
            ),
          );
        } else {
          if (event.context.mounted) {
            Utilities.showSnackBar(
              "Please login to create a transaction",
              event.context,
              Colors.red,
            );
          }
        }
      } catch (e) {
        Logger().e("Failed to create transaction:: $e");
        if (event.context.mounted) {
          Utilities.showSnackBar(
            "Failed to create transaction Please try again!",
            event.context,
            Colors.red,
          );
        }
        emit(
          TransactionsLoaded(
            transactions: state.transactions,
            totalAmount: state.totalAmount,
          ),
        );
      }
    }
  }

  Future<void> _onEditTransaction(EditTransaction event, Emitter emit) async {
    final state = this.state;
    if (state is TransactionsLoaded) {
      try {
        String? userId = await _sharedPreferencesService.getStringValue(
          "userId",
        );

        if (userId != null) {
          await _firebaseService.editTransaction(
            userId,
            event.txnId,
            event.name,
            event.amount,
          );
          List<Transaction> transactions = state.transactions.map((txn) {
            return txn.id == event.txnId
                ? Transaction(
                    id: txn.id,
                    date: txn.date,
                    name: event.name,
                    amount: event.amount,
                  )
                : txn;
          }).toList();
          emit(
            TransactionsLoaded(
              transactions: transactions,
              totalAmount: transactions.fold(
                0,
                (prev, txn) => prev + txn.amount,
              ),
            ),
          );
        } else {
          if (event.context.mounted) {
            Utilities.showSnackBar(
              "Please login to edit a transaction",
              event.context,
              Colors.red,
            );
          }
        }
      } catch (e) {
        Logger().e("Failed to edit transaction:: $e");
        if (event.context.mounted) {
          Utilities.showSnackBar(
            "Failed to edit transaction Please try again!",
            event.context,
            Colors.red,
          );
        }
        emit(
          TransactionsLoaded(
            transactions: state.transactions,
            totalAmount: state.totalAmount,
          ),
        );
      }
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter emit,
  ) async {
    final state = this.state;
    if (state is TransactionsLoaded) {
      try {
        String? userId = await _sharedPreferencesService.getStringValue(
          "userId",
        );

        if (userId != null) {
          List<Transaction> transactions = state.transactions
              .where((txn) => txn.id != event.txnId)
              .toList();
          emit(
            TransactionsLoaded(
              transactions: transactions,
              totalAmount: transactions.fold(
                0,
                (prev, txn) => prev + txn.amount,
              ),
            ),
          );

          await _firebaseService.deleteTransaction(userId, event.txnId);
        } else {
          if (event.context.mounted) {
            Utilities.showSnackBar(
              "Please login to delete a transaction",
              event.context,
              Colors.red,
            );
          }
        }
      } catch (e) {
        Logger().e("Failed to delete transaction:: $e");
        if (event.context.mounted) {
          Utilities.showSnackBar(
            "Failed to delete transaction Please try again!",
            event.context,
            Colors.red,
          );
        }
        emit(
          TransactionsLoaded(
            transactions: state.transactions,
            totalAmount: state.totalAmount,
          ),
        );
      }
    }
  }
}
