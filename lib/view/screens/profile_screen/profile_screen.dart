import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joylink/view/screens/profile_screen/user_post.dart';
import 'package:joylink/view/screens/profile_screen/widgets/profile_buttons.dart';
import 'package:joylink/view/screens/profile_screen/widgets/profile_picture.dart';
import 'package:joylink/view/screens/profile_screen/userdata/userdata.dart';
import 'package:joylink/core/utils/functions/date_and_time/date_and_time.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});
  final DateAndTime dateAndTime = DateAndTime();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: UserPosts(deleteOrSave: true,currentUserId: FirebaseAuth.instance.currentUser
                  !.uid,),
            )
          ],
        ),
      ),
    );
  }
}
