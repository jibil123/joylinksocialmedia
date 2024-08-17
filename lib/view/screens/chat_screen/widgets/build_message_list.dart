import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joylink/view/screens/chat_screen/controller/message_items.dart';
import 'package:joylink/data/datasources/chat_fetch_repo/fetch_chat.dart';
import 'package:intl/intl.dart';

class MessageListWidget extends StatelessWidget {
  final String reciverId;
  final ScrollController scrollController;
  final TextEditingController messageController;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FetchChat fetchChat = FetchChat();
  final ImagePicker picker = ImagePicker();

  MessageListWidget({super.key, 
    required this.reciverId,
    required this.scrollController,
    required this.messageController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fetchChat.getMessages(reciverId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        });

        String? previousDate;

        return ListView(
          controller: scrollController,
          children: snapshot.data!.docs.map((document) {
            Widget messageItem =
                buildMessageItems(context, document, previousDate);
            previousDate = getFormattedDate(document['timeStamp']);
            return messageItem;
          }).toList(),
        );
      },
    );
  }

  String getFormattedDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM d, yyyy').format(dateTime);
  }
}
