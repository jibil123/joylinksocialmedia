import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:joylink/view/screens/ai_screen/controller/ai_chat_functions.dart';
import 'package:joylink/view/screens/ai_screen/widgets/empty_text.dart';
import 'package:joylink/viewmodel/bloc/ai_chat_bloc/ai_chat_bloc.dart';
import 'package:joylink/viewmodel/bloc/ai_chat_bloc/ai_chat_event.dart';
import 'package:joylink/viewmodel/bloc/ai_chat_bloc/ai_chat_state.dart';

class AiChatBody extends StatelessWidget {
  final AiChatViewModel viewModel;

  const AiChatBody({required this.viewModel, super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiChatBloc, AiChatState>(
      bloc: viewModel.aiChatBloc,
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatLoaded) {
          return Stack(
            children: [
              DashChat(
                inputOptions: InputOptions(trailing: [
                  IconButton(
                    onPressed: () => viewModel.sendMediaMessage(context),
                    icon: const Icon(Icons.image),
                  ),
                ]),
                currentUser: viewModel.aiChatBloc.currentUser,
                onSend: (chatMessage) =>
                    viewModel.aiChatBloc.add(SendMessageEvent(chatMessage)),
                messages: state.messages,
              ),
              if (state.messages.isEmpty)
                buildEmptyState(context),
            ],
          );
        } else if (state is ChatError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Start Chatting!'));
        }
      },
    );
  }
}
