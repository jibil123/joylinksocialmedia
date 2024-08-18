import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joylink/core/utils/mediaquery/media_query.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class JoylinkAi extends StatefulWidget {
  const JoylinkAi({super.key});

  @override
  State<JoylinkAi> createState() => _JoylinkAiState();
}

class _JoylinkAiState extends State<JoylinkAi> {
  Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: '0', firstName: 'user');
  ChatUser geminiUser = ChatUser(
      id: '1',
      firstName: 'geminiUser',
      profileImage:
          "https://www.europarl.europa.eu/resources/library/images/20230607PHT95601/20230607PHT95601_original.jpg");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
          child: AppBar(
            title: Row(
              children: [
                SizedBox(
                  width: mediaqueryHeight(0.01, context),
                ),
                const Text(
                  'Joylink AI',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            backgroundColor: Colors.teal[300],
          ),
        ),
      ),
      body: buildUi(),
    );
  }

  Widget buildUi() {
    return DashChat(
        inputOptions: InputOptions(trailing: [
          IconButton(
              onPressed:
                _sendMediaMessage,
              icon: const Icon(Icons.image))
        ]),
        currentUser: currentUser,
        onSend: sendMessage,
        messages: messages);
  }

  sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>?images;
      if(chatMessage.medias?.isNotEmpty??false){
          images=[File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      gemini.streamGenerateContent(question,images: images).listen((event) {
        ChatMessage? lastmessage = messages.firstOrNull;
        if (lastmessage != null && lastmessage.user == geminiUser) {
          lastmessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastmessage.text += response;
          setState(() {
            messages = [lastmessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    ChatMessage chatMessage = ChatMessage(user: currentUser, createdAt: DateTime.now(),medias: [
      ChatMedia(url: imageFile!.path, fileName: "", type: MediaType.image)
    ]);
    sendMessage(chatMessage);
  }
}
