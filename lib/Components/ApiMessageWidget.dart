import 'package:flutter/material.dart';

void showBottomMessage(BuildContext context, String message, bool isError) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          isError ? Icons.error : Icons.check_circle,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(message)),
      ],
    ),
    backgroundColor: isError ? Colors.red : Colors.green,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
