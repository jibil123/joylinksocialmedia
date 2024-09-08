import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayScreen extends StatefulWidget {
  const RazorPayScreen({super.key, required this.amount});
  final int? amount;
  @override
  State<RazorPayScreen> createState() => _RazorPayScreenState();
}

class _RazorPayScreenState extends State<RazorPayScreen> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appbar'),
      ),
      body: TextButton(
          onPressed: () {
            
          },
          child: Text('submit')),
    );
  }
}

const apiKey = 'rzp_test_DpaDFvGOLUbJTY';
const scretKey = 'tCNMX8r3TR7nUnhLLZa23dHX';
