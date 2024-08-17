part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class EmojiToggled extends ChatState {
  final bool isEmojiVisible;

  EmojiToggled(this.isEmojiVisible);
}

class ToggleEmoji extends ChatEvent {}