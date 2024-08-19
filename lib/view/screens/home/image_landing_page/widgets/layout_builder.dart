import 'package:flutter/widgets.dart';
import 'package:joylink/core/models/fetch_model.dart';
import 'package:joylink/core/models/saved_post_model.dart';
import 'package:joylink/view/screens/home/image_landing_page/widgets/post_details.dart';

class LayoutBuilderWidget extends StatelessWidget {
  const LayoutBuilderWidget({
    super.key,
    required this.sortedPosts,
    required this.users,
  });

  final List<UserPost> sortedPosts;
  final List<Users> users;

  @override
  Widget build(BuildContext context) {
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
              final user = users
                  .firstWhere((user) => user.userId == post.userId);
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
  }
}
