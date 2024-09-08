import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joylink/core/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:joylink/viewmodel/bloc/chat_bloc/chat_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ShareImageAndPhoto extends StatefulWidget {
  ShareImageAndPhoto({
    super.key,
    required this.picker,
    required this.chatBloc,
    required this.reciverId,
  });

  final ImagePicker picker;
  final ChatBloc chatBloc;
  final String reciverId;

  @override
  State<ShareImageAndPhoto> createState() => _ShareImageAndPhotoState();
}

class _ShareImageAndPhotoState extends State<ShareImageAndPhoto> {
  final amount = TextEditingController();
  Razorpay? razorpay;
  paymentSuccess(PaymentSuccessResponse response) {
    CustomSnackBar.showCustomSnackbar(
        context, 'Payment successfully done', Colors.green);
  }

  paymentFailer(PaymentFailureResponse response) {
    CustomSnackBar.showCustomSnackbar(
        context, 'Payment failed: ${response.message}', Colors.red);
  }

  paymentWallet(ExternalWalletResponse response) {
    CustomSnackBar.showCustomSnackbar(context,
        'External wallet selected: ${response.walletName}', Colors.red);
  }

  openCheckout(int? value) async {
    var options = {
      'key': 'rzp_test_DpaDFvGOLUbJTY',
      'amount': value,
      'name': 'Joylink Payment',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '7558941120', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorpay?.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, paymentFailer);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, paymentWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(
        Icons.add,
        size: 30,
        color: Colors.grey,
      ),
      onSelected: (int value) async {
        if (value == 0) {
          final XFile? image =
              await widget.picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            widget.chatBloc.add(SendMediaMessage(
                reciverId: widget.reciverId,
                file: File(image.path),
                mediaType: 'image'));
          }
        } else if (value == 1) {
          final XFile? video =
              await widget.picker.pickVideo(source: ImageSource.gallery);
          if (video != null) {
            widget.chatBloc.add(SendMediaMessage(
                reciverId: widget.reciverId,
                file: File(video.path),
                mediaType: 'video'));
          }
        } else if (value == 2) {
          showDialog(
              context: (context),
              builder: (builder) {
                return AlertDialog(
                  title: const Text('Enter the Amount'),
                  content: TextField(
                    keyboardType: TextInputType.number,
                    controller: amount,
                    decoration: InputDecoration(hintText: 'Paymant Amount'),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          int? value = int.tryParse(amount.text);
                          if (value != null) {
                            openCheckout(value * 100);
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Pay'))
                  ],
                );
              });
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.image, color: Colors.grey),
              SizedBox(width: 10),
              Text("Image"),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.video_library, color: Colors.grey),
              SizedBox(width: 10),
              Text("Video"),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.payment, color: Colors.grey),
              SizedBox(width: 10),
              Text("Payment"),
            ],
          ),
        ),
      ],
    );
  }
}
