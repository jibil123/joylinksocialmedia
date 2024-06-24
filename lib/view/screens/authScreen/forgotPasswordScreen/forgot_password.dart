import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/forgotPassword/forgott_password_bloc.dart';
import 'package:joylink/view/screens/authScreen/utils/custom_button.dart';
import 'package:joylink/view/screens/authScreen/utils/customtextformfield.dart';

class ForgottPassswordScreen extends StatelessWidget {
  ForgottPassswordScreen({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final forgottPasswordBloc = BlocProvider.of<ForgottPasswordBloc>(context);
    return BlocConsumer<ForgottPasswordBloc, ForgottPasswordState>(
      listener: (context, state) {
        if (state is ResetSuccssState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Check your mail successfully sended',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.green,
          ));
        }
        if (state is ResetErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'password reset failed',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.red,
          ));
        }
      },
      builder: (context, state) {
        if (state is ResetLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(title:const Text('Reset password')),
          body: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enter your email and we will send you a pssword reset link',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                      hintText: 'Enter your email',
                      obscureText: false,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter valid password';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      buttonText: 'Submit',
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          forgottPasswordBloc.add(
                              ResetPasswordEvent(email: emailController.text));
                        }
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
