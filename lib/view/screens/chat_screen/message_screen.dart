import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joylink/viewmodel/bloc/chat_bloc/chat_bloc.dart';
import 'package:joylink/core/utils/media_quary.dart';
import 'package:joylink/view/screens/chat_screen/widgets/build_message_list.dart';
import 'package:joylink/view/screens/chat_screen/widgets/emoji_widget.dart';
import 'package:joylink/view/screens/chat_screen/widgets/share_image_video.dart';
import 'package:joylink/viewmodel/firebase/chat_fetch_repo/fetch_chat.dart';

class ChatScreen extends StatelessWidget {
  final String receiverId;
  final String profileImage;
  final String chatUserName;
  ChatScreen(
      {super.key,
      required this.receiverId,
      required this.profileImage,
      required this.chatUserName});

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
            backgroundColor: Colors.teal[50],
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                child: AppBar(
                  centerTitle: true,
          
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 22, // Adjust the radius as needed
                        backgroundImage: NetworkImage(profileImage),
                        onBackgroundImageError: (_, __) => const Icon(Icons.person),
                      ),
                      SizedBox(width: mediaqueryHeight(0.01, context)),
                      Expanded(
                        child: Text(
                          chatUserName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.teal[300],
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: MessageListWidget(
                    reciverId: receiverId,
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
                      ShareImageAndPhoto(
                          picker: picker,
                          chatBloc: chatBloc,
                          reciverId: receiverId),
                      IconButton(
                        onPressed: () {
                          chatBloc.add(SendMessage(
                            reciverId: receiverId,
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
