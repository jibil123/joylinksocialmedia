import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onOkPressed;
  final String childName;
  const CustomAlertDialog({super.key, required this.title, required this.message, required this.onOkPressed, required this.childName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
      content: Text(message,style: const TextStyle(fontSize: 18),),
      actions: <Widget>[
        TextButton(
          child: Text(childName,style: const TextStyle(fontSize: 17)),
          onPressed: () {
            Navigator.of(context).pop(); 
            onOkPressed(); 
          },
        ),
      ],
    );
  }
}
