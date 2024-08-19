import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:joylink/view/screens/ai_screen/controller/ai_chat_functions.dart';
import 'package:joylink/view/screens/ai_screen/widgets/ai_body_screen.dart';
import 'package:joylink/viewmodel/bloc/ai_chat_bloc/ai_chat_bloc.dart';

class JoylinkAi extends StatefulWidget {
  const JoylinkAi({super.key});

  @override
  State<JoylinkAi> createState() => _JoylinkAiState();
}

class _JoylinkAiState extends State<JoylinkAi> {
  late AiChatViewModel aiChatViewModel;

  @override
  void initState() {
    super.initState();
    Gemini gemini = Gemini.instance;
    ChatUser currentUser = ChatUser(id: '0', firstName: 'user');
    ChatUser geminiUser = ChatUser(
        id: '1',
        firstName: 'Joylink AI', 
        profileImage:
            "https://www.europarl.europa.eu/resources/library/images/20230607PHT95601/20230607PHT95601_original.jpg");

    AiChatBloc aiChatBloc = AiChatBloc(
        gemini: gemini, currentUser: currentUser, geminiUser: geminiUser);
    aiChatViewModel = AiChatViewModel(aiChatBloc: aiChatBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => aiChatViewModel.aiChatBloc,
      child: Scaffold(
        backgroundColor: Colors.teal[50],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
            child: AppBar(
              title: const Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Joylink AI',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 4),
                  Text(
                    'Your Personal AI Companion',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              backgroundColor: Colors.teal[300],
            ),
          ),
        ),
        body: AiChatBody(viewModel: aiChatViewModel),
      ),
    );
  }
}
