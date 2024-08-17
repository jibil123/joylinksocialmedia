import 'package:flutter/material.dart';
import 'package:joylink/core/models/search_model.dart';
import 'package:joylink/view/screens/other_profile_screen/widgets/profile_stack.dart';
import 'package:joylink/view/screens/other_profile_screen/widgets/other_user_details.dart';
import 'package:joylink/view/screens/profile_screen/user_post.dart';
import 'package:joylink/view/screens/profile_screen/widgets/profile_buttons.dart';

class OtherProfileScreen extends StatelessWidget {
   const OtherProfileScreen({super.key, required this.userModel,});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OtherProfileStack(userModel: userModel),
            OtherProfileUserDetails(userModel: userModel),
            const SizedBox(height: 10),
              ProfileButtons(currentUserId:userModel.id,profileScreen: false,),
             const SizedBox(height: 10),    
             UserPosts(deleteOrSave: false, currentUserId: userModel.id)
          ],
        ),
      ) ,
    );
  }
}