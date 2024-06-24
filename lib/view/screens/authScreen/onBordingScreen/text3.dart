import 'package:flutter/material.dart';
import 'package:joylink/view/screens/authScreen/create%20account/create_login.dart';
import 'package:joylink/view/screens/authScreen/onBordingScreen/re_use_screen.dart';

class TextThreeScreen extends StatelessWidget {
  const TextThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen(
        animationPath: 'assets/animations/animation_3.json',
        titleText:
            'Join us in spreading\nhappiness connecting\nwith friends, and sharing\njoyful moments!',
        buttonText: 'Start',
        nextScreen: CreateLoginWarapper());
  }
}
