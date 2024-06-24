part of 'chat_bubble_bloc.dart';

abstract class ChatBubbleEvent extends Equatable {
  const ChatBubbleEvent();  

  @override
  List<Object> get props => [];
}

class ToggleExpansionEvent extends ChatBubbleEvent {}