import 'package:flutter/material.dart';

class ConfirmDeleteWidget extends StatelessWidget {
  const ConfirmDeleteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text("Confirm Delete"),
      content: Text("Are you sure you want to delete this transaction?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text("Delete"),
        ),
      ],
    );
  }
}
