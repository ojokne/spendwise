import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendwise/blocs/transactions/transactions_bloc.dart';
import 'package:spendwise/models/transaction.dart';

class NewtransactionWidget extends StatefulWidget {
  const NewtransactionWidget({super.key});

  @override
  State<NewtransactionWidget> createState() => _NewtransactionWidgetState();
}

class _NewtransactionWidgetState extends State<NewtransactionWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionsBloc, TransactionsState>(
      listener: (context, state) {
        if (state is TransactionsLoaded) {
          setState(() {
            loading = false;
          });
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 20.h),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "New Transaction",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25.0.h),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty != false) {
                      return 'Enter a name for the transaction';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty != false) {
                      return 'Enter the amount for the transaction';
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
                              loading = true;
                            });
                            context.read<TransactionsBloc>().add(
                              CreateTransaction(
                                context: context,
                                transaction: Transaction(
                                  date: DateTime.now(),
                                  name: nameController.text.trim(),
                                  amount: int.parse(
                                    amountController.text.trim(),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                  child: loading
                      ? SizedBox(
                          height: 15.h,
                          width: 15.h,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Text("Create"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
