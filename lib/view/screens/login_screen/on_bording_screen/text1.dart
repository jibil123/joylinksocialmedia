import 'package:flutter/material.dart';
import 'package:joylink/view/screens/login_screen/on_bording_screen/re_use_screen.dart';
import 'package:joylink/view/screens/login_screen/on_bording_screen/text2.dart';

class TextOneScreen extends StatelessWidget {
  const TextOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen(
        animationPath: 'assets/animations/animation_1.json',
        titleText: 'Welcome to Joy Link.\nLets Connect',
        buttonText: 'Next',
        skip: true,
        nextScreen: TextTwoScreen());
  }
}
