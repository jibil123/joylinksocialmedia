import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/viewmodel/bloc/google_auth_bloc/google_auth_bloc.dart';
import 'package:joylink/viewmodel/bloc/auth_bloc/auth_bloc.dart';
import 'package:joylink/core/utils/colors.dart';
import 'package:joylink/view/screens/login_screen/forgot_password_screen/forgot_password.dart';
import 'package:joylink/view/screens/login_screen/on_bording_screen/text1.dart';
import 'package:joylink/view/screens/utils/custom_button.dart';
import 'package:joylink/view/screens/utils/customtextformfield.dart';
import 'package:joylink/view/screens/login_screen/google_sign_in/googles_signin.dart';
import 'package:joylink/view/screens/bottom_navigation/bottom_navigation.dart';

class LoginScreenWrapper extends StatelessWidget {
  const LoginScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => GoogleAuthBloc(),
        ),
      ],
      child: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final  _formkey = GlobalKey<FormState>();
  final  emailController = TextEditingController();
  final  passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedErrors) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Enter correct email and password',
              style: TextStyle(color: AppColors.blackColor),
            ),
            backgroundColor: AppColors.redColor,
          ));
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => const BottomNavigationScreen()),
                (route) => false);
          });
        }
        return Scaffold(
          body: SafeArea(
            child: BlocListener<GoogleAuthBloc, GoogleAuthState>(
              listener: (context, state) {
                if (state is GoogleAuthSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const BottomNavigationScreen()),
                        (route) => false);
                  });
                }
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    // Web Layout
                    return Center(
                      child: SingleChildScrollView(
                        child: Container(
                          width: 600,
                          padding: const EdgeInsets.all(10),
                          child: _buildForm(context),
                        ),
                      ),
                    );
                  } else {
                    // Mobile Layout
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Center(
                          child: _buildForm(context),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    final authbloc = BlocProvider.of<AuthBloc>(context);
    return Form(
      key: _formkey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Center(
              child: Image(
                width: 200,
                height: 200,
                image: AssetImage("assets/images/joylink-logo.png"),
              ),
            ),
            const SizedBox(height: 50),
            CustomTextField(
              hintText: 'Enter email address',
              obscureText: false,
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter your email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Enter your password',
              obscureText: true,
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter valid password';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ForgottPassswordScreen(),
                ),
              ),
              child: const Text('Forgot password?'),
            ),
            const SizedBox(height: 20),
            CustomButton(
              buttonText: 'Log in',
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  authbloc.add(LoginEvent(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ));
                }
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              buttonText: 'Create a new account',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TextOneScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            const Center(child: Text('Or')),
            const SizedBox(height: 20),
            const GoogleSignin(),
          ],
        ),
      ),
    );
  }
}
