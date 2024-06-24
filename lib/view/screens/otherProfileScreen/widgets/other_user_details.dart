import 'package:flutter/material.dart';
import 'package:joylink/model/model/search_model.dart';

class OtherProfileUserDetails extends StatelessWidget {
  const OtherProfileUserDetails({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    String bio = userModel.bio;
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userModel.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          Text(
            userModel.bio.isNotEmpty ? "Bio : $bio" : "Bio: Null",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
