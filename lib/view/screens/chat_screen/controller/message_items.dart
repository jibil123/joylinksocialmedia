import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joylink/view/screens/chat_screen/bubble_chat_screen.dart';
import 'package:joylink/view/screens/chat_screen/widgets/video_widget.dart';
import 'package:joylink/view/screens/home/image_preview.dart';

String getFormattedDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('MMM d, yyyy').format(dateTime);
}

Widget buildMessageItems(BuildContext context, DocumentSnapshot document, String? previousDate) {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  var isSentByMe = (data['senderId'] == firebaseAuth.currentUser!.uid);
  Timestamp timestamp = data['timeStamp'];
  String formattedTime = DateFormat('h:mm a').format(timestamp.toDate());
  String formattedDate = getFormattedDate(timestamp);

  bool showDate = formattedDate != previousDate;

  return Column(
    crossAxisAlignment:
        isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      if (showDate)
        Center(
          child: Text(
            formattedDate,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ChatBubbleScreen(
          message: data['message'],
          time: formattedTime,
          isSentByMe: isSentByMe,
          mediaUrl: data['mediaUrl'],
          mediaType: data['mediaType'],
          onTap: () {
            if (data['mediaType'] == 'video') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(url: data['mediaUrl']),
                ),
              );
            }
            else if(data['mediaType']=='image'){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ImagePreviewScreen(imageUrl: data['mediaUrl'], description: '')));
            }
          },
        ),
      ),
    ],
  );
}

