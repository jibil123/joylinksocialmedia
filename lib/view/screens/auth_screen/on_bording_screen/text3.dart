import 'package:flutter/material.dart';
import 'package:joylink/view/screens/auth_screen/create_account/create_login.dart';
import 'package:joylink/view/screens/auth_screen/on_bording_screen/re_use_screen.dart';

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
