import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendwise/blocs/authentication/authentication_bloc.dart';
import 'package:spendwise/blocs/transactions/transactions_bloc.dart';
import 'package:spendwise/constants/routes.dart';
import 'package:spendwise/utilities.dart';
import 'package:spendwise/widgets/confirmDeleteWidget.dart';
import 'package:spendwise/widgets/confirmLogoutWidget.dart';
import 'package:spendwise/widgets/editTransactionWidget.dart';
import 'package:spendwise/widgets/newTransactionWidget.dart';
import 'package:spendwise/widgets/transactionWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<TransactionsBloc>().add(LoadTransactions());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'SpendWise',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: null,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Theme.of(context).primaryColor),
            onPressed: () async {
              final bool result = await showDialog(
                context: context,
                builder: (context) => ConfirmLogoutWidget(),
              );

              if (result) {
                if (context.mounted) {
                  context.read<AuthenticationBloc>().add(Logout());
                  Navigator.pushReplacementNamed(context, Routes.login);
                }
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: (state is TransactionsLoaded)
                    ? (state.transactions.isEmpty)
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sentiment_dissatisfied,
                                    size: 50.sp,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    textAlign: TextAlign.center,
                                    "Make some transactions\nthey will show up here!",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = state.transactions[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    bottom: 4.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        builder: (context) =>
                                            EdittransactionWidget(
                                              transaction: transaction,
                                            ),
                                      );
                                    },
                                    child: TransactionWidget(
                                      transaction: transaction,
                                      onDelete: () async {
                                        final bool result = await showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ConfirmDeleteWidget(),
                                        );

                                        if (result) {
                                          context.read<TransactionsBloc>().add(
                                            DeleteTransaction(
                                              context: context,
                                              txnId: transaction.id!,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                    : (state is TransactionsLoading)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15.h,
                              width: 15.h,
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              textAlign: TextAlign.center,
                              "Loading Transactions",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      )
                    : (state is TransactionsError)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied,
                              size: 50.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              textAlign: TextAlign.center,
                              state.errorMessage,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 32.0.h,
                    left: 20.w,
                    right: 20.w,
                    top: 16.0.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount Spent",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (state is TransactionsLoaded)
                                ? Utilities.formatAmount(state.totalAmount)
                                : "UGX 0.00",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: const Divider(),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () =>
                                  context.read<TransactionsBloc>()
                                    ..add(LoadTransactions()),
                              icon: Icon(
                                Icons.refresh,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  builder: (context) => NewtransactionWidget(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("New Transaction"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
