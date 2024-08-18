// ai_chat_state.dart
import 'package:equatable/equatable.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

abstract class AiChatState extends Equatable {
  const AiChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends AiChatState {}

class ChatLoading extends AiChatState {}

class ChatLoaded extends AiChatState {
  final List<ChatMessage> messages;

  const ChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends AiChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}
