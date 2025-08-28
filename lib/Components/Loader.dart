import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoaderDialog(BuildContext context, {String message = "Please wait..."}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.blue),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
void hideLoaderDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
