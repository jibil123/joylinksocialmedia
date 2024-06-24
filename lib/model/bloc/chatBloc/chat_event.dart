part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class SendMessage extends ChatEvent{
  final String reciverId;
  final String message;

  SendMessage({required this.reciverId, required this.message});
}

class SendMediaMessage extends ChatEvent {
  final String reciverId;
  final File file;
  final String mediaType; // 'image' or 'video'

  SendMediaMessage({required this.reciverId, required this.file, required this.mediaType});
}