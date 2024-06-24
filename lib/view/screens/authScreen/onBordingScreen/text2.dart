import 'package:flutter/material.dart';
import 'package:joylink/view/screens/authScreen/onBordingScreen/re_use_screen.dart';
import 'package:joylink/view/screens/authScreen/onBordingScreen/text3.dart';

class TextTwoScreen extends StatelessWidget {
  const TextTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen(
        animationPath:'assets/animations/Animation - 1715751904943.json',
        titleText:'Get ready to smile, laugh,\nand connect like never\nbefore on Joy Link!',
        buttonText: 'Next',
        skip: true,
        nextScreen: TextThreeScreen());
  }
}
