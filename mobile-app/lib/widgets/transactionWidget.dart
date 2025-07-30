import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendwise/models/transaction.dart';
import 'package:spendwise/utilities.dart';

class TransactionWidget extends StatelessWidget {
  final VoidCallback onDelete;
  const TransactionWidget({super.key, required this.transaction, required this.onDelete});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(),
      child: Row(
        children: [
          IconButton(
            onPressed: () => onDelete(),
            icon: Icon(Icons.delete_outline, color: Colors.red),
          ),
          Expanded(
            child: ListTile(
              title: Text(transaction.name),
              trailing: Text(
                Utilities.formatAmount(transaction.amount),
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              subtitle: Text(Utilities.formatDate(transaction.date.toLocal())),
            ),
          ),
        ],
      ),
    );
  }
}
