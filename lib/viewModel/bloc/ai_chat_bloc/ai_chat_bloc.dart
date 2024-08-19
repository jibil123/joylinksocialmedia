import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/viewmodel/bloc/ai_chat_bloc/ai_chat_event.dart';
import 'package:joylink/viewmodel/bloc/ai_chat_bloc/ai_chat_state.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final Gemini gemini;
  final ChatUser currentUser;
  final ChatUser geminiUser;

  AiChatBloc({required this.gemini, required this.currentUser, required this.geminiUser}) : super(ChatLoaded([])) {
    on<SendMessageEvent>(_onSendMessage);
    on<SendMediaMessageEvent>(_onSendMediaMessage);
  }
Future<void> _onSendMessage(SendMessageEvent event, Emitter<AiChatState> emit) async {
  try {
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(ChatLoading());

      String question = event.chatMessage.text;
      List<ChatMessage> updatedMessages = [event.chatMessage, ...currentState.messages];

      ChatMessage botMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: '',
      );

      updatedMessages = [botMessage, ...updatedMessages];
      emit(ChatLoaded(updatedMessages));

      await for (var event in gemini.streamGenerateContent(question)) {
        String responsePart = event.content?.parts?.fold("", (previous, current) => "$previous${current.text}") ?? "";
        responsePart = responsePart.replaceAll(RegExp(r'\*'), '');
        botMessage = ChatMessage(
          user: geminiUser,
          createdAt: botMessage.createdAt,
          text: botMessage.text + responsePart,
        );
        updatedMessages = [botMessage, ...updatedMessages.skip(1).toList()];
        emit(ChatLoaded(List.from(updatedMessages)));
      }
    }
  } catch (e) {
    emit(ChatError(e.toString()));
  }
}

Future<void> _onSendMediaMessage(SendMediaMessageEvent event, Emitter<AiChatState> emit) async {
  try {
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(ChatLoading());

      // Add user's media message with description to the chat
      ChatMessage userMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        medias: [ChatMedia(url: event.imageFile.path, fileName: "", type: MediaType.image)],
        text: event.description, // Add description text here
      );
      
      List<ChatMessage> updatedMessages = [userMessage, ...currentState.messages];

      // Create an initial bot message
      ChatMessage botMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: '',
      );

      // Add the bot message to the list and emit
      updatedMessages = [botMessage, ...updatedMessages];
      emit(ChatLoaded(updatedMessages));

      // Process the image and description with Gemini
      Uint8List imageBytes = await event.imageFile.readAsBytes();
      List<Uint8List> images = [imageBytes];
      String question = event.description; // Send the description as part of the question

      await for (var event in gemini.streamGenerateContent(question, images: images)) {
        String responsePart = event.content?.parts?.fold("", (previous, current) => "$previous${current.text}") ?? "";
        
        // Remove unwanted characters such as stars (*)
        responsePart = responsePart.replaceAll(RegExp(r'\*'), '');

        // Update bot's message with the generated response
        botMessage = ChatMessage(
          user: geminiUser,
          createdAt: botMessage.createdAt,
          text: botMessage.text + responsePart,
        );

        // Update the list with the new bot message
        updatedMessages = [botMessage, ...updatedMessages.skip(1).toList()];
        emit(ChatLoaded(List.from(updatedMessages)));
      }
    }
  } catch (e) {
    emit(ChatError(e.toString()));
  }
}


}
