import 'package:flutter/material.dart';

class CustomSnackBar{
 static void showCustomSnackbar(BuildContext context, String title, Color backgroundColor) {
  final snackBar = SnackBar(
    content: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.all(16),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
}
