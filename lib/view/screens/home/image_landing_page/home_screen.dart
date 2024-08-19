import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/view/screens/ai_screen/main_screen/ai_screen.dart';
import 'package:joylink/view/screens/home/image_landing_page/widgets/layout_builder.dart';
import 'package:joylink/viewmodel/bloc/Post_fetch_bloc/post_bloc.dart';
import 'package:joylink/viewmodel/bloc/save_post_bloc/save_post_bloc.dart';
import 'package:joylink/core/theme/colors/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    final postSavebloc = BlocProvider.of<SavePostBloc>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          label: const Column(
            children: [
              Text(
                'Joylink',
                style: TextStyle(fontSize: 10),
              ),
              Text('AI',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          // icon: Icon(Icons.lightbulb,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: const BorderSide(
              color: Colors.white, 
              width: 2, 
            ),
          ),
          elevation: 8.0,
          backgroundColor: AppColors.tealColor,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const JoylinkAi()));
          }),
      body: BlocListener<SavePostBloc, SavePostState>(
        listener: (context, state) {
          if (state is SaveSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Post saved successfully!'),
              backgroundColor: AppColors.primaryColor,
            ));
            postSavebloc.add(FetchPostSavedEvent(
                currentUserId: FirebaseAuth.instance.currentUser!.uid));
          } else if (state is SaveFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Failed to save post'),
              backgroundColor: AppColors.redColor,
            ));
          } else if (state is PostAlreadySavedState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Already saved'),
              backgroundColor: AppColors.orangeColor,
            ));
          }
        },
        child: BlocConsumer<PostFetchBloc, PostFetchState>(
          listener: (context, state) {
            if (state is PostError) {
              const Text('Error');
            }
          },
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostLoaded) {
              final users = state.users;
              final sortedPosts = state.sortedPosts;
              if (sortedPosts.isEmpty) {
                return const Center(
                    child: Text(
                  'Share your happiness',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ));
              }
              return LayoutBuilderWidget(sortedPosts: sortedPosts, users: users);
            } else if (state is PostError) {
              return Center(child: Text(state.error));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

