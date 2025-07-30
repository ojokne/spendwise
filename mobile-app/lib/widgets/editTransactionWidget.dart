import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendwise/blocs/transactions/transactions_bloc.dart';
import 'package:spendwise/models/transaction.dart';

class EdittransactionWidget extends StatefulWidget {
  final Transaction transaction;
  const EdittransactionWidget({super.key, required this.transaction});

  @override
  State<EdittransactionWidget> createState() => _EdittransactionWidgetState();
}

class _EdittransactionWidgetState extends State<EdittransactionWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    nameController.text = widget.transaction.name;
    amountController.text = widget.transaction.amount.toString();
    super.initState();
  }

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
                  "Edit Transaction",
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
                              // errorMessage = null;
                              loading = true;
                            });
                            context.read<TransactionsBloc>().add(
                              EditTransaction(
                                              context: context,
                                txnId: widget.transaction.id!,
                                name: nameController.text.trim(),
                                amount: int.parse(amountController.text.trim()),
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
                      : Text("Save"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
