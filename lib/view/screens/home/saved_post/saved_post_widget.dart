import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joylink/model/models/saved_post_model.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/utils/media_quary.dart';
import 'package:joylink/view/screens/home/image_preview.dart';
import 'package:joylink/view/screens/home/popup_menu_button.dart';
import 'package:joylink/viewmodel/controller/date_and_time/date_and_time.dart';

class SavedUsersPostCard extends StatelessWidget {
  SavedUsersPostCard(
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
            subtitle: Text(savedPostModel.location),
            trailing: PopupHomeMenu(
              savedPostModel: savedPostModel,
              isSaveOrNot: isSaveOrNot,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImagePreviewScreen(
                      description: savedPostModel.description,
                      imageUrl: savedPostModel.postImage,
                    ))),
            child: Container(
              width: double.infinity,
              height: mediaqueryHeight(0.2, context),
              decoration: const BoxDecoration(
                color: AppColors.greyColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              child: Image.network(
                savedPostModel.postImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  double? progress = loadingProgress.expectedTotalBytes != null
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
          ),
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
      
          const SizedBox(height: 10), // Added space for better UI
        ],
      ),
    );
  }
}
