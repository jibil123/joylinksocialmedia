import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onOkPressed;
  final String childName;
  
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onOkPressed,
    required this.childName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onOkPressed();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              childName,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
