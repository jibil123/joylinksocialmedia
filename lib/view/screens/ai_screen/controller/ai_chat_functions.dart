import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joylink/viewmodel/bloc/ai_chat_bloc/ai_chat_bloc.dart';
import 'package:joylink/viewmodel/bloc/ai_chat_bloc/ai_chat_event.dart';

class AiChatViewModel {
  final AiChatBloc aiChatBloc;

  AiChatViewModel({required this.aiChatBloc});

  Future<void> sendMediaMessage(BuildContext context) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    // ignore: use_build_context_synchronously
    String? description = await _showDescriptionInputDialog(context);
    
    if (imageFile != null && description != null) {
      aiChatBloc.add(SendMediaMessageEvent(imageFile, description));
    }
  }

  Future<String?> _showDescriptionInputDialog(BuildContext context) async {
    String? description;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Description'),
          content: TextField(
            onChanged: (value) {
              description = value;
            },
            decoration: const InputDecoration(hintText: "Description"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                Navigator.of(context).pop(description);
              },
            ),
          ],
        );
      },
    );
    return description;
  }
}
