import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/followBloc/follow_bloc.dart';
import 'package:joylink/model/model/search_model.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/view/screens/chatScreen/message_screen.dart';
import 'package:joylink/view/screens/profileScreen/widgets/follow_text_widget.dart';
import 'package:joylink/viewModel/firebase/follow_unfollow/follow_unfollow.dart';

class OtherProfileStack extends StatelessWidget {
  OtherProfileStack({super.key, required this.userModel});
  final UserModel userModel;
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowBloc(UserService()),
      child: SizedBox(
        height: 380,
        child: Stack(
          children: [
            userModel.coverImage.isNotEmpty
                ? FadeInImage.assetNetwork(
                  placeholder: 'assets/images/cover_photo.jpg',
                    image:  userModel.coverImage,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Image(
                    height: 250,
                    width: double.infinity,
                    image: AssetImage('assets/images/cover_photo.jpg'),
                    fit: BoxFit.cover,
                  ),
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: AppColors.blackColor,
                  )),
            ),
            Positioned(
              top: 200,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.whiteColor, width: 5),
                ),
                child: userModel.imageUrl.isNotEmpty
                    ? CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(userModel.imageUrl),
                      )
                    : const CircleAvatar(
                        radius: 80,
                        backgroundColor: AppColors.primaryColor,
                        child: ClipOval(
                          child: Image(
                            image: AssetImage('assets/images/pngegg.png'),
                          ),
                        ),
                      ),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('user details')
                    .doc(userModel.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final data = snapshot.data!.data() as Map<String, dynamic>?;

                  final follow = (data?['followers'] as List?) ?? [];
                  final following = (data?['following'] as List?) ?? [];

                  return Positioned(
                    top: 260, // Adjusted top position
                    right: 10, // Adjusted right position
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 205,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              followFunction('Following ', following.length),
                              // const SizedBox(width: 15),
                              followFunction('Followers ', follow.length),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            BlocBuilder<FollowBloc, FollowState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    if (follow.contains(
                                        firebaseAuth.currentUser!.uid)) {
                                      context.read<FollowBloc>().add(
                                          UnfollowUserEvent(
                                              firebaseAuth.currentUser!.uid,
                                              userModel.id));
                                    } else {
                                      context.read<FollowBloc>().add(
                                          FollowUserEvent(
                                              currentUserId:
                                                  firebaseAuth.currentUser!.uid,
                                              targetUserId: userModel.id));
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 27,
                                    decoration: BoxDecoration(
                                        color: AppColors.tealColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Text(
                                        follow.contains(
                                                firebaseAuth.currentUser!.uid)
                                            ? 'Unfollow'
                                            : 'Follow',
                                        style: const TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  reciverId: userModel.id,
                                ),
                              )),
                              child: Container(
                                width: 100,
                                height: 27,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.tealColor,
                                ),
                                child: const Center(
                                  child: Text(
                                    'Message',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.whiteColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
