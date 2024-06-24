import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joylink/model/bloc/chatBloc/chat_bloc.dart';

class ShareImageAndPhoto extends StatelessWidget {
  const ShareImageAndPhoto({
    super.key,
    required this.picker,
    required this.chatBloc,
    required this.reciverId,
  });

  final ImagePicker picker;
  final ChatBloc chatBloc;
  final String reciverId;

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
              await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            chatBloc.add(SendMediaMessage(
                reciverId: reciverId,
                file: File(image.path),
                mediaType: 'image'));
          }
        } else if (value == 1) {
          final XFile? video =
              await picker.pickVideo(source: ImageSource.gallery);
          if (video != null) {
            chatBloc.add(SendMediaMessage(
                reciverId: reciverId,
                file: File(video.path),
                mediaType: 'video'));
          }
        }
      },
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<int>>[
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
      ],
    );
  }
}
