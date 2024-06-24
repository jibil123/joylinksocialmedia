import 'package:flutter/material.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/view/screens/home/savedPost/saved_post.dart';
import 'package:joylink/view/screens/profileScreen/userReel/user_reel.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    super.key,
    required this.currentUserId,
    required this.profileScreen
  });
  final String currentUserId;
  final bool profileScreen;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.teal[300], borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {},
                child: const Text('Activities',
                    style: TextStyle(color: AppColors.whiteColor))),
            Container(
              height: 25,
              width: 2.0,
              color: AppColors.greyColor,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          UserReelScreen(currentUserId: currentUserId)));
                },
                child: const Text(
                  'Reel',
                  style: TextStyle(color: AppColors.whiteColor),
                )),
            if (profileScreen) ...[
              Container(
                height: 25,
                width: 2.0,
                color: AppColors.greyColor,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SavedPostScreen(
                              isSaved: false, currentUserId: currentUserId,
                            )));
                  },
                  child: const Text(
                    'Saved Post',
                    style: TextStyle(color: AppColors.whiteColor),
                  )),
            ]
          ],
        ),
      ),
    );
  }
}
