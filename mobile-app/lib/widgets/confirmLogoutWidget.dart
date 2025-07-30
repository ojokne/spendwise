import 'package:flutter/material.dart';

class ConfirmLogoutWidget extends StatelessWidget {
  const ConfirmLogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text("No"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}
