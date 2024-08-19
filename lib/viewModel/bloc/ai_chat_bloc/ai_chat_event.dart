// ai_chat_event.dart
import 'package:equatable/equatable.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';

abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends AiChatEvent {
  final ChatMessage chatMessage;

  const SendMessageEvent(this.chatMessage);

  @override
  List<Object> get props => [chatMessage];
}

class SendMediaMessageEvent extends AiChatEvent {
  final XFile imageFile;
  final String description;

  const SendMediaMessageEvent(this.imageFile, this.description);

  @override
  List<Object> get props => [imageFile,description];
}
