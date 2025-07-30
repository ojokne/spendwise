import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spendwise/blocs/transactions/transactions_bloc.dart';
import 'package:spendwise/models/transaction.dart';
import 'package:spendwise/services/firebaseService.dart';
import 'package:spendwise/services/sharedPreferencesService.dart';
import 'package:spendwise/utilities.dart';

import 'transactions_bloc_test.mocks.dart';

@GenerateMocks([
  FirebaseService,
  SharedPreferencesService,
  BuildContext,
])
void main() {
  late MockFirebaseService mockFirebaseService;
  late MockSharedPreferencesService mockSharedPreferencesService;
  late TransactionsBloc bloc;
  late MockBuildContext mockContext;

  final transaction1 = Transaction(
    id: '1',
    name: 'Coffee',
    amount: 5,
    date: DateTime(2023, 1, 1),
  );
  final transaction2 = Transaction(
    id: '2',
    name: 'Tea',
    amount: 3,
    date: DateTime(2023, 1, 2),
  );
  final userId = 'user123';

  setUp(() {
    mockContext = MockBuildContext();
    mockFirebaseService = MockFirebaseService();
    mockSharedPreferencesService = MockSharedPreferencesService();
    bloc = TransactionsBloc(
      firebaseService: mockFirebaseService,
      sharedPreferencesService: mockSharedPreferencesService,
    );
  });

  group('TransactionsBloc', () {
    blocTest<TransactionsBloc, TransactionsState>(
      'emits [TransactionsLoading, TransactionsLoaded] on LoadTransactions success',
      build: () {
        when(
          mockSharedPreferencesService.getStringValue('userId'),
        ).thenAnswer((_) async => userId);
        when(
          mockFirebaseService.getTransactions(userId),
        ).thenAnswer((_) async => [transaction1, transaction2]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTransactions()),
      expect: () => [
        TransactionsLoading(),
        TransactionsLoaded(
          transactions: [transaction1, transaction2],
          totalAmount: 8,
        ),
      ],
    );

    blocTest<TransactionsBloc, TransactionsState>(
      'emits [TransactionsLoading, TransactionsError] on LoadTransactions when userId is null',
      build: () {
        when(
          mockSharedPreferencesService.getStringValue('userId'),
        ).thenAnswer((_) async => null);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTransactions()),
      expect: () => [TransactionsLoading(), isA<TransactionsError>()],
    );

    blocTest<TransactionsBloc, TransactionsState>(
      'emits [TransactionsLoading, TransactionsError] on LoadTransactions failure',
      build: () {
        when(
          mockSharedPreferencesService.getStringValue('userId'),
        ).thenAnswer((_) async => userId);
        when(
          mockFirebaseService.getTransactions(userId),
        ).thenThrow(Exception('fail'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTransactions()),
      expect: () => [TransactionsLoading(), isA<TransactionsError>()],
    );

    blocTest<TransactionsBloc, TransactionsState>(
      'emits TransactionsLoaded with new transaction on CreateTransaction success',
      build: () {
        when(
          mockSharedPreferencesService.getStringValue('userId'),
        ).thenAnswer((_) async => userId);
        when(
          mockFirebaseService.createTransaction(userId, transaction2),
        ).thenAnswer((_) async => null);
        return bloc;
      },
      seed: () =>
          TransactionsLoaded(transactions: [transaction1], totalAmount: 5),
      act: (bloc) => bloc.add(
        CreateTransaction(
          transaction: transaction2,
          context: mockContext,
        ),
      ),
      expect: () => [
        TransactionsLoaded(
          transactions: [transaction2, transaction1],
          totalAmount: 8,
        ),
      ],
    );

    blocTest<TransactionsBloc, TransactionsState>(
      'emits TransactionsLoaded with edited transaction on EditTransaction success',
      build: () {
        when(
          mockSharedPreferencesService.getStringValue('userId'),
        ).thenAnswer((_) async => userId);
        when(
          mockFirebaseService.editTransaction(userId, '1', 'Latte', 7),
        ).thenAnswer((_) async => null);
        return bloc;
      },
      seed: () =>
          TransactionsLoaded(transactions: [transaction1], totalAmount: 5),
      act: (bloc) => bloc.add(
        EditTransaction(
          txnId: '1',
          name: 'Latte',
          amount: 7,
          context: mockContext,
        ),
      ),
      expect: () => [
        TransactionsLoaded(
          transactions: [
            Transaction(
              id: '1',
              name: 'Latte',
              amount: 7,
              date: transaction1.date,
            ),
          ],
          totalAmount: 7,
        ),
      ],
    );

    blocTest<TransactionsBloc, TransactionsState>(
      'emits TransactionsLoaded with transaction removed on DeleteTransaction success',
      build: () {
        when(
          mockSharedPreferencesService.getStringValue('userId'),
        ).thenAnswer((_) async => userId);
        when(
          mockFirebaseService.deleteTransaction(userId, '1'),
        ).thenAnswer((_) async => null);
        return bloc;
      },
      seed: () => TransactionsLoaded(
        transactions: [transaction1, transaction2],
        totalAmount: 8,
      ),
      act: (bloc) =>
          bloc.add(DeleteTransaction(txnId: '1', context: mockContext)),
      expect: () => [
        TransactionsLoaded(transactions: [transaction2], totalAmount: 3),
      ],
    );
  });
}
