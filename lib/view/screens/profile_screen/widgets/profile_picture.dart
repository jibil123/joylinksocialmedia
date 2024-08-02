import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joylink/view/screens/profile_screen/widgets/cover_image.dart';
import 'package:joylink/view/screens/profile_screen/widgets/follow_text_widget.dart';
import 'package:joylink/view/screens/profile_screen/widgets/profile_photo.dart';
import 'package:joylink/view/screens/profile_screen/widgets/userListScreen/followers_list.dart';
import 'package:joylink/view/screens/profile_screen/widgets/userListScreen/following_list.dart';

class ProfilePhotoScreen extends StatelessWidget {
  ProfilePhotoScreen({super.key});
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 375,
      width: double.infinity,
      child: Stack(
        children: [
          const SizedBox(height: 250,width: double.infinity, child: CoverImage()),
          StreamBuilder<DocumentSnapshot>(
            stream: firestore
                .collection('user details')
                .doc(firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final data = snapshot.data!.data() as Map<String, dynamic>?;

              final follow = (data?['followers'] as List?) ?? [];
              final following = (data?['following'] as List?) ?? [];
              return Positioned(
                top: 260,
                right: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FollowingListScreen(
                                initialUserIds: following),
                          ),
                        );
                      },
                      child: followFunction('Following ', following.length),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                FollowersListScreen(initialUserIds: follow),
                          ),
                        );
                      },
                      child: followFunction('Followers ', follow.length),
                    ),
                  ],
                ),
              );
            },
          ),
          const Positioned(
            top: 200,
            left: 10,
            child: ProfilePhoto(),
          ),
        ],
      ),
    );
  }
}
