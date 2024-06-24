import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joylink/view/screens/profileScreen/user_post.dart';
import 'package:joylink/view/screens/profileScreen/widgets/profile_buttons.dart';
import 'package:joylink/view/screens/profileScreen/widgets/profile_picture.dart';
import 'package:joylink/view/screens/profileScreen/userdata/userdata.dart';
import 'package:joylink/viewModel/date_and_time/date_and_time.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});
  final DateAndTime dateAndTime = DateAndTime();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfilePhotoScreen(),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ProfileInfo(),
            ),
            const SizedBox(
              height: 15,
            ),
             ProfileButtons(currentUserId:  FirebaseAuth.instance.currentUser
                !.uid,profileScreen: true,),
            UserPosts(deleteOrSave: true,currentUserId: FirebaseAuth.instance.currentUser
                !.uid,)
          ],
        ),
      ),
    );
  }
}
