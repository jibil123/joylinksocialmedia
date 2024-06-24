import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joylink/model/bloc/chatBloc/chat_bloc.dart';
import 'package:joylink/view/screens/chatScreen/widgets/build_message_list.dart';
import 'package:joylink/view/screens/chatScreen/widgets/emoji_widget.dart';
import 'package:joylink/view/screens/chatScreen/widgets/share_image_video.dart';
import 'package:joylink/viewModel/firebase/chatFetch/fetch_chat.dart';

class ChatScreen extends StatelessWidget {
  final String reciverId;
  ChatScreen({super.key, required this.reciverId});

  final FetchChat fetchChat = FetchChat();
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final chatBloc = BlocProvider.of<ChatBloc>(context);
          bool emojiShowing = state is EmojiToggled && state.isEmojiVisible;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Message Screen'),
              backgroundColor: Colors.blueAccent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: MessageListWidget(
                    reciverId: reciverId,
                    scrollController: scrollController,
                    messageController: messageController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    key: formKey,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Enter message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: IconButton(
                              onPressed: () {
                                chatBloc.add(ToggleEmoji());
                              },
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ShareImageAndPhoto(picker: picker, chatBloc: chatBloc, reciverId: reciverId),
                      IconButton(
                        onPressed: () {
                          chatBloc.add(SendMessage(
                            reciverId: reciverId,
                            message: messageController.text,
                          ));
                          messageController.clear();
                        },
                        icon: const Icon(
                          Icons.send,
                          size: 30,
                          color: Color.fromARGB(255, 29, 88, 50),
                        ),
                      ),
                    ],
                  ),
                ),
                EmojiWidget(
                    emojiShowing: emojiShowing,
                    messageController: messageController),
              ],
            ),
          );
        },
      ),
    );
  }
}

