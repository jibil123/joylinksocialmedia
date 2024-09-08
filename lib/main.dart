import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:joylink/core/constants/apis/gemini_api.dart';
import 'package:joylink/core/services/firebase_setup/firebase_options.dart';
import 'package:joylink/data/repositories/poll_respository/poll_repository.dart';
import 'package:joylink/viewmodel/bloc/Post_fetch_bloc/post_bloc.dart';
import 'package:joylink/viewmodel/bloc/chat_bloc/chat_bloc.dart';
import 'package:joylink/viewmodel/bloc/follow_unfollow_bloc/follow_bloc.dart';
import 'package:joylink/viewmodel/bloc/poll_bloc/poll_bloc.dart';
import 'package:joylink/viewmodel/bloc/theme_bloc/theme_bloc.dart';
import 'package:joylink/viewmodel/bloc/add_post_bloc/post_bloc.dart';
import 'package:joylink/viewmodel/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:joylink/viewmodel/bloc/edit_details_bloc/edit_details_bloc.dart';
import 'package:joylink/viewmodel/bloc/forgot_password_bloc/forgott_password_bloc.dart';
import 'package:joylink/viewmodel/bloc/google_auth_bloc/google_auth_bloc.dart';
import 'package:joylink/viewmodel/bloc/auth_bloc/auth_bloc.dart';
import 'package:joylink/viewmodel/bloc/profile_photo_bloc/profile_photo_bloc.dart';
import 'package:joylink/viewmodel/bloc/save_post_bloc/save_post_bloc.dart';
import 'package:joylink/viewmodel/bloc/user_search_bloc/user_search_bloc.dart';
import 'package:joylink/view/screens/splash_screen/splash_screen.dart';
import 'package:joylink/data/repositories/fetch_userdata_repo/fetch_post_data.dart';
import 'package:joylink/data/repositories/follow_unfollow/follow_unfollow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: geminiApiKey);
  runApp(
    RepositoryProvider(
      create: (context) => Repository(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        BlocProvider(
          create: (context) => BottomNavigationBloc(),
        ),
        BlocProvider(
          create: (context) => ForgottPasswordBloc(),
        ),
        BlocProvider(
          create: (context) => ProfilePhotoBloc(),
        ),
        BlocProvider(
          create: (context) => EditDetailsBloc(),
        ),
        BlocProvider(
          create: (context) => PostBloc(),
        ),
        BlocProvider(
          create: (context) => PostFetchBloc(
            repository: RepositoryProvider.of<Repository>(context),
          )..add(FetchPostsEvent()),
        ),
        BlocProvider(
          create: (context) => SavePostBloc()..add(FetchPostSavedEvent(currentUserId: FirebaseAuth.instance.currentUser!.uid)),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => SearchQueryBloc(),
        ),

        BlocProvider(
          create: (context) => ChatBloc(),
        ),
        BlocProvider(
          create: (context) => FollowBloc(UserService()),
        ),
        BlocProvider(
          create: (context) =>  PollBloc(PollRepository()),    
        )
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            home: const SplashScreenWrapper(),
            theme: state.isSwitched?ThemeData.light():ThemeData.dark()
          );
        },
      ),
    );
  }
}
