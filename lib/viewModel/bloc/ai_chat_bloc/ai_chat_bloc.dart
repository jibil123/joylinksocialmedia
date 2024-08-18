// ai_chat_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:joylink/viewmodel/bloc/ai_chat_bloc/ai_chat_event.dart';
import 'package:joylink/viewmodel/bloc/ai_chat_bloc/ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final Gemini gemini;
  final ChatUser currentUser;
  final ChatUser geminiUser;

  AiChatBloc({required this.gemini, required this.currentUser, required this.geminiUser}) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<SendMediaMessageEvent>(_onSendMediaMessage);
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<AiChatState> emit) async {
    try {
      emit(ChatLoading());
      String question = event.chatMessage.text;
      List<ChatMessage> updatedMessages = [event.chatMessage];
      emit(ChatLoaded(updatedMessages));
      
      gemini.streamGenerateContent(question).listen((event) {
        String response = event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
        ChatMessage message = ChatMessage(user: geminiUser, createdAt: DateTime.now(), text: response);
        updatedMessages = [message, ...updatedMessages];
        emit(ChatLoaded(updatedMessages));
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMediaMessage(SendMediaMessageEvent event, Emitter<AiChatState> emit) async {
    try {
      emit(ChatLoading());
      List<ChatMessage> updatedMessages = [
        ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          medias: [ChatMedia(url: event.imageFile.path, fileName: "", type: MediaType.image)],
        )
      ];
      emit(ChatLoaded(updatedMessages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
