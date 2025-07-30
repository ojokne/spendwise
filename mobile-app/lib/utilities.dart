import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utilities {
  static String formatAmount(int amount) {
    return NumberFormat.currency(
      locale: 'en-US',
      symbol: 'UGX ',
      decimalDigits: 0,
    ).format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM, HH:mm').format(date);
  }

  static void showSnackBar(String message, BuildContext context, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
