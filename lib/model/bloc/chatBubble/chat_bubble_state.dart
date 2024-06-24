part of 'chat_bubble_bloc.dart';

abstract class ChatBubbleState extends Equatable {
  const ChatBubbleState();

  @override
  List<Object> get props => [];
}

class ChatBubbleInitial extends ChatBubbleState {}

class ChatBubbleExpanded extends ChatBubbleState {}

class ChatBubbleCollapsed extends ChatBubbleState {}  