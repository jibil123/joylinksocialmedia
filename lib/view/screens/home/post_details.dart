import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joylink/model/model/saved_post_model.dart';
import 'package:joylink/model/model/search_model.dart';
import 'package:joylink/view/screens/home/like_and_comment.dart';
import 'package:joylink/view/screens/home/popup_menu_button.dart';
import 'package:joylink/view/screens/home/widgets/post_image_widget.dart';
import 'package:joylink/view/screens/otherProfileScreen/other_profile_screen.dart';
import 'package:joylink/viewModel/date_and_time/date_and_time.dart';

class UsersPostCard extends StatelessWidget {
  UsersPostCard(
      {super.key, required this.savedPostModel, required this.isSaveOrNot});

  final FirebaseAuth auth = FirebaseAuth.instance;
  final DateAndTime dateAndTime = DateAndTime();
  final SavedPostModel savedPostModel;
  final bool isSaveOrNot;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () {
              UserModel userModel = UserModel(
                followers: savedPostModel.followers,
                following: savedPostModel.following,
                coverImage: savedPostModel.coverImage,
                id: savedPostModel.uid,
                name: savedPostModel.name,
                mail: savedPostModel.mail,
                imageUrl: savedPostModel.profileImage,
                bio: savedPostModel.bio,
              );
              final String id = auth.currentUser!.uid;
              if (id == savedPostModel.uid) {
                return;
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      OtherProfileScreen(userModel: userModel),
                ));
              }
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            leading: savedPostModel.profileImage.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(savedPostModel.profileImage),
                  )
                : ClipOval(
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/joylink-logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            title: Text(
              savedPostModel.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle:savedPostModel.location.isNotEmpty?
             Text(savedPostModel.location):const Text('Null'),
            trailing: PopupHomeMenu(
              savedPostModel: savedPostModel,
              isSaveOrNot: isSaveOrNot,
            ),
          ),
          PostImageWidget(savedPostModel: savedPostModel),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    savedPostModel.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  "Posted on: ${dateAndTime.formatRelativeTime(savedPostModel.date)}",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          LikeAndCommentButtons(postId: savedPostModel.postId),
          const SizedBox(height: 10), // Added space for better UI
        ],
      ),
    );
  }
}
