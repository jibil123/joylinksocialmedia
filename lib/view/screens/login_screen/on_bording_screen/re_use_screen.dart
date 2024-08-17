import 'package:flutter/material.dart';
import 'package:joylink/core/utils/colors/colors.dart';
import 'package:joylink/view/screens/login_screen/create_account/create_login.dart';
import 'package:joylink/view/screens/utils/custom_elevated_button.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  final String animationPath;
  final String titleText;
  final String buttonText;
  final Widget nextScreen;
  final bool? skip;
  const OnboardingScreen({
    super.key,
    required this.animationPath,
    required this.titleText,
    required this.buttonText,
    required this.nextScreen,
    this.skip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions:skip==true?  [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CustomElevatedButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateLoginScreen())),
                    icon: Icons.skip_next,
                    label: 'skip',
                  ),
                ),
              ]:null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Center(
                  child: Lottie.asset(animationPath, fit: BoxFit.fill),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                titleText,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => nextScreen)),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
