import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_bubble_event.dart';
part 'chat_bubble_state.dart';

class ChatBubbleBloc extends Bloc<ChatBubbleEvent, ChatBubbleState> {
  ChatBubbleBloc() : super(ChatBubbleInitial()) {
    on<ToggleExpansionEvent>((event, emit) {
      if(state is ChatBubbleCollapsed){
        emit(ChatBubbleExpanded());
      }else{
        emit(ChatBubbleCollapsed());
      }
    });
  }
}
