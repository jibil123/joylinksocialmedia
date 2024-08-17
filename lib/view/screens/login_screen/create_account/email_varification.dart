import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/viewmodel/bloc/email_verification/email_verification_bloc.dart';
import 'package:joylink/viewmodel/bloc/email_verification/email_verification_event.dart';
import 'package:joylink/viewmodel/bloc/email_verification/email_verification_state.dart';
import 'package:joylink/view/screens/bottom_navigation/bottom_navigation.dart';


class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmailVerificationBloc()..add(StartEmailVerification()),
      child: const EmailVerificationView(),
    );
  }
}

class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email Verification'),
        ),
        body: BlocListener<EmailVerificationBloc, EmailVerificationState>(
          listener: (context, state) {
            if (state is EmailVerificationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Email Successfully Verified"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => const BottomNavigationScreen()),
                (route) => false,
              );
            } else if (state is EmailVerificationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 35),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Check your \n Email',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text(
                      'We have sent you an Email ',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text(
                      'Verifying email....',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 57),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ElevatedButton(
                    child: const Text('Resend'),
                    onPressed: () {
                      context.read<EmailVerificationBloc>().add(ResendEmailVerification());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
