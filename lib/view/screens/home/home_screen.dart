import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/viewmodel/bloc/Post_fetch_bloc/post_bloc.dart';
import 'package:joylink/viewmodel/bloc/save_post_bloc/save_post_bloc.dart';
import 'package:joylink/core/models/saved_post_model.dart';
import 'package:joylink/core/theme/colors/colors.dart';
import 'package:joylink/view/screens/home/post_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    final postSavebloc = BlocProvider.of<SavePostBloc>(context);
    return BlocListener<SavePostBloc, SavePostState>(
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
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // Web Layout
                  return Center(
                    child: SizedBox(
                      width: 600,
                      child: ListView.builder(
                        itemCount: sortedPosts.length,
                        itemBuilder: (context, index) {
                          final post = sortedPosts[index];
                          final user = users.firstWhere(
                              (user) => user.userId == post.userId);
                          SavedPostModel savedPostModel = SavedPostModel(
                              likesCount: post.likesCount,
                              commentsCount: post.commentsCount,
                              followers: user.followers,
                              following: user.following,
                              mail: user.mail,
                              bio: user.bio,
                              coverImage: user.coverImage,
                              uid: user.userId,
                              name: user.name,
                              profileImage: user.profilePic,
                              location: post.location,
                              postImage: post.image,
                              date: post.dateAndTime,
                              description: post.description,
                              postId: post.postId);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: UsersPostCard(
                              savedPostModel: savedPostModel,
                              isSaveOrNot: true,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  // Mobile Layout
                  return ListView.builder(
                    itemCount: sortedPosts.length,
                    itemBuilder: (context, index) {
                      final post = sortedPosts[index];
                      final user = users.firstWhere(
                          (user) => user.userId == post.userId);
                      SavedPostModel savedPostModel = SavedPostModel(
                          likesCount: post.likesCount,
                          commentsCount: post.commentsCount,
                          followers: user.followers,
                          following: user.following,
                          mail: user.mail,
                          bio: user.bio,
                          coverImage: user.coverImage,
                          uid: user.userId,
                          name: user.name,
                          profileImage: user.profilePic,
                          location: post.location,
                          postImage: post.image,
                          date: post.dateAndTime,
                          description: post.description,
                          postId: post.postId);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: UsersPostCard(
                          savedPostModel: savedPostModel,
                          isSaveOrNot: true,
                        ),
                      );
                    },
                  );
                }
              },
            );
          } else if (state is PostError) {
            return Center(child: Text(state.error));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
