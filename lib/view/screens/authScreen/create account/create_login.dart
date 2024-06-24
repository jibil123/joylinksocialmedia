import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/auth_bloc/auth_bloc.dart';
import 'package:joylink/model/model/userdetails.dart';
import 'package:joylink/view/screens/authScreen/create%20account/email_varification.dart';
import 'package:joylink/view/screens/authScreen/utils/custom_button.dart';
import 'package:joylink/view/screens/authScreen/utils/customtextformfield.dart';

class CreateLoginWarapper extends StatelessWidget {
  const CreateLoginWarapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: CreateLoginScreen(),
    );
  }
}

class CreateLoginScreen extends StatelessWidget {
  CreateLoginScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedErrors) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Enter correct email and password',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.red,  
          )
          );
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
                (route) => false);
          });
        }
        return Scaffold(
          appBar: AppBar(
            title:const Text('Create account'),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                      hintText: 'Enter your name',
                      obscureText: false,
                      controller: name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                      hintText: 'Enter email address',
                      obscureText: false,
                      controller: email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  CustomTextField(
                      hintText: 'Create password',
                      obscureText: false,
                      controller: password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  CustomButton(
                      buttonText: 'Save',
                      onPressed: () {
                        UserDetails user = UserDetails(
                            name: name.text.trim(),
                            email: email.text.trim(),
                            password: password.text);
                        if (_formkey.currentState!.validate()) {
                          authBloc.add(SignupEvent(user: user));
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
