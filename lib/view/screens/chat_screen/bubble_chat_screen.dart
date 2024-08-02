import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/chatBubble/chat_bubble_bloc.dart';
import 'package:joylink/utils/colors.dart';

class ChatBubbleScreen extends StatelessWidget {
  final String message;
  final String time;
  final bool isSentByMe;
  final String? mediaUrl;
  final String? mediaType;
  final VoidCallback? onTap;

  const ChatBubbleScreen({
    super.key,
    required this.message,
    required this.time,
    required this.isSentByMe,
    this.mediaUrl,
    this.mediaType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBubbleBloc(),
      child: BlocBuilder<ChatBubbleBloc, ChatBubbleState>(
        builder: (context, state) {
          final isLongMessage = message.length > 50;
          final isExpanded = state is ChatBubbleExpanded;
          final displayedMessage = isExpanded || !isLongMessage
              ? message
              : '${message.substring(0, 50)}...';

          return GestureDetector(
            onTap: () {
              if (isLongMessage) {
                context.read<ChatBubbleBloc>().add(ToggleExpansionEvent());
              }
              if (onTap != null) onTap!();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSentByMe ? AppColors.tealColor : Colors.teal[200],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isSentByMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (mediaType == 'image' && mediaUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            mediaUrl!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (mediaType == 'video' && mediaUrl != null)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 200,
                              child: Image.asset(
                                'assets/images/cover_photo.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Icon(
                              Icons.play_circle_fill,
                              color: AppColors.whiteColor,
                              size: 50,
                            ),
                          ],
                        ),
                      if (mediaType == null || mediaType == '')
                        Text(
                          displayedMessage,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSentByMe
                                ? AppColors.whiteColor
                                : Colors.black87,
                          ),
                        ),
                      const SizedBox(height: 5),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSentByMe ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
