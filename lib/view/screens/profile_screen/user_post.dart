import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/viewmodel/bloc/Post_fetch_bloc/post_bloc.dart';
import 'package:joylink/core/utils/media_quary.dart';
import 'package:joylink/view/screens/home/like_and_comment.dart';
import 'package:joylink/view/screens/post_screen/upload_screen.dart';
import 'package:joylink/viewmodel/controller/date_and_time/date_and_time.dart';

class UserPosts extends StatelessWidget {
  UserPosts(
      {super.key, required this.deleteOrSave, required this.currentUserId});
  final bool deleteOrSave;
  final String currentUserId;
  final DateAndTime dateAndTime = DateAndTime();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostFetchBloc, PostFetchState>(
      listener: (context, state) {
        if (state is PostError) {
          const Text('error');
        }
      },
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostLoaded) {
          final users = state.users;
          final posts = state.sortedPosts;
          final currentUserPosts =
              posts.where((post) => post.userId == currentUserId).toList();

          if (users.isEmpty || currentUserPosts.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                children: [
                  const Center(
                      child: Text(
                    'share your happiness!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UploadScreen()));
                      },
                      icon: const Icon(Icons.add_a_photo))
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: currentUserPosts.length,
            itemBuilder: (context, index) {
              final post = currentUserPosts[index];
              final user =
                  users.firstWhere((user) => user.userId == post.userId);
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  color: Colors.teal[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: user.profilePic.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                              )
                            : ClipOval(
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/joylink-logo.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                        title: Text(
                          user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle:post.location.isNotEmpty?
                         Text(post.location):const Text('Null'),
                        trailing: deleteOrSave
                            ? PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    context.read<PostFetchBloc>().add(
                                        DeletePostEvent(postId: post.postId));
                                  }
                                },
                              )
                            : null,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(15)),
                        ),
                        width: double.infinity,
                        height: mediaqueryHeight(0.2, context),
                        child: Image.network(
                          
                          fit: BoxFit.cover,
                          post.image,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            double? progress =
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null;
                            return Center(
                              child: CircularProgressIndicator(
                                value: progress,
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LikeAndCommentButtons(postId: post.postId),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 5, right: 10),
                            child: Text(
                                "Posted on : ${dateAndTime.formatRelativeTime(post.dateAndTime)}"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child:post.description.isNotEmpty?
                           Text(post.description):const Text('Null'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is PostError) {
          return Center(child: Text(state.error));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
