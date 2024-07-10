import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/googleAuthBloc/google_auth_bloc.dart';
import 'package:joylink/model/bloc/auth_bloc/auth_bloc.dart';
import 'package:joylink/view/screens/authScreen/mainLoginScreen/login_screen.dart';
import 'package:joylink/view/screens/bottomNavigation/bottom_navigation.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(CheckLoginStatusEvent()),
        ),
        BlocProvider(
          create: (context) => GoogleAuthBloc()..add(CheckGoogleStatusEvent()),
        ),
      ],
      child: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const BottomNavigationScreen()));
            } else if (state is UnAuthenticated) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginScreenWrapper()));
            }
          },
        ),
        BlocListener<GoogleAuthBloc, GoogleAuthState>(
          listener: (context, state) {
            if (state is GoogleAuthSuccess) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const BottomNavigationScreen()));
            } else if (state is GoogleAuthError) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginScreenWrapper()));
            }
          },
        ),
      ],
      child: const Scaffold(
        body: Center(
          child: Image(
              width: 300,
              height: 300,
              image: AssetImage("assets/images/joylink-logo.png")),
        ),
      ),
    );
  }
}
